import 'invitation_link.dart';

/// Only our parent invitation route (or its raw fallback code) is accepted.
class ParentInvitation {
  static String link(String code) => InvitationLink.link('join-parent', code);
  static String? parse(String input) =>
      InvitationLink.parse(input, 'join-parent');
}
