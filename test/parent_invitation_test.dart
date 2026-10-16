import 'package:flutter_test/flutter_test.dart';
import 'package:chorejar/services/parent_invitation.dart';

void main() {
  const code = '0123456789abcdef0123456789abcdef';
  test('An invitation survives sharing as a link, message or backup code', () {
    expect(ParentInvitation.parse(ParentInvitation.link(code)), code);
    expect(
      ParentInvitation.parse('Invitación\n${ParentInvitation.link(code)}'),
      code,
    );
    expect(ParentInvitation.parse(code.toUpperCase()), code);
  });
  test('Other routes, websites and incomplete codes are not invitations', () {
    for (final input in [
      'https://example.com?code=$code',
      'chorejar://child?code=$code',
      'chorejar://join-parent/extra?code=$code',
      'chorejar://join-parent?code=123',
      'not a code',
    ]) {
      expect(ParentInvitation.parse(input), isNull);
    }
  });
}
