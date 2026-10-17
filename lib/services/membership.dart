import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';

/// Store product identifiers are shared by App Store Connect and Google Play.
/// The same identifiers must never be reused for a different benefit.
class PremiumPlan {
  final String id;
  final String cadence;
  final String referencePrice;
  const PremiumPlan._(this.id, this.cadence, this.referencePrice);

  static const monthly = PremiumPlan._(
    'chorejar_premium_monthly',
    'monthly',
    r'$0.99 USD',
  );
  static const yearly = PremiumPlan._(
    'chorejar_premium_yearly',
    'yearly',
    r'$9.99 USD',
  );
  static const values = <PremiumPlan>[monthly, yearly];
  static const ids = <String>{
    'chorejar_premium_monthly',
    'chorejar_premium_yearly',
  };

  static PremiumPlan? fromId(String id) {
    for (final plan in values) {
      if (plan.id == id) return plan;
    }
    return null;
  }
}

/// Checkout stays off unless a release explicitly supplies both this flag and
/// an HTTPS server verifier. This avoids accepting a receipt only on-device.
class MembershipConfiguration {
  static const enabled = bool.fromEnvironment(
    'SUBSCRIPTIONS_ENABLED',
    defaultValue: false,
  );
  static const verifierUrl = String.fromEnvironment('SUBSCRIPTION_VERIFY_URL');

  static Uri? get verifier {
    final value = Uri.tryParse(verifierUrl);
    return value != null && value.scheme == 'https' && value.hasAuthority
        ? value
        : null;
  }

  static bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  static bool get checkoutConfigured =>
      enabled && supported && verifier != null;
}

class MembershipEntitlement {
  final bool active;
  final String? productId;
  final DateTime? expiresAt;
  const MembershipEntitlement({
    required this.active,
    this.productId,
    this.expiresAt,
  });

  factory MembershipEntitlement.fromJson(Map<String, dynamic> json) {
    final rawExpiry = json['expiresAt'];
    return MembershipEntitlement(
      active: json['active'] == true,
      productId: json['productId'] as String?,
      expiresAt: rawExpiry is String
          ? DateTime.tryParse(rawExpiry)?.toLocal()
          : null,
    );
  }
}

/// Contract for the server that validates App Store and Google Play purchases.
/// The app never treats a client receipt as a membership on its own.
abstract class MembershipVerifier {
  bool get configured;
  Future<MembershipEntitlement> status();
  Future<MembershipEntitlement> verify(PurchaseDetails purchase);
}

class HttpMembershipVerifier implements MembershipVerifier {
  final Uri? endpoint;
  http.Client? _client;
  HttpMembershipVerifier({Uri? endpoint, http.Client? client})
    : endpoint = endpoint ?? MembershipConfiguration.verifier,
      _client = client;

  http.Client get client => _client ??= http.Client();

  @override
  bool get configured => endpoint != null;

  Future<MembershipEntitlement> _request(
    String action, [
    PurchaseDetails? purchase,
  ]) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) {
      throw StateError('membershipAccountRequired');
    }
    final idToken = await user.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      throw StateError('membershipAccountRequired');
    }
    final response = await client
        .post(
          endpoint!,
          headers: <String, String>{
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, Object?>{
            'action': action,
            'platform': defaultTargetPlatform.name,
            if (purchase != null) ...<String, Object?>{
              'productId': purchase.productID,
              'purchaseId': purchase.purchaseID,
              'transactionDate': purchase.transactionDate,
              'verificationSource': purchase.verificationData.source,
              // This is delivered directly to the verifier over HTTPS and is
              // never written to logs, preferences, or Firestore by the app.
              'serverVerificationData':
                  purchase.verificationData.serverVerificationData,
            },
          }),
        )
        .timeout(const Duration(seconds: 20));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('membershipVerificationFailed');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw StateError('membershipVerificationFailed');
    }
    return MembershipEntitlement.fromJson(decoded);
  }

  @override
  Future<MembershipEntitlement> status() => _request('status');

  @override
  Future<MembershipEntitlement> verify(PurchaseDetails purchase) =>
      _request('verify', purchase);
}

enum MembershipState { preparing, loading, ready, unavailable, error }

/// Parent-only subscription controller. Access is only granted after the
/// server validates an App Store or Google Play transaction for the signed-in
/// adult account. A linked child device never starts this controller.
class Membership extends ChangeNotifier {
  Membership({MembershipVerifier? verifier})
    : _verifier = verifier ?? HttpMembershipVerifier();

