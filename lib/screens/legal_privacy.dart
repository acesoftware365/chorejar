import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../widgets/surfaces.dart';

/// Plain-language privacy and family-data notice available before sign-in and
/// from the parent settings. It deliberately avoids legalese on the main page.
class LegalPrivacyScreen extends StatelessWidget {
  final Strings strings;
  const LegalPrivacyScreen({super.key, required this.strings});

  String t(String key) => strings(key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(t('privacyDetails'))),
    body: pageBody([
      Text(
        t('legalTitle'),
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: ink,
        ),
      ),
      const SizedBox(height: 8),
      Text(t('legalUpdated'), style: const TextStyle(color: muted)),
      const SizedBox(height: 20),
      _LegalSection(
        icon: Icons.lock_outline,
        title: t('legalDataTitle'),
        body: t('legalDataBody'),
      ),
      _LegalSection(
        icon: Icons.family_restroom,
        title: t('legalFamilyTitle'),
        body: t('legalFamilyBody'),
      ),
      _LegalSection(
        icon: Icons.ads_click_outlined,
        title: t('legalAdsTitle'),
        body: t('legalAdsBody'),
      ),
      _LegalSection(
        icon: Icons.workspace_premium_outlined,
        title: t('legalSubscriptionTitle'),
        body: t('legalSubscriptionBody'),
      ),
      _LegalSection(
        icon: Icons.manage_accounts_outlined,
        title: t('legalRightsTitle'),
        body: t('legalRightsBody'),
      ),
      _LegalSection(
        icon: Icons.info_outline,
        title: t('legalNoticeTitle'),
        body: t('legalNoticeBody'),
      ),
      _LegalSection(
        icon: Icons.mail_outline,
        title: t('legalContactTitle'),
        body: t('legalContactBody'),
      ),
    ]),
  );
}

class _LegalSection extends StatelessWidget {
  final IconData icon;
  final String title, body;
  const _LegalSection({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) => panel(
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: green),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(body, style: const TextStyle(height: 1.4, color: muted)),
            ],
          ),
        ),
      ],
    ),
  );
}
