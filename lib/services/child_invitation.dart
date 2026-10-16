import 'invitation_link.dart';

/// A child invitation never accepts a parent-access route.
class ChildInvitation {
  static String link(String code) => InvitationLink.link('join-child', code);
  static String? parse(String input) =>
      InvitationLink.parse(input, 'join-child');
  static String message(String introduction, String code, String fallback) =>
      InvitationLink.message(introduction, 'join-child', code, fallback);
}
