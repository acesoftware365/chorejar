import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chorejar/main.dart';
import 'package:chorejar/l10n/strings.dart';
import 'package:chorejar/models/family.dart';
import 'package:chorejar/widgets/child_money.dart';
import 'widget_test.dart' show MemoryRepository;

class ChildRepository extends MemoryRepository {
  @override
  bool get parent => false;
}

void main() {
  testWidgets(
    'Child reference screen uses live pending balance and opens goal and tasks',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      for (final language in ['es', 'en']) {
        for (final size in [
          const Size(320, 568),
          const Size(360, 640),
          const Size(384, 760),
          const Size(466, 678),
          const Size(669, 951),
          const Size(951, 669),
          const Size(440, 956),
        ]) {
          tester.view.physicalSize = size;
          tester.platformDispatcher.textScaleFactorTestValue = size.width == 320
              ? 2
              : 1;
          SharedPreferences.setMockInitialValues({'language': language});
          final repo = ChildRepository();
          final c = ChildData(
            id: 'kid',
            name: 'Alex',
            currency: 'USD',
            goalName: 'Bicicleta',
            goalAmount: 10000,
          );
          final now = DateTime.now();
          c.addTask(Task(id: 't', title: 'Leer', amount: 1250, due: day(now)));
          c.submit('t', now);
          c.review('t', true, '', now);
          repo.values[c.id] = c;
          await tester.pumpWidget(
            ChoreJar(
              prefs: await SharedPreferences.getInstance(),
              initialRepository: repo,
              initialStrings: Strings(
                jsonDecode(
                  File('assets/l10n/$language.json').readAsStringSync(),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.byType(ChildMoney), findsOneWidget);
          expect(
            find.text(language == 'es' ? 'Eliminar niño' : 'Delete child'),
            findsNothing,
          );
          expect(
            tester.widget<Text>(find.byKey(const Key('child-pending'))).data,
            r'$12.50',
          );
          expect(tester.takeException(), isNull);
          if (size.width == 466) {
            for (final width in [669.0, 951.0, 466.0]) {
              tester.view.physicalSize = Size(width, 678);
              await tester.pumpAndSettle();
              expect(
                find.byKey(const Key('wide-child-money')),
                width >= 640 ? findsOneWidget : findsNothing,
              );
              expect(
                tester
                    .widget<Text>(find.byKey(const Key('child-pending')))
                    .data,
                r'$12.50',
              );
              expect(tester.takeException(), isNull);
            }
          }
          await repo.change(
            c.id,
            (v) => v.move('paid', 'payment', 250, '', now),
          );
          await tester.pumpAndSettle();
          expect(
            tester.widget<Text>(find.byKey(const Key('child-pending'))).data,
            r'$10.00',
          );
          await tester.tap(find.byKey(const Key('child-tab-2')));
          await tester.pumpAndSettle();
          await tester.scrollUntilVisible(
            find.text('Bicicleta'),
            120,
            scrollable: find.byType(Scrollable).first,
          );
          expect(find.text('Bicicleta'), findsOneWidget);
          if (language == 'en' && size == const Size(384, 760)) {
            expect(
              find.text(
                'When you are ready to use money for your goal, talk with your parent. They record real-world decisions outside the app.',
              ),
              findsOneWidget,
            );
          }
          expect(tester.takeException(), isNull);
          await tester.tap(find.byKey(const Key('child-tab-0')));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(
            find.text(language == 'es' ? 'Aprobar' : 'Approve'),
            findsNothing,
          );
          await tester.pumpWidget(const SizedBox());
          await tester.pumpAndSettle();
        }
      }
    },
  );
}
