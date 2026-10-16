import 'package:flutter_test/flutter_test.dart';
import 'package:chorejar/models/family.dart';
import 'package:chorejar/services/money.dart';
import 'package:chorejar/widgets/child_money.dart';

void main() {
  test('money uses decimal points and comma grouping in both languages', () {
    for (final language in ['es', 'en']) {
      expect(money(1250, 'USD', language), '12.50 USD');
      expect(money(0, 'USD', language), '0.00 USD');
      expect(money(100000, 'USD', language), '1,000.00 USD');
      expect(money(123456, 'DOP', language), '1,234.56 DOP');
      expect(money(-1250, 'USD', language), '-12.50 USD');
      expect(money(1234, 'JPY', language), '1,234 JPY');
      expect(money(1234567, 'KWD', language), '1,234.567 KWD');
      final child = ChildData(id: 'test', name: 'Test', currency: 'USD');
      expect(childCash(1250, child, language), '\$12.50');
      expect(childCash(100000, child, language), '\$1,000.00');
      expect(childCash(200, child, language, compact: true), '\$2');
    }
  });
}
