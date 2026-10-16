import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Live delivery stays off until account IDs and children's privacy review exist.
class AdConfiguration {
  // Development builds show Google's test inventory by default. Live units
  // remain opt-in through ADS_LIVE plus the production unit IDs at build time.
  static const enabled = bool.fromEnvironment(
    'ADS_ENABLED',
    defaultValue: true,
  );
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
  static bool get configured => enabled && supported && banner.isNotEmpty;
}

class Advertising extends ChangeNotifier {
  static final instance = Advertising();
  bool ready = false;
  bool privacyOptionsRequired = false;
  Future<void>? _initializing;
  bool get showBanner => ready;
  static const request = AdRequest(nonPersonalizedAds: true);

  Future<void> initializeForParent() => _initializing ??= _initialize();
  Future<void> _initialize() async {
    if (!AdConfiguration.configured) return;
    try {
      // Keep the Google SDK's iOS same-app identifier off. Ads are limited to
      // the adult parent area and are always configured for child treatment.
      await MobileAds.instance.setSameAppKeyEnabled(false);
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
}
