import 'dart:convert';
import 'package:flutter/services.dart';

class Strings {
  final Map<String, dynamic> values;
  Strings(this.values);
  String call(String key) => values[key] as String? ?? key;
  static Future<Strings> load(String language) async => Strings(
    jsonDecode(await rootBundle.loadString('assets/l10n/$language.json'))
        as Map<String, dynamic>,
  );
}
