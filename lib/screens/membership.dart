import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/strings.dart';
import '../services/advertising.dart';
import '../services/membership.dart';
import '../widgets/surfaces.dart';

class MembershipScreen extends StatefulWidget {
  final Strings strings;
  const MembershipScreen({super.key, required this.strings});
  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  @override
  void initState() {
    super.initState();
    Membership.instance.start();
  }

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

  String _price(Membership membership, PremiumPlan plan) =>
      membership.productFor(plan)?.price ??
      widget.strings(
        plan == PremiumPlan.monthly ? 'monthlyPlanPrice' : 'yearlyPlanPrice',
      );

  Widget _planCard(Membership membership, PremiumPlan plan) {
    final annual = plan == PremiumPlan.yearly;
    final enabled = membership.canPurchase(plan);
    return panel(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.strings(
                    annual ? 'yearlyPlanTitle' : 'monthlyPlanTitle',
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (annual)
                Chip(
                  label: Text(widget.strings('bestValue')),
                  backgroundColor: paleGold,
                ),
            ],
          ),
          Text(
            _price(membership, plan),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: green,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(widget.strings(annual ? 'yearlyPlanTerms' : 'monthlyPlanTerms')),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: enabled ? () => membership.purchase(plan) : null,
            child: Text(
              membership.processing
                  ? widget.strings('membershipWorking')
                  : widget.strings(
                      annual ? 'chooseYearlyPlan' : 'chooseMonthlyPlan',
                    ),
            ),
          ),
        ],
      ),
      color: annual ? mint : paper,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.strings('membership'))),
    body: ListenableBuilder(
      listenable: Listenable.merge(<Listenable>[
        Advertising.instance,
        Membership.instance,
      ]),
      builder: (context, _) {
        final ads = Advertising.instance;
        final membership = Membership.instance;
        final body = <Widget>[
          heading(widget.strings('freePlan')),
          panel(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.strings('freePlanDetails')),
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
          heading(widget.strings('premiumPlan')),
          Text(widget.strings('premiumPlanDetails')),
          const SizedBox(height: 12),
        ];
        if (membership.isPremium) {
          body.add(
            panel(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.strings('membershipPremiumActive'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(widget.strings('premiumPlanDetails')),
                  if (membership.entitlement.expiresAt != null)
                    Text(
                      '${widget.strings('membershipRenewsOrEnds')}: '
                      '${membership.entitlement.expiresAt!.toLocal()}',
                    ),
                  TextButton(
                    onPressed: membership.canRestore
                        ? membership.restore
                        : null,
                    child: Text(widget.strings('restorePurchases')),
                  ),
                ],
              ),
              color: mint,
            ),
          );
        } else {
          body.add(_planCard(membership, PremiumPlan.monthly));
          body.add(_planCard(membership, PremiumPlan.yearly));
          if (!membership.configured) {
            body.add(
              Text(
                widget.strings('membershipPreparing'),
                style: const TextStyle(color: muted),
              ),
            );
          } else if (membership.state == MembershipState.loading) {
            body.add(const Center(child: CircularProgressIndicator()));
          } else if (membership.state == MembershipState.unavailable) {
            body.add(
              Text(
                widget.strings('membershipStoreUnavailable'),
                style: const TextStyle(color: muted),
              ),
            );
          }
          body.add(
            TextButton.icon(
              onPressed: membership.canRestore ? membership.restore : null,
              icon: const Icon(Icons.restore),
              label: Text(widget.strings('restorePurchases')),
            ),
          );
        }
        if (membership.messageKey != null) {
          body.add(
            Text(
              widget.strings(membership.messageKey!),
              style: TextStyle(
                color: membership.isPremium ? green : danger,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }
        body.addAll(<Widget>[
          const SizedBox(height: 8),
          Text(
            widget.strings('membershipTerms'),
            style: const TextStyle(color: muted),
          ),
          const SizedBox(height: 20),
          Text(
            widget.strings('adReportTitle'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(widget.strings('adReportHelp')),
          TextButton.icon(
            onPressed: _reportAd,
            icon: const Icon(Icons.flag_outlined),
            label: Text(widget.strings('adReport')),
          ),
        ]);
        return pageBody(body);
      },
    ),
  );
}