  static final instance = Membership();
  final MembershipVerifier _verifier;
  InAppPurchase? _store;
  StreamSubscription<List<PurchaseDetails>>? _updates;
  Future<void>? _starting;
  final Map<String, ProductDetails> _products = <String, ProductDetails>{};

  MembershipState state = MembershipState.preparing;
  MembershipEntitlement entitlement = const MembershipEntitlement(
    active: false,
  );
  String? messageKey;
  bool processing = false;

  bool get active => entitlement.active;
  bool get configured =>
      MembershipConfiguration.checkoutConfigured && _verifier.configured;
  bool get isPremium => active;
  // Until a configured verifier gives a current answer, prefer no banner over
  // briefly showing ads to a parent who has already paid on another device.
  bool get shouldHideBanner =>
      isPremium || (configured && state != MembershipState.ready);
  bool get canRestore =>
      configured && state == MembershipState.ready && !processing;
  bool canPurchase(PremiumPlan plan) =>
      canRestore && _products.containsKey(plan.id) && !isPremium;
  ProductDetails? productFor(PremiumPlan plan) => _products[plan.id];

  Future<void> start() => _starting ??= _start();

  Future<void> _start() async {
    if (!configured) {
      state = MembershipState.preparing;
      notifyListeners();
      return;
    }
    _store = InAppPurchase.instance;
    _updates = _store!.purchaseStream.listen(
      _onPurchases,
      onError: (_) {
        messageKey = 'membershipPurchaseFailed';
        processing = false;
        notifyListeners();
      },
    );
    await refresh();
  }

  Future<void> refresh() async {
    if (!configured) {
      state = MembershipState.preparing;
      notifyListeners();
      return;
    }
    state = MembershipState.loading;
    messageKey = null;
    notifyListeners();
    try {
      final store = _store ??= InAppPurchase.instance;
      if (!await store.isAvailable()) {
        state = MembershipState.unavailable;
        notifyListeners();
        return;
      }
      final response = await store.queryProductDetails(PremiumPlan.ids);
      _products
        ..clear()
        ..addEntries(
          response.productDetails.map((item) => MapEntry(item.id, item)),
        );
      if (response.error != null ||
          PremiumPlan.values.any((plan) => !_products.containsKey(plan.id))) {
        state = MembershipState.unavailable;
        notifyListeners();
        return;
      }
      entitlement = await _verifier.status();
      state = MembershipState.ready;
    } on StateError catch (error) {
      messageKey = error.message.toString();
      state = MembershipState.error;
    } catch (_) {
      messageKey = 'membershipStoreUnavailable';
      state = MembershipState.error;
    }
    notifyListeners();
  }

  Future<void> purchase(PremiumPlan plan) async {
    await start();
    final product = productFor(plan);
    if (!canPurchase(plan) || product == null) {
      messageKey = 'membershipNotReady';
      notifyListeners();
      return;
    }
    processing = true;
    messageKey = null;
    notifyListeners();
    try {
      final submitted = await _store!.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
      if (!submitted) {
        processing = false;
        messageKey = 'membershipPurchaseFailed';
        notifyListeners();
      }
    } catch (_) {
      processing = false;
      messageKey = 'membershipPurchaseFailed';
      notifyListeners();
    }
  }

  Future<void> restore() async {
    await start();
    if (!canRestore) {
      messageKey = 'membershipNotReady';
      notifyListeners();
      return;
    }
    processing = true;
    messageKey = null;
    notifyListeners();
    try {
      await _store!.restorePurchases();
    } catch (_) {
      processing = false;
      messageKey = 'membershipPurchaseFailed';
      notifyListeners();
    }
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (PremiumPlan.fromId(purchase.productID) == null) continue;
      if (purchase.status == PurchaseStatus.pending) {
        processing = true;
        notifyListeners();
        continue;
      }
      if (purchase.status == PurchaseStatus.error ||
          purchase.status == PurchaseStatus.canceled) {
        processing = false;
        messageKey = 'membershipPurchaseFailed';
        notifyListeners();
        continue;
      }
      if (purchase.status != PurchaseStatus.purchased &&
          purchase.status != PurchaseStatus.restored) {
        continue;
      }
      try {
        // A verifier response, including an inactive expired subscription,
        // settles a valid store transaction. A network failure leaves it for a
        // later retry instead of granting access from the device.
        entitlement = await _verifier.verify(purchase);
        if (purchase.pendingCompletePurchase) {
          await _store!.completePurchase(purchase);
        }
        messageKey = entitlement.active
            ? 'membershipVerified'
            : 'membershipNotActive';
      } catch (_) {
        messageKey = 'membershipVerificationFailed';
      }
      processing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _updates?.cancel();
    super.dispose();
  }
}
