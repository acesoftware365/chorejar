import 'package:flutter/material.dart';
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
        return pageBody([
          Text(
            strings('freePlan'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(strings('freePlanDetails')),
          const SizedBox(height: 24),
          Text(
            'ChoreJar Plus',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(strings('plusDetails')),
          Card(
            child: ListTile(
              title: Text(strings('monthlyPlan')),
              subtitle: const Text('0.99 USD'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(strings('yearlyPlan')),
              subtitle: const Text('9.99 USD'),
            ),
          ),
          Text(strings('plansPending')),
          const SizedBox(height: 24),
          Text(
            strings('rewardTitle'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(strings('rewardDetails')),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.ondemand_video),
            label: Text(
              strings(
                ads.quiet
                    ? 'rewardActive'
                    : ads.rewardBusy
                    ? 'loading'
                    : 'watchReward',
              ),
            ),
            onPressed: !ads.ready || ads.quiet || ads.rewardBusy
                ? null
                : () async {
                    final earned = await ads.watchForQuietDay();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            strings(
                              earned ? 'rewardActive' : 'rewardUnavailable',
                            ),
                          ),
                        ),
                      );
                    }
                  },
          ),
          if (!ads.ready) Text(strings('adsPending')),
          if (ads.privacyOptionsRequired)
            TextButton(
              onPressed: ads.privacyOptions,
              child: Text(strings('adPrivacy')),
            ),
        ]);
      },
    ),
  );
}
