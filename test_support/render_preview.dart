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

class PreviewRepository extends MemoryRepository {
  @override
  bool get local => false;
  @override
  bool get parent => false;
}

void main() {
  testWidgets('Render a synthetic child preview at Pro Max proportions', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
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
    final rounded = FontLoader('Nunito');
    for (final weight in [400, 700, 800, 900]) {
      rounded.addFont(
        Future.value(
          ByteData.sublistView(
            File('assets/fonts/Nunito-$weight.ttf').readAsBytesSync(),
          ),
        ),
      );
    }
    await rounded.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    final repo = PreviewRepository();
    final now = DateTime(2026, 10, 7);
    final c = ChildData(
      id: 'preview',
      name: 'Alex',
      currency: 'USD',
      goalName: 'Para mi bicicleta',
      goalAmount: 10000,
      mode: 'tasks',
    );
    c.addTask(
      Task(id: 'done', title: 'Ayudar en casa', amount: 10050, due: day(now)),
    );
    c.submit('done', now);
    c.review('done', true, '', now);
    c.move('pay', 'payment', 9000, '', now);
    c.move('save', 'saving', 5700, '', now);
    c.addTask(Task(id: 'latest', title: 'Leer', amount: 200, due: day(now)));
    c.submit('latest', now.add(const Duration(minutes: 1)));
    c.review('latest', true, '', now.add(const Duration(minutes: 1)));
    c.addTask(
      Task(
        id: 'room',
        title: 'Ordenar mi habitación',
        instructions: 'Guarda tus juguetes y deja la cama lista.',
        amount: 200,
        due: day(now),
      ),
    );
    c.addTask(
      Task(
        id: 'plants',
        title: 'Regar las plantas',
        instructions: 'Un poquito de agua para cada planta.',
        amount: 100,
        due: day(now),
      ),
    );
    repo.values[c.id] = c;
    // This standalone rendering helper is executed by flutter test.
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({'language': 'es'});
    final key = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: key,
        child: ChoreJar(
          prefs: await SharedPreferences.getInstance(),
          initialRepository: repo,
          initialStrings: Strings(
            jsonDecode(File('assets/l10n/es.json').readAsStringSync()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);
    await tester.runAsync(() async {
      for (final name in ['money-jar', 'piggy-bank', 'bicycle']) {
        await precacheImage(
          AssetImage('assets/library/$name.webp'),
          tester.element(find.byType(Scaffold).first),
        );
      }
    });
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final output = File(
      '/Users/juanpolanco/Documents/Codex/2026-10-07/chore/outputs/chorejar-child-reference.png',
    );
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      await output.parent.create(recursive: true);
      await output.writeAsBytes(bytes!.buffer.asUint8List());
      image.dispose();
    });
    await tester.pumpWidget(const SizedBox());
    debugDisableShadows = true;
  });
}
