import 'services/child_invitation.dart';
import 'dart:async';
import 'package:app_links/app_links.dart';
import 'services/parent_invitation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'l10n/strings.dart';
import 'screens/dashboard.dart';
import 'screens/welcome_flow.dart';
import 'services/repository.dart';
import 'services/regional_brand.dart';
import 'services/membership.dart';
import 'widgets/surfaces.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLinks(); // Register early so cold-start invitations are retained.
  final prefs = await SharedPreferences.getInstance();
  var ready = false;
  try {
    await Firebase.initializeApp(options: firebaseOptions);
    const emulator = bool.fromEnvironment('FIREBASE_EMULATOR');
    if (emulator) {
      const host = String.fromEnvironment(
        'EMULATOR_HOST',
        defaultValue: '127.0.0.1',
      );
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    }
    // Financial writes require online transactions; do not retain a child's cached
    // records on a shared device after sign-out or revocation.
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
    );
    ready = true;
  } catch (_) {
    ready = false;
  }
  // Starts the purchase listener before the first screen. It is inert unless a
  // future release explicitly enables an HTTPS verifier and checkout flag.
  unawaited(Membership.instance.start());
  runApp(ChoreJar(prefs: prefs, firebaseReady: ready));
}

class ChoreJar extends StatefulWidget {
  final SharedPreferences prefs;
  final bool firebaseReady;
  final FamilyRepository? initialRepository;
  final Strings? initialStrings;
  final Future<FamilyRepository> Function()? previewFactory;
  const ChoreJar({
    super.key,
    required this.prefs,
    this.firebaseReady = false,
    this.initialRepository,
    this.initialStrings,
    this.previewFactory,
  });
  @override
  State<ChoreJar> createState() => _ChoreJarState();
}

class _ChoreJarState extends State<ChoreJar> with WidgetsBindingObserver {
  Strings? strings;
  String language = 'en';
  FamilyRepository? repository;
  String? invitation, entryMode;
  bool childInvitation = false;
  StreamSubscription<Uri>? invitationSubscription;
  @override
  void initState() {
    super.initState();
    repository = widget.initialRepository;
    strings = widget.initialStrings;
    language = widget.prefs.getString('language') == 'es' ? 'es' : 'en';
    WidgetsBinding.instance.addObserver(this);
    if (strings == null) load();
    if (widget.firebaseReady) {
      invitationSubscription = AppLinks().uriLinkStream.listen((uri) {
        final childCode = ChildInvitation.parse(uri.toString());
        final code = childCode ?? ParentInvitation.parse(uri.toString());
        if (code != null && mounted) {
          setState(() {
            invitation = code;
            childInvitation = childCode != null;
          });
        }
      }, onError: (_) {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    invitationSubscription?.cancel();
    repository?.close();
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    load();
  }

  Future<void> load([String? choice]) async {
    if (choice != null) await widget.prefs.setString('language', choice);
    final selected = widget.prefs.getString('language') ?? 'system';
    final phone =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final next = selected == 'system'
        ? (phone == 'es' ? 'es' : 'en')
        : selected;
    final loaded = await Strings.load(next);
    if (mounted) {
      setState(() {
        language = next;
        strings = loaded;
      });
    }
  }

  Future<void> exit({String? mode}) async {
    final old = repository;
    if (widget.firebaseReady && !old!.local) {
      await FirebaseAuth.instance.signOut();
    }
    if (mounted) {
      setState(() {
        repository = null;
        entryMode = mode;
      });
    }
    await old?.close();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: appNameFor(
      repository?.country,
      fallback: strings?.call('name') ?? 'ChoreJar',
    ),
    locale: Locale(language),
    supportedLocales: const [Locale('en'), Locale('es')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: green,
            brightness: Brightness.light,
          ).copyWith(
            primary: green,
            onPrimary: paper,
            primaryContainer: mint,
            onPrimaryContainer: ink,
            secondary: gold,
            onSecondary: ink,
            secondaryContainer: paleGold,
            onSecondaryContainer: ink,
            surface: cream,
            onSurface: ink,
            surfaceContainerHighest: paper,
            surfaceContainerHigh: mint,
            outline: border,
            outlineVariant: border,
            error: danger,
            onError: paper,
            errorContainer: dangerContainer,
            onErrorContainer: danger,
          ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: ink,
        displayColor: ink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cream,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: paper,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        labelStyle: const TextStyle(color: muted),
        floatingLabelStyle: const TextStyle(color: green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: green, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: danger, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: green,
          foregroundColor: paper,
          disabledBackgroundColor: mint,
          disabledForegroundColor: muted,
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: green,
          side: const BorderSide(color: border),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: green),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: paper,
        indicatorColor: mint,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: const DividerThemeData(color: border, space: 1),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: green),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: ink,
        contentTextStyle: TextStyle(color: paper),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: paper,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: paper,
        surfaceTintColor: Colors.transparent,
      ),
    ),
    builder: (context, child) {
      if (!compactPhone(context)) return child!;
      final theme = Theme.of(context);
      return Theme(
        data: theme.copyWith(
          textTheme: theme.textTheme.copyWith(
            titleMedium: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
            titleSmall: theme.textTheme.titleSmall?.copyWith(fontSize: 14),
          ),
          listTileTheme: const ListTileThemeData(
            contentPadding: EdgeInsets.symmetric(horizontal: 4),
            minVerticalPadding: 8,
          ),
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
          ),
        ),
        child: child!,
      );
    },
    home: strings == null
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : repository == null || invitation != null
        ? WelcomeFlow(
            previewFactory: widget.previewFactory,
            initialMode: entryMode,
            key: ValueKey('$childInvitation:$invitation'),
            childInvitation: childInvitation,
            invitation: invitation,
            strings: strings!,
            firebaseReady: widget.firebaseReady,
            onOpen: (r) {
              repository?.close();
              setState(() {
                repository = r;
                invitation = null;
                entryMode = null;
              });
            },
          )
        : Dashboard(
            key: ObjectKey(repository),
            repository: repository!,
            strings: strings!,
            language: language,
            languageChoice: widget.prefs.getString('language') ?? 'system',
            onLanguage: load,
            onExit: () => exit(),
            onAccount: () => exit(mode: 'login'),
          ),
  );
}
