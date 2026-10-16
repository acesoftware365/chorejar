/// Owned HTTPS links work in messaging apps. Legacy app links remain valid.
class InvitationLink {
  static const host = 'chorejar-liisgo-2026.web.app';
  static final _code = RegExp(r'^[0-9a-fA-F]{32}$');
  static String link(String route, String code) =>
      'https://$host/$route#code=$code';

  static String? parse(String input, String route) {
    final raw = input.trim();
    if (_code.hasMatch(raw)) return raw.toLowerCase();
    for (final match in RegExp(
      r'(?:https|chorejar)://[^\s<>]+',
    ).allMatches(raw)) {
      try {
        final uri = Uri.parse(match.group(0)!);
        final legacy =
            uri.scheme == 'chorejar' && uri.host == route && uri.path.isEmpty;
        final web =
            uri.scheme == 'https' &&
            uri.host == host &&
            !uri.hasPort &&
            uri.userInfo.isEmpty &&
            uri.path == '/$route';
        if (!legacy && !web) continue;
        final parameters = web && uri.fragment.isNotEmpty
            ? Uri.splitQueryString(uri.fragment)
            : uri.queryParameters;
        if (parameters.length != 1) continue;
        final code = parameters['code'];
        if (code != null && _code.hasMatch(code)) return code.toLowerCase();
      } on FormatException {
        // Pasted messages can contain unrelated or malformed links.
      }
    }
    return null;
  }

  static String message(
    String introduction,
    String route,
    String code,
    String fallback,
  ) => '$introduction\n\n${link(route, code)}\n\n$fallback\n$code';
}
