// Synthetic layout evidence, not a screenshot of a physical Samsung device.
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chorejar/main.dart';
import 'package:chorejar/l10n/strings.dart';
import 'package:chorejar/models/family.dart';
import '../test/widget_test.dart' show MemoryRepository;

class ParentFixture extends MemoryRepository {
  @override
  bool get local => false;
}

void main() {
  testWidgets('Render compact parent interface with normal and larger text', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(384, 800);
    tester.view.padding = const FakeViewPadding(top: 24, bottom: 24);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final font = FontLoader('Roboto')
      ..addFont(
        Future.value(
          ByteData.sublistView(
            File(
              '/System/Library/Fonts/Supplemental/Arial.ttf',
            ).readAsBytesSync(),
          ),
        ),
      );
    await font.load();
    // Explicit button text styles fall back to the test runner's Ahem family.
    await (FontLoader('Ahem')..addFont(
          Future.value(
            ByteData.sublistView(
              File(
                '/System/Library/Fonts/Supplemental/Arial.ttf',
              ).readAsBytesSync(),
            ),
          ),
        ))
        .load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    for (final scale in [1.0, 1.3]) {
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      final repo = ParentFixture();
      final child = ChildData(id: 'qa', name: 'Alex', currency: 'USD');
      child.addTask(
        Task(
          id: 'task',
          title: 'Put away toys',
          frequency: 'weekly',
          amount: 500,
          due: '2026-10-11',
        ),
      );
      repo.values[child.id] = child;
      // This helper is executed by flutter test.
      // ignore: invalid_use_of_visible_for_testing_member
      SharedPreferences.setMockInitialValues({'language': 'en'});
      final key = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: ChoreJar(
            prefs: await SharedPreferences.getInstance(),
            initialRepository: repo,
            initialStrings: Strings(
              jsonDecode(File('assets/l10n/en.json').readAsStringSync()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final picture = await boundary.toImage(pixelRatio: 2);
        final bytes = await picture.toByteData(format: ui.ImageByteFormat.png);
        final output = File(
          '/Volumes/Mac2TB/ChoreJar/04_Capturas/A51-build8-texto-$scale.png',
        );
        await output.writeAsBytes(bytes!.buffer.asUint8List());
        picture.dispose();
      });
      await tester.pumpWidget(const SizedBox());
    }
  });
}
