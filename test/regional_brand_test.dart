import 'dart:convert';
import 'dart:io';
import 'package:chorejar/l10n/strings.dart';
import 'package:chorejar/services/money.dart';
import 'package:chorejar/services/regional_brand.dart';
import 'package:chorejar/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every country offered during setup has a regional brand', () {
    expect(countryBrands.keys.toSet(), containsAll(countries.keys));
    for (final country in countries.keys) {
      final brand = regionalBrandFor(country);
      expect(brand.appName, isNotEmpty);
      expect(brand.allowanceTerm, isNotEmpty);
    }
  });

  test('regional names cover the established Spanish and Asian variants', () {
    expect(appNameFor('DO', fallback: 'ChoreJar'), 'Mi Mesadita');
    expect(appNameFor('MX', fallback: 'ChoreJar'), 'Mi Domingo');
    expect(appNameFor('ES', fallback: 'ChoreJar'), 'Mi Paga');
    expect(appNameFor('JP', fallback: 'ChoreJar'), 'こづかいJar');
    expect(appNameFor('KR', fallback: 'ChoreJar'), '용돈항아리');
  });

  test('unknown country retains the language fallback', () {
    expect(appNameFor('otherCountry', fallback: 'Mi Mesadita'), 'Mi Mesadita');
    expect(appNameFor(null, fallback: 'ChoreJar'), 'ChoreJar');
  });

  testWidgets('country selection changes the in-app name before setup', (
    tester,
  ) async {
    final strings = Strings(
      jsonDecode(File('assets/l10n/en.json').readAsStringSync()),
    );
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 860);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        home: SignIn(
          mode: 'create',
          strings: strings,
          firebaseReady: false,
          onOpen: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mexico').last);
    await tester.pumpAndSettle();

    expect(find.text('Mi Domingo'), findsOneWidget);
  });
}
