import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/advertising.dart';

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
  Widget build(BuildContext context) {
    if (!loaded ||
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
          Text(
            widget.spanish ? 'Publicidad' : 'Advertisement',
            style: const TextStyle(fontSize: 10),
          ),
          SizedBox(width: 320, height: 50, child: AdWidget(ad: ad!)),
        ],
      ),
    );
  }
}
