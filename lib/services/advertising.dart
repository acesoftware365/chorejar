import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Live delivery stays off until account IDs and children's privacy review exist.
class AdConfiguration {
  static const enabled = bool.fromEnvironment('ADS_ENABLED');
  static const testMode = !bool.fromEnvironment('ADS_LIVE');
  static bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  static String get banner => defaultTargetPlatform == TargetPlatform.android
      ? (testMode
            ? 'ca-app-pub-3940256099942544/6300978111'
            : const String.fromEnvironment('ANDROID_BANNER_ID'))
      : (testMode
            ? 'ca-app-pub-3940256099942544/2934735716'
            : const String.fromEnvironment('IOS_BANNER_ID'));
  static String get rewarded => defaultTargetPlatform == TargetPlatform.android
      ? (testMode
            ? 'ca-app-pub-3940256099942544/5224354917'
            : const String.fromEnvironment('ANDROID_REWARDED_ID'))
      : (testMode
            ? 'ca-app-pub-3940256099942544/1712485313'
            : const String.fromEnvironment('IOS_REWARDED_ID'));
  static bool get configured =>
      enabled && supported && banner.isNotEmpty && rewarded.isNotEmpty;
}

class Advertising extends ChangeNotifier {
  static final instance = Advertising();
  bool ready = false;
  bool rewardBusy = false;
  bool privacyOptionsRequired = false;
  DateTime? quietUntil;
  Future<void>? _initializing;
  Timer? _expiry;
  bool get quiet => quietUntil?.isAfter(DateTime.now()) ?? false;
  bool get showBanner => ready && !quiet;
  static const request = AdRequest(nonPersonalizedAds: true);

  Future<void> initializeForParent() => _initializing ??= _initialize();
  Future<void> _initialize() async {
    if (!AdConfiguration.configured) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final until = prefs.getInt('adsQuietUntil');
      quietUntil = until == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(until);
      _scheduleExpiry();
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          maxAdContentRating: MaxAdContentRating.g,
          ageRestrictedTreatment: AgeRestrictedTreatment.child,
        ),
      );
      if (!AdConfiguration.testMode) {
        final consent = Completer<bool>();
        ConsentInformation.instance.requestConsentInfoUpdate(
          ConsentRequestParameters(tagForUnderAgeOfConsent: true),
          () => ConsentForm.loadAndShowConsentFormIfRequired((error) async {
            if (!consent.isCompleted) {
              consent.complete(
                error == null &&
                    await ConsentInformation.instance.canRequestAds(),
              );
            }
          }),
          (_) {
            if (!consent.isCompleted) consent.complete(false);
          },
        );
        if (!await consent.future.timeout(
          const Duration(seconds: 30),
          onTimeout: () => false,
        )) {
          return;
        }
        privacyOptionsRequired =
            await ConsentInformation.instance
                .getPrivacyOptionsRequirementStatus() ==
            PrivacyOptionsRequirementStatus.required;
      }
      await MobileAds.instance.initialize();
      ready = true;
      notifyListeners();
    } catch (_) {
      ready = false; // The app remains usable when advertising is unavailable.
    }
  }

  void _scheduleExpiry() {
    _expiry?.cancel();
    if (quiet) {
      _expiry = Timer(quietUntil!.difference(DateTime.now()), notifyListeners);
    }
  }

  Future<void> privacyOptions() async {
    if (!privacyOptionsRequired) return;
    final done = Completer<void>();
    ConsentForm.showPrivacyOptionsForm((_) async {
      ready = await ConsentInformation.instance.canRequestAds();
      notifyListeners();
      if (!done.isCompleted) done.complete();
    });
    await done.future;
  }

  /// A voluntary, non-monetary reward limited to this device. Never edits balances.
  Future<bool> watchForQuietDay() async {
    if (!ready || rewardBusy || quiet) return false;
    rewardBusy = true;
    notifyListeners();
    final result = Completer<bool>();
    var earned = false;
    Future<void>? save;
    final loadTimeout = Timer(const Duration(seconds: 30), () {
      if (!result.isCompleted) result.complete(false);
    });
    try {
      await RewardedAd.load(
        adUnitId: AdConfiguration.rewarded,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdFailedToLoad: (_) {
            if (!result.isCompleted) result.complete(false);
          },
          onAdLoaded: (ad) {
            if (result.isCompleted) {
              ad.dispose();
              return;
            }
            loadTimeout.cancel();
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) async {
                ad.dispose();
                try {
                  await save;
                } catch (_) {
                  earned = false;
                }
                if (!result.isCompleted) result.complete(earned);
              },
              onAdFailedToShowFullScreenContent: (ad, _) {
                ad.dispose();
                if (!result.isCompleted) result.complete(false);
              },
            );
            ad
                .show(
                  onUserEarnedReward: (_, _) {
                    earned = true;
                    quietUntil = DateTime.now().add(const Duration(hours: 24));
                    save = SharedPreferences.getInstance().then((prefs) async {
                      await prefs.setInt(
                        'adsQuietUntil',
                        quietUntil!.millisecondsSinceEpoch,
                      );
                    });
                    _scheduleExpiry();
                    notifyListeners();
                  },
                )
                .catchError((Object error) {
                  ad.dispose();
                  if (!result.isCompleted) result.complete(false);
                });
          },
        ),
      );
      return await result.future;
    } catch (_) {
      return false;
    } finally {
      loadTimeout.cancel();
      rewardBusy = false;
      notifyListeners();
    }
  }
}
