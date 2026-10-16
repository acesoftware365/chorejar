// Isolated visual preview: this code grants no access to any family.
import 'package:flutter/material.dart';
import 'l10n/strings.dart';
import 'widgets/child_invitation_dialog.dart';
import 'widgets/surfaces.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final strings = await Strings.load('es');
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: green,
              brightness: Brightness.light,
            ).copyWith(
              primary: green,
              onPrimary: paper,
              surface: cream,
              onSurface: ink,
              outline: border,
            ),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vista de prueba · QR sin acceso real'),
        ),
        body: ChildInvitationDialog(
          code: '00000000000000000000000000000000',
          strings: strings,
        ),
      ),
    ),
  );
}
