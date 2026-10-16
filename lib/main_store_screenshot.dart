// Isolated store-art capture target. It never initializes Firebase or opens a
// user session; it renders the real parent/child screens with synthetic data.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart' as application;
import 'main_child_preview.dart';
import 'main_parent_preview.dart';

const _role = String.fromEnvironment('STORE_SCREENSHOT_ROLE');
const _language = String.fromEnvironment(
  'STORE_SCREENSHOT_LANGUAGE',
  defaultValue: 'es',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('language', _language == 'en' ? 'en' : 'es');
  final parent = _role == 'parent';
  runApp(
    application.ChoreJar(
      prefs: prefs,
      initialRepository: parent
          ? StoreScreenshotParentRepository(prefs)
          : StoreScreenshotChildRepository(prefs),
    ),
  );
}

/// The same presentation data as the preview, with no local-mode notice in a
/// capture. This class is only reachable from this non-production entrypoint.
class StoreScreenshotChildRepository extends ChildPreviewRepository {
  StoreScreenshotChildRepository(super.prefs);

  @override
  bool get local => false;
}

class StoreScreenshotParentRepository extends ParentPreviewRepository {
  StoreScreenshotParentRepository(super.prefs);

  @override
  bool get local => false;
}
