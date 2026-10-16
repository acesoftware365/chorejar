import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/strings.dart';
import '../services/advertising.dart';
import '../widgets/surfaces.dart';

class MembershipScreen extends StatelessWidget {
  final Strings strings;
  const MembershipScreen({super.key, required this.strings});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(strings('membership'))),
    body: ListenableBuilder(
      listenable: Advertising.instance,
      builder: (context, _) {
        final ads = Advertising.instance;
        Future<void> reportAd() async {
          final subject = strings('adReportSubject');
          final body = strings('adReportBody');
          final uri = Uri(
            scheme: 'mailto',
            path: 'sales@liisgo.com',
            queryParameters: {'subject': subject, 'body': body},
          );
          final opened = await launchUrl(uri);
          if (!opened && context.mounted) {
            await Clipboard.setData(
              ClipboardData(text: 'sales@liisgo.com\n$subject\n\n$body'),
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(strings('adReportCopied'))),
              );
            }
          }
        }

        return pageBody([
          Text(
            strings('freePlan'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(strings('freePlanDetails')),
          const SizedBox(height: 24),
          Text(
            strings('membershipComingSoon'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(strings('plansPending')),
          if (!ads.ready) Text(strings('adsPending')),
          if (ads.privacyOptionsRequired)
            TextButton(
              onPressed: ads.privacyOptions,
              child: Text(strings('adPrivacy')),
            ),
          const SizedBox(height: 18),
          Text(
            strings('adReportTitle'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(strings('adReportHelp')),
          TextButton.icon(
            onPressed: reportAd,
            icon: const Icon(Icons.flag_outlined),
            label: Text(strings('adReport')),
          ),
        ]);
      },
    ),
  );
}
