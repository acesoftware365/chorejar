import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/strings.dart';
import '../services/advertising.dart';
import '../widgets/surfaces.dart';

/// Parent-only advertising controls. Subscription checkout is intentionally not
/// presented until the store products and server verification are complete.
class MembershipScreen extends StatefulWidget {
  final Strings strings;
  final bool parentAuthorized;
  const MembershipScreen({
    super.key,
    required this.strings,
    required this.parentAuthorized,
  });

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  static final _privacyUrl = Uri.parse(
    'https://chorejar-liisgo-2026.web.app/privacy',
  );
  static final _termsUrl = Uri.parse(
    'https://chorejar-liisgo-2026.web.app/terms',
  );

  Future<void> _reportAd() async {
    final subject = widget.strings('adReportSubject');
    final body = widget.strings('adReportBody');
    final uri = Uri(
      scheme: 'mailto',
      path: 'sales@liisgo.com',
      queryParameters: {'subject': subject, 'body': body},
    );
    final opened = await launchUrl(uri);
    if (!opened && mounted) {
      await Clipboard.setData(
        ClipboardData(text: 'sales@liisgo.com\n$subject\n\n$body'),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.strings('adReportCopied'))),
        );
      }
    }
  }

  Future<void> _openLegal(Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.strings('legalOpenFailed'))),
      );
    }
  }

  Widget _parentOnly() => Scaffold(
    appBar: AppBar(title: Text(widget.strings('membership'))),
    body: pageBody([
      heading(widget.strings('premiumParentOnlyTitle')),
      panel(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lock_outline, color: green, size: 30),
            const SizedBox(height: 12),
            Text(
              widget.strings('premiumParentOnlyBody'),
              style: const TextStyle(color: muted, height: 1.4),
            ),
          ],
        ),
        color: mint,
      ),
    ]),
  );

  @override
  Widget build(BuildContext context) {
    if (!widget.parentAuthorized) return _parentOnly();
    return Scaffold(
      appBar: AppBar(title: Text(widget.strings('membership'))),
      body: ListenableBuilder(
        listenable: Advertising.instance,
        builder: (context, _) {
          final ads = Advertising.instance;
          return pageBody([
            heading(widget.strings('freePlan')),
            panel(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.strings('freePlanDetails'),
                    style: const TextStyle(color: muted, height: 1.35),
                  ),
                  if (!ads.ready) ...[
                    const SizedBox(height: 8),
                    Text(widget.strings('adsPending')),
                  ],
                  if (ads.privacyOptionsRequired)
                    TextButton(
                      onPressed: ads.privacyOptions,
                      child: Text(widget.strings('adPrivacy')),
                    ),
                ],
              ),
            ),
            heading(widget.strings('adReportTitle')),
            panel(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.strings('adReportHelp'),
                    style: const TextStyle(color: muted, height: 1.35),
                  ),
                  TextButton.icon(
                    onPressed: _reportAd,
                    icon: const Icon(Icons.flag_outlined),
                    label: Text(widget.strings('adReport')),
                  ),
                ],
              ),
              color: mint,
            ),
            heading(widget.strings('premiumBillingTitle')),
            panel(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.strings('membershipComingSoon'),
                    style: const TextStyle(color: muted, height: 1.35),
                  ),
                  TextButton.icon(
                    onPressed: () => _openLegal(_privacyUrl),
                    icon: const Icon(Icons.privacy_tip_outlined),
                    label: Text(widget.strings('readPrivacyPolicy')),
                  ),
                  TextButton.icon(
                    onPressed: () => _openLegal(_termsUrl),
                    icon: const Icon(Icons.description_outlined),
                    label: Text(widget.strings('readTermsOfUse')),
                  ),
                ],
              ),
            ),
          ], adaptiveColumns: true);
        },
      ),
    );
  }
}
