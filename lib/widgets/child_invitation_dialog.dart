import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/strings.dart';
import '../services/child_invitation.dart';
import 'surfaces.dart';

class ChildInvitationDialog extends StatelessWidget {
  const ChildInvitationDialog({
    super.key,
    required this.code,
    required this.strings,
    this.childName,
  });
  final String code;
  final String? childName;
  final Strings strings;

  @override
  Widget build(BuildContext context) {
    final link = ChildInvitation.link(code);
    final message = ChildInvitation.message(
      strings('childShareMessage'),
      code,
      '${strings('code')}:',
    );
    void notice(String text) => ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(text)));
    return AlertDialog(
      title: Text(strings('link')),
      scrollable: true,
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (childName != null) ...[
              Text(
                strings('childLinkFor').replaceAll('{name}', childName!),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
            ],
            Text(strings('childLinkWays')),
            const SizedBox(height: 16),
            Builder(
              builder: (buttonContext) => FilledButton.icon(
                icon: const Icon(Icons.message_outlined),
                label: Text(strings('childSendLink')),
                onPressed: () async {
                  final box = buttonContext.findRenderObject() as RenderBox;
                  try {
                    await SharePlus.instance.share(
                      ShareParams(
                        text: message,
                        subject: strings('pairTitle'),
                        sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size,
                      ),
                    );
                  } catch (_) {
                    if (context.mounted) notice(strings('shareFallback'));
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(strings('childShareApps'), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Text(
              strings('childScanQr'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox.square(
              dimension: (MediaQuery.sizeOf(context).width - 128).clamp(
                96.0,
                220.0,
              ),
              child: QrImageView(
                data: link,
                backgroundColor: paper,
                padding: const EdgeInsets.all(16),
                semanticsLabel: strings('childScanQr'),
              ),
            ),
            Text(strings('childQrHelp')),
            const SizedBox(height: 16),
            ExpansionTile(
              title: Text(strings('childManualCode')),
              children: [
                SelectableText(code),
                TextButton.icon(
                  icon: const Icon(Icons.copy),
                  label: Text(strings('copy')),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    if (context.mounted) notice(strings('copied'));
                  },
                ),
              ],
            ),
            Text(strings('childWifiHelp')),
            const SizedBox(height: 8),
            Text(strings('linkHelp')),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(strings('close')),
        ),
      ],
    );
  }
}
