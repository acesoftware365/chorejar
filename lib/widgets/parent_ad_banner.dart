import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../app_metadata.dart';
import '../services/advertising.dart';
import '../services/membership.dart';

/// Separate slot below navigation; never covers controls or the keyboard.
class ParentAdBanner extends StatefulWidget {
  final bool spanish;
  const ParentAdBanner({super.key, required this.spanish});
  @override
  State<ParentAdBanner> createState() => _ParentAdBannerState();
}

class _ParentAdBannerState extends State<ParentAdBanner> {
  BannerAd? ad;
  bool loaded = false;
  @override
  void initState() {
    super.initState();
    ad = BannerAd(
      adUnitId: AdConfiguration.banner,
      size: AdSize.banner,
      request: Advertising.request,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => loaded = true);
        },
        onAdFailedToLoad: (failed, _) {
          failed.dispose();
          ad = null;
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Membership.instance,
    builder: (context, _) {
      if (Membership.instance.shouldHideBanner ||
          !loaded ||
          ad == null ||
          MediaQuery.viewInsetsOf(context).bottom > 0 ||
          MediaQuery.sizeOf(context).width < 320) {
        return const SizedBox.shrink();
      }
      return SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            Semantics(
              label:
                  '${widget.spanish ? 'Publicidad' : 'Advertisement'} — '
                  'ChoreJar v$appReleaseLabel',
              child: Text(
                'ChoreJar v$appReleaseLabel · '
                '${widget.spanish ? 'Publicidad' : 'Advertisement'}',
                style: const TextStyle(
                  fontSize: 10,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 320, height: 50, child: AdWidget(ad: ad!)),
          ],
        ),
      );
    },
  );
}
