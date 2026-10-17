import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/strings.dart';
import '../services/advertising.dart';
import '../services/membership.dart';
import '../widgets/surfaces.dart';

/// Parent-only purchase and advertising controls. A child session cannot open
/// this screen from the dashboard and is also blocked by [parentAuthorized].
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

  @override
  void initState() {
    super.initState();
    if (widget.parentAuthorized) Membership.instance.start();
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

  Future<void> _openLegal(Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.strings('legalOpenFailed'))),
      );
    }
  }

  String _price(Membership membership, PremiumPlan plan) =>
      membership.productFor(plan)?.price ??
      widget.strings(
        plan == PremiumPlan.monthly ? 'monthlyPlanPrice' : 'yearlyPlanPrice',
      );

  Widget _feature(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(top: 9),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: green, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: const TextStyle(color: ink)),
        ),
      ],
    ),
  );

  Widget _hero(Membership membership) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: ink,
      borderRadius: BorderRadius.circular(26),
      boxShadow: const [
        BoxShadow(
          color: Color(0x29073836),
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: paleGold,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.workspace_premium_rounded, color: ink),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.strings(
                  membership.isPremium
                      ? 'membershipPremiumActive'
                      : 'premiumPlan',
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.strings('premiumParentOnlyBody'),
                style: const TextStyle(color: Color(0xFFE3F4ED), height: 1.35),
              ),
            ],
          ),
        ),
      ],
    ),
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
          const SizedBox(height: 2),
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
        listenable: Listenable.merge(<Listenable>[
          Advertising.instance,
          Membership.instance,
        ]),
        builder: (context, _) {
          final ads = Advertising.instance;
          final membership = Membership.instance;
          final body = <Widget>[
            _hero(membership),
            heading(widget.strings('premiumBenefitsTitle')),
            panel(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.strings('premiumPlanDetails'),
                    style: const TextStyle(color: muted, height: 1.35),
                  ),
                  _feature(
                    Icons.block_outlined,
                    widget.strings('premiumBenefitNoAds'),
                  ),
                  _feature(
                    Icons.child_care_outlined,
                    widget.strings('premiumBenefitChildren'),
                  ),
                  _feature(
                    Icons.check_circle_outline,
                    widget.strings('premiumBenefitCore'),
                  ),
                ],
              ),
              color: mint,
            ),
            KeyedSubtree(
              key: const Key('section-start'),
              child: heading(widget.strings('freePlan')),
            ),
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
            if (membership.isPremium)
              panel(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.strings('membershipPremiumActive'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(widget.strings('premiumPlanDetails')),
                    if (membership.entitlement.expiresAt != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${widget.strings('membershipRenewsOrEnds')}: '
                        '${membership.entitlement.expiresAt!.toLocal()}',
                      ),
                    ],
                    TextButton.icon(
                      onPressed: membership.canRestore
                          ? membership.restore
                          : null,
                      icon: const Icon(Icons.restore),
                      label: Text(widget.strings('restorePurchases')),
                    ),
                  ],
                ),
                color: mint,
              )
            else ...[
              _planCard(membership, PremiumPlan.monthly),
              _planCard(membership, PremiumPlan.yearly),
              if (!membership.configured)
                panel(
                  Text(
                    widget.strings('membershipPreparing'),
                    style: const TextStyle(color: muted, height: 1.35),
                  ),
                  color: paleGold,
                )
              else if (membership.state == MembershipState.loading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (membership.state == MembershipState.unavailable)
                Text(
                  widget.strings('membershipStoreUnavailable'),
                  style: const TextStyle(color: muted),
                ),
              TextButton.icon(
                onPressed: membership.canRestore ? membership.restore : null,
                icon: const Icon(Icons.restore),
                label: Text(widget.strings('restorePurchases')),
              ),
            ],
            if (membership.messageKey != null)
              Text(
                widget.strings(membership.messageKey!),
                style: TextStyle(
                  color: membership.isPremium ? green : danger,
                  fontWeight: FontWeight.w700,
                ),
              ),
            const SizedBox(height: 8),
            heading(widget.strings('premiumBillingTitle')),
            panel(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.strings('membershipTerms'),
                    style: const TextStyle(color: muted, height: 1.4),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.strings('premiumStorePrice'),
                    style: const TextStyle(color: muted, height: 1.4),
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
            heading(widget.strings('adReportTitle')),
            Text(widget.strings('adReportHelp')),
            TextButton.icon(
              onPressed: _reportAd,
              icon: const Icon(Icons.flag_outlined),
              label: Text(widget.strings('adReport')),
            ),
          ];
          return pageBody(body, adaptiveColumns: true);
        },
      ),
    );
  }
}
