import 'package:intl/intl.dart';
import '../models/family.dart';

const currencies = [
  'USD',
  'DOP',
  'EUR',
  'MXN',
  'COP',
  'ARS',
  'CLP',
  'PEN',
  'GBP',
  'CAD',
  'JPY',
  'BRL',
  'UYU',
  'CRC',
  'GTQ',
  'HNL',
  'NIO',
  'PAB',
  'BOB',
  'PYG',
  'AUD',
  'CHF',
  'CNY',
  'INR',
  'KRW',
  'KWD',
  'BHD',
];
const countries = {
  'US': 'USD',
  'DO': 'DOP',
  'ES': 'EUR',
  'MX': 'MXN',
  'CO': 'COP',
  'AR': 'ARS',
  'CL': 'CLP',
  'PE': 'PEN',
  'GB': 'GBP',
  'CA': 'CAD',
  'JP': 'JPY',
  'BR': 'BRL',
  'UY': 'UYU',
  'CR': 'CRC',
  'GT': 'GTQ',
  'HN': 'HNL',
  'NI': 'NIO',
  'PA': 'PAB',
  'BO': 'BOB',
  'PY': 'PYG',
  'AU': 'AUD',
  'CH': 'CHF',
  'CN': 'CNY',
  'IN': 'INR',
  'KR': 'KRW',
  'KW': 'KWD',
  'BH': 'BHD',
};

/// A safe default for family records created before the country was stored.
/// Currency alone is ambiguous in a few markets, so new cloud families always
/// persist their selected country.
String countryForCurrency(String currency) => countries.entries
    .firstWhere(
      (entry) => entry.value == currency,
      orElse: () => const MapEntry('US', 'USD'),
    )
    .key;
int digits(String currency) =>
    NumberFormat.currency(name: currency).decimalDigits!;
int units(String currency) {
  var result = 1;
  for (var i = 0; i < digits(currency); i++) {
    result *= 10;
  }
  return result;
}

// Keep decimal points and comma grouping independent of the interface language.
const moneyLocale = 'en_US';

String money(int amount, String currency, String locale) {
  final formatted = NumberFormat.decimalPatternDigits(
    locale: moneyLocale,
    decimalDigits: digits(currency),
  ).format(amount / units(currency));
  return '$formatted $currency';
}

int parseMoney(String raw, String currency, {bool zero = false}) {
  final text = raw.trim().replaceAll(',', '.');
  require(RegExp(r'^\d+(\.\d+)?$').hasMatch(text));
  final parts = text.split('.');
  final fraction = parts.length == 2 ? parts[1] : '';
  require(fraction.length <= digits(currency));
  final amount =
      int.parse(parts.first) * units(currency) +
      (fraction.isEmpty
          ? 0
          : int.parse(fraction.padRight(digits(currency), '0')));
  require(amount >= (zero ? 0 : 1) && amount <= 100000000000);
  return amount;
}
