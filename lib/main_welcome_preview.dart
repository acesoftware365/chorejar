// Isolated walkthrough: no Firebase, credentials or real family data.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart' as application;
import 'main_parent_preview.dart' show ParentPreviewRepository;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('language', 'es');
  runApp(
    application.ChoreJar(
      prefs: prefs,
      previewFactory: () async {
        final repo = ParentPreviewRepository(prefs);
        for (final child in await repo.watch().first) {
          await repo.deleteChild(child.id);
        }
        return repo;
      },
    ),
  );
}
