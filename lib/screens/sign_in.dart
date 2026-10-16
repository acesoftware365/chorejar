import '../services/child_invitation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/parent_invitation.dart';
import '../l10n/strings.dart';
import '../services/repository.dart';
import '../services/money.dart';
import '../services/regional_brand.dart';
import '../models/family.dart';
import '../widgets/surfaces.dart';
import '../assets/library.dart';
import 'legal_privacy.dart';

class SignIn extends StatefulWidget {
  final String? mode;
  final VoidCallback? onBack;
  final String? invitation;
  final Strings strings;
  final bool firebaseReady;
  final void Function(FamilyRepository) onOpen;
  const SignIn({
    super.key,
    this.invitation,
    this.mode,
    this.onBack,
    required this.strings,
    required this.firebaseReady,
    required this.onOpen,
  });
  @override
  State<SignIn> createState() => _SignInState();
}

class _LoginJarHero extends StatelessWidget {
  final bool wide, compact;
  const _LoginJarHero({required this.wide, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final byHeight = constraints.maxHeight * (wide ? .90 : .98);
        final byWidth = constraints.maxWidth * (wide ? .94 : .68);
        final jar = (byHeight < byWidth ? byHeight : byWidth)
            .clamp(wide ? 150.0 : 122.0, wide ? 420.0 : 250.0)
            .toDouble();
        return Center(
          child: Image.asset(
            AssetLibrary.jar.path,
            height: jar,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            semanticLabel: 'ChoreJar',
          ),
        );
      },
    );
  }
}

/// A small, welcoming hero for the first screen.  The jar is deliberately
/// shown as the artwork itself instead of the square app-mark, so it reads
/// clearly on a narrow phone as well as on Duo's single screen.
class _RoleChoiceHero extends StatelessWidget {
  const _RoleChoiceHero();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.clamp(220.0, 310.0).toDouble();
        final height = (width * .56).clamp(132.0, 164.0).toDouble();
        final jar = (height * .98).clamp(130.0, 164.0).toDouble();
        return Center(
          child: SizedBox(
            width: width,
            height: height,
            child: CustomPaint(
              painter: const _RoleChoiceArcPainter(),
              child: Center(
                child: Transform.translate(
                  offset: const Offset(0, 3),
                  child: Image.asset(
                    AssetLibrary.jar.path,
                    height: jar,
                    width: jar,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    semanticLabel: 'ChoreJar',
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RoleChoiceArcPainter extends CustomPainter {
  const _RoleChoiceArcPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * .5, size.height * .50);
    final radius = size.width * .43;
    final circle = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: const [Color(0x17D7F2E6), Color(0x00FFFFFF)],
          stops: const [.12, 1],
        ).createShader(circle),
    );
    canvas.drawArc(
      circle,
      3.30,
      3.66,
      false,
      Paint()
        ..color = const Color(0x5098DABF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _RoleChoiceArcPainter oldDelegate) => false;
}

class _LoginArcPainter extends CustomPainter {
  final bool wide, creating;
  const _LoginArcPainter(this.wide, this.creating);

  @override
  void paint(Canvas canvas, Size size) {
    final center = wide
        ? Offset(size.width * .265, size.height * .51)
        : Offset(size.width * .50, size.height * .245);
    final radius = wide
        ? (size.height * .44).clamp(92.0, size.width * .31)
        : (size.width * .45).clamp(98.0, size.height * .30);
    final orb = Rect.fromCircle(center: center, radius: radius);
    final tint = creating ? const Color(0x1FD7F2E6) : const Color(0x1FFFF0C9);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [tint, const Color(0x00FFFFFF)],
          stops: const [.10, 1],
        ).createShader(orb),
    );
    canvas.drawArc(
      orb,
      wide ? 2.22 : 3.38,
      wide ? 4.15 : 3.52,
      false,
      Paint()
        ..color = const Color(0x7498DABF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = wide ? 2 : 1.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _LoginArcPainter oldDelegate) =>
      oldDelegate.wide != wide || oldDelegate.creating != creating;
}

/// The tinted circle is deliberately behind the jar.  Its curve makes the
/// narrow login feel special without spending vertical space, and it moves to
/// the art pane when Duo is opened.
class _LoginBackdropPainter extends CustomPainter {
  final bool wide, creating;
  const _LoginBackdropPainter(this.wide, this.creating);

  @override
  void paint(Canvas canvas, Size size) {
    final entire = Offset.zero & size;
    canvas.drawRect(
      entire,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: creating
              ? const [Color(0xFFFFFCF6), Color(0xFFF1FAF5)]
              : const [Color(0xFFFFFCF7), Color(0xFFFFF9EC)],
        ).createShader(entire),
    );
  }

  @override
  bool shouldRepaint(covariant _LoginBackdropPainter oldDelegate) =>
      oldDelegate.wide != wide || oldDelegate.creating != creating;
}

class _LoginModeToggle extends StatelessWidget {
  final bool creating, compact;
  final String loginLabel, createLabel;
  final ValueChanged<bool>? onChanged;
  const _LoginModeToggle({
    required this.creating,
    required this.compact,
    required this.loginLabel,
    required this.createLabel,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(999);
    final selectedColor = creating
        ? const Color(0xFFCAE8DB)
        : const Color(0xFFFFE5A2);
    return Semantics(
      label: 'Choose login or create account',
      child: Container(
        height: compact ? 34 : 40,
        decoration: BoxDecoration(
          color: const Color(0x5CFFFFFF),
          borderRadius: radius,
          border: Border.all(color: const Color(0x52716F65)),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              alignment: creating
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: .5,
                heightFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: selectedColor,
                      borderRadius: radius,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x2515362E),
                          blurRadius: 7,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: radius,
                    onTap: onChanged == null ? null : () => onChanged!(false),
                    child: Center(
                      child: Text(
                        loginLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: compact ? 11 : 12,
                          fontWeight: FontWeight.w700,
                          color: ink,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: radius,
                    onTap: onChanged == null ? null : () => onChanged!(true),
                    child: Center(
                      child: Text(
                        createLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: compact ? 11 : 12,
                          fontWeight: FontWeight.w700,
                          color: ink,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SignInState extends State<SignIn> {
  final email = TextEditingController(),
      password = TextEditingController(),
      code = TextEditingController();
  bool busy = false, child = false, creating = false, joining = false;
  String? error;
  bool accountCreated = false, showPassword = false, legalAccepted = false;
  String country = 'US', currency = 'USD';
  String t(String k) => widget.strings(k);
  String get appName => appNameFor(country, fallback: t('name'));
  @override
  void initState() {
    super.initState();
    creating = widget.mode == 'create';
    child = widget.mode == 'child';
    joining = widget.mode == 'join';
    final c = WidgetsBinding.instance.platformDispatcher.locale.countryCode;
    if (c != null && countries.containsKey(c)) {
      country = c;
      currency = countries[c]!;
    }
    if (widget.invitation != null) {
      joining = !child;
      code.text = widget.invitation!;
    } else if (widget.mode == null) {
      resume();
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    code.dispose();
    super.dispose();
  }

  Future<void> run(Future<void> Function() action) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await action();
    } on DomainError catch (e) {
      if (mounted) setState(() => error = t(e.key));
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(
          () => error = t(
            e.code == 'network-request-failed'
                ? 'authNetwork'
                : e.code == 'too-many-requests'
                ? 'authAttempts'
                : e.code == 'operation-not-allowed'
                ? 'authUnavailable'
                : e.code == 'invalid-credential' ||
                      e.code == 'wrong-password' ||
                      e.code == 'user-not-found'
                ? 'authInvalid'
                : e.code == 'email-already-in-use'
                ? 'emailInUse'
                : e.code == 'weak-password'
                ? 'weakPassword'
                : 'authError',
          ),
        );
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        setState(
          () => error = t(
            e.code == 'permission-denied' ? 'pairDenied' : 'connectionError',
          ),
        );
      }
    } catch (_) {
      if (mounted) setState(() => error = t('connectionError'));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> resume() async {
    if (!widget.firebaseReady) return;
    await run(() async {
      final repo = await CloudRepository.resume();
      if (repo != null && mounted) widget.onOpen(repo);
    });
  }

  Future<void> enter() async {
    if (!widget.firebaseReady) throw DomainError('connectionError');
    if (child) {
      final repo = await CloudRepository.pair(code.text);
      if (mounted) widget.onOpen(repo);
      return;
    }
    // This is a sign-in form, so never fall back to the generic validation
    // message about amounts when an email is incomplete or malformed.
    require(email.text.trim().contains('@'), 'authError');
    require(password.text.length >= 8, 'weakPassword');
    final auth = FirebaseAuth.instance;
    if (creating && !accountCreated) {
      require(legalAccepted, 'legalAcceptHelp');
      await auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text,
      );
      accountCreated = true;
    } else if (!creating) {
      await auth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text,
      );
    }
    final existing = await CloudRepository.resume();
    final repo = joining
        ? await CloudRepository.joinParent(
            ParentInvitation.parse(code.text) ?? '',
          )
        : existing ?? await CloudRepository.setup(currency, country);
    if (mounted) widget.onOpen(repo);
  }

  bool get _isParentLogin =>
      !child && !joining && (widget.mode == 'login' || widget.mode == 'create');

  Future<void> _resetPassword(BuildContext context) => run(() async {
    require(widget.firebaseReady && email.text.trim().contains('@'));
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email.text.trim(),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t('resetSent'))));
    }
  });

  Future<void> _openLegal(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => LegalPrivacyScreen(strings: widget.strings),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: widget.onBack == null
          ? null
          : BackButton(onPressed: busy ? null : widget.onBack),
      title: Text(appName, style: const TextStyle(fontWeight: FontWeight.w800)),
    ),
    body: _isParentLogin
        ? _parentLogin(context)
        : pageBody([
            if (creating && !joining) ...[
              Text(t('stepOf').replaceAll('{step}', '1')),
              const SizedBox(height: 10),
              const LinearProgressIndicator(value: 0.25),
            ],
            const SizedBox(height: 14),
            if (!child && !joining && widget.mode == null) ...[
              const _RoleChoiceHero(),
              const SizedBox(height: 12),
            ] else ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  AssetLibrary.brand.path,
                  height: child ? 72 : 128,
                  width: child ? 72 : 128,
                  excludeFromSemantics: true,
                ),
              ),
              SizedBox(height: child ? 12 : 24),
            ],
            heading(
              t(
                child
                    ? 'pairTitle'
                    : joining
                    ? 'invitedTitle'
                    : creating
                    ? 'createAccountTitle'
                    : 'welcome',
              ),
              t(
                child
                    ? 'pairSubtitle'
                    : joining
                    ? 'invitedSubtitle'
                    : 'welcomeSub',
              ),
            ),
            if (!joining && widget.mode == null)
              SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: false, label: Text(t('parents'))),
                  ButtonSegment(value: true, label: Text(t('child'))),
                ],
                selected: {child},
                onSelectionChanged: busy
                    ? null
                    : (v) => setState(() => child = v.first),
              ),
            SizedBox(height: child ? 8 : 22),
            if (child) ...[
              Text(t('pairHelp')),
              const SizedBox(height: 16),
              TextField(
                controller: code,
                autocorrect: false,
                decoration: InputDecoration(labelText: t('childCodeOrLink')),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
              ),
              TextButton.icon(
                icon: const Icon(Icons.content_paste),
                label: Text(t('pasteInvitation')),
                onPressed: busy
                    ? null
                    : () async {
                        final clipboard = await Clipboard.getData(
                          Clipboard.kTextPlain,
                        );
                        if (!mounted) return;
                        final parsed = ChildInvitation.parse(
                          clipboard?.text ?? '',
                        );
                        setState(() {
                          if (parsed == null) {
                            error = t('invalidCode');
                          } else {
                            code.text = parsed;
                            error = null;
                          }
                        });
                      },
              ),
              Text(t('childWifiHelp')),
            ] else ...[
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(labelText: t('email')),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: password,
                obscureText: !showPassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
                autofillHints: [
                  creating ? AutofillHints.newPassword : AutofillHints.password,
                ],
                decoration: InputDecoration(
                  labelText: t('password'),
                  suffixIcon: IconButton(
                    tooltip: t(showPassword ? 'hidePassword' : 'showPassword'),
                    onPressed: () =>
                        setState(() => showPassword = !showPassword),
                    icon: Icon(
                      showPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),
              if (widget.invitation == null && widget.mode == null)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(t('joinParent')),
                  value: joining,
                  onChanged: busy
                      ? null
                      : (value) => setState(() => joining = value),
                ),
              if (joining) ...[
                if (ParentInvitation.parse(code.text) != null) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.check_circle_outline,
                      color: green,
                    ),
                    title: Text(t('invitationReady')),
                  ),
                  ExpansionTile(
                    title: Text(t('manualInvitation')),
                    children: [
                      TextField(
                        controller: code,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: t('invitationLabel'),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ] else ...[
                  Text(t('joinParentHelp')),
                  OutlinedButton.icon(
                    onPressed: busy
                        ? null
                        : () => run(() async {
                            final clipboard = await Clipboard.getData(
                              Clipboard.kTextPlain,
                            );
                            final parsed = ParentInvitation.parse(
                              clipboard?.text ?? '',
                            );
                            require(parsed != null, 'invalidCode');
                            code.text = parsed!;
                          }),
                    icon: const Icon(Icons.content_paste),
                    label: Text(t('pasteInvitation')),
                  ),
                  TextField(
                    controller: code,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: t('invitationLabel'),
                    ),
                    maxLines: 2,
                  ),
                ],
              ],
              if (creating && !joining) ...[
                const SizedBox(height: 22),
                ...setupFields(),
                _legalConsent(context),
              ],
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: busy ? null : () => _resetPassword(context),
                  child: Text(t('forgot')),
                ),
              ),
            ],
            if (error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(error!, style: const TextStyle(color: danger)),
              ),
            FilledButton(
              onPressed: busy ? null : () => run(enter),
              child: Text(
                t(
                  busy
                      ? 'loading'
                      : child
                      ? 'pair'
                      : joining
                      ? creating
                            ? 'createAndJoin'
                            : 'enterFamily'
                      : creating
                      ? 'register'
                      : 'login',
                ),
              ),
            ),
            if (!child)
              TextButton(
                onPressed: busy
                    ? null
                    : () => setState(() => creating = !creating),
                child: Text(t(creating ? 'login' : 'register')),
              ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: busy
                  ? null
                  : () => run(() async {
                      final repo = await LocalRepository.open(
                        currency,
                        country: country,
                      );
                      if (mounted) widget.onOpen(repo);
                    }),
              child: Text(t('preview')),
            ),
            const SizedBox(height: 12),
            if (child)
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(
                  t('privacyDetails'),
                  style: const TextStyle(fontSize: 14),
                ),
                children: [
                  Text(t('privacyText'), style: const TextStyle(fontSize: 12)),
                ],
              )
            else
              TextButton.icon(
                onPressed: () => _openLegal(context),
                icon: const Icon(Icons.privacy_tip_outlined, size: 18),
                label: Text(t('legalRead')),
              ),
          ]),
  );

  Widget _parentLogin(BuildContext context) => SafeArea(
    top: false,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= 440 &&
            constraints.maxWidth > constraints.maxHeight * 1.08;
        final short = constraints.maxHeight < 500;
        // Duo's closed display is tall enough to look like a phone, but it
        // leaves much less vertical room than a regular iPhone.  Keep the
        // jar special while reserving space for the whole sign-up form.
        final narrowTight = !wide && constraints.maxHeight < 720;
        final sidePadding = wide ? (short ? 18.0 : 44.0) : 16.0;
        final narrowHeroHeight =
            (constraints.maxHeight * (narrowTight ? .25 : .34))
                .clamp(narrowTight ? 116.0 : 142.0, narrowTight ? 190.0 : 258.0)
                .toDouble();
        final form = _parentLoginCard(
          context,
          compact: !wide || short,
          tightWide: wide && short,
          sketchNarrow: !wide,
          narrowTight: narrowTight,
        );
        return Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _LoginBackdropPainter(wide, creating),
                ),
              ),
            ),
            if (wide)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: constraints.maxWidth * .52,
                child: _LoginJarHero(wide: true, compact: short),
              ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _LoginArcPainter(wide, creating)),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: sidePadding,
                    vertical: wide ? 10 : 6,
                  ),
                  child: wide
                      ? Row(
                          children: [
                            const Expanded(flex: 11, child: SizedBox()),
                            Expanded(
                              flex: 9,
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: short ? 300 : 380,
                                  height: double.infinity,
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Center(child: form),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: narrowHeroHeight,
                              width: double.infinity,
                              child: _LoginJarHero(wide: false, compact: true),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 430,
                                    ),
                                    child: form,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );

  Widget _parentLoginCard(
    BuildContext context, {
    required bool compact,
    required bool tightWide,
    required bool sketchNarrow,
    required bool narrowTight,
  }) {
    final narrow = sketchNarrow;
    final fieldGap = narrowTight
        ? 5.0
        : sketchNarrow
        ? 8.0
        : tightWide
        ? 6.0
        : compact
        ? 10.0
        : 14.0;
    // Keep every entry control at the same touch-friendly height.  Without
    // this, the password eye gives its field a larger minimum height than the
    // email and the selected dropdowns on Duo's narrow display.
    final inputHeight = sketchNarrow
        ? 48.0
        : tightWide
        ? 46.0
        : compact
        ? 50.0
        : 54.0;
    final outerRadius = narrow
        ? (creating ? 44.0 : 72.0)
        : creating
        ? (tightWide
              ? 42.0
              : compact
              ? 54.0
              : 66.0)
        : (tightWide
              ? 78.0
              : compact
              ? 94.0
              : 118.0);
    final sideRadius = narrow
        ? (creating ? 28.0 : 42.0)
        : creating
        ? (tightWide
              ? 24.0
              : compact
              ? 34.0
              : 44.0)
        : (tightWide
              ? 38.0
              : compact
              ? 50.0
              : 64.0);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(outerRadius),
            topRight: Radius.circular(sideRadius),
            bottomRight: Radius.circular(outerRadius),
            bottomLeft: Radius.circular(sideRadius),
          ),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              tightWide
                  ? 20
                  : narrowTight
                  ? 16
                  : sketchNarrow
                  ? 16
                  : compact
                  ? 22
                  : 30,
              tightWide
                  ? 10
                  : narrowTight
                  ? 8
                  : sketchNarrow
                  ? 18
                  : compact
                  ? 20
                  : 26,
              tightWide
                  ? 20
                  : narrowTight
                  ? 16
                  : sketchNarrow
                  ? 16
                  : compact
                  ? 22
                  : 30,
              tightWide
                  ? 10
                  : narrowTight
                  ? 8
                  : sketchNarrow
                  ? 16
                  : compact
                  ? 18
                  : 22,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _LoginModeToggle(
                  creating: creating,
                  compact: tightWide || compact,
                  loginLabel: t('login'),
                  createLabel: t('register'),
                  onChanged: busy
                      ? null
                      : (value) => setState(() {
                          creating = value;
                          error = null;
                        }),
                ),
                SizedBox(
                  height: sketchNarrow
                      ? narrowTight
                            ? 6
                            : 10
                      : tightWide
                      ? 8
                      : compact
                      ? 14
                      : 18,
                ),
                Text(
                  t(creating ? 'createAccountTitle' : 'welcome'),
                  textAlign: compact ? TextAlign.center : TextAlign.left,
                  style: TextStyle(
                    fontSize: sketchNarrow
                        ? narrowTight
                              ? 14
                              : 15
                        : tightWide
                        ? 16
                        : compact
                        ? 19
                        : 25,
                    height: 1.12,
                    color: ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (!tightWide && !sketchNarrow) ...[
                  const SizedBox(height: 6),
                  Text(
                    t('welcomeSub'),
                    textAlign: compact ? TextAlign.center : TextAlign.left,
                    style: TextStyle(color: muted, fontSize: compact ? 12 : 14),
                  ),
                ],
                if (creating) ...[
                  SizedBox(
                    height: (tightWide || sketchNarrow)
                        ? narrowTight
                              ? 4
                              : 6
                        : compact
                        ? 12
                        : 16,
                  ),
                  ...setupFields(
                    compact: compact,
                    sideBySide: tightWide,
                    tighter: narrowTight,
                    fieldHeight: inputHeight,
                  ),
                  _legalConsent(
                    context,
                    compact: compact,
                    condensed: tightWide || sketchNarrow,
                  ),
                ],
                SizedBox(
                  height: narrowTight
                      ? 6
                      : tightWide
                      ? 8
                      : compact
                      ? 14
                      : 20,
                ),
                SizedBox(
                  height: inputHeight,
                  child: TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(
                      labelText: t('email'),
                      isDense: true,
                      constraints: BoxConstraints(minHeight: inputHeight),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: sketchNarrow ? 9 : 12,
                        vertical: narrowTight
                            ? 7
                            : sketchNarrow
                            ? 8
                            : tightWide
                            ? 7
                            : 12,
                      ),
                      // Reserve the same trailing touch area used by the
                      // password visibility control.  It gives both text
                      // boxes the identical outlined height without adding a
                      // distracting icon to the email field.
                      suffixIcon: const SizedBox.shrink(),
                      suffixIconConstraints: BoxConstraints(
                        minWidth: inputHeight,
                        minHeight: inputHeight,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: fieldGap),
                SizedBox(
                  height: inputHeight,
                  child: TextField(
                    controller: password,
                    obscureText: !showPassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: t('password'),
                      isDense: true,
                      constraints: BoxConstraints(minHeight: inputHeight),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: sketchNarrow ? 9 : 12,
                        vertical: narrowTight
                            ? 7
                            : sketchNarrow
                            ? 8
                            : tightWide
                            ? 7
                            : 12,
                      ),
                      suffixIcon: IconButton(
                        tooltip: t(
                          showPassword ? 'hidePassword' : 'showPassword',
                        ),
                        onPressed: () =>
                            setState(() => showPassword = !showPassword),
                        icon: Icon(
                          showPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                      suffixIconConstraints: BoxConstraints(
                        minWidth: inputHeight,
                        minHeight: inputHeight,
                      ),
                    ),
                  ),
                ),
                if (!creating)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: busy ? null : () => _resetPassword(context),
                      style: TextButton.styleFrom(
                        minimumSize: Size(
                          0,
                          sketchNarrow
                              ? 26
                              : tightWide
                              ? 26
                              : 34,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      child: Text(
                        t('forgot'),
                        style: TextStyle(fontSize: sketchNarrow ? 10 : null),
                      ),
                    ),
                  ),
                if (error != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    error!,
                    style: const TextStyle(color: danger, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 6),
                SizedBox(
                  height: sketchNarrow
                      ? narrowTight
                            ? 34
                            : 38
                      : tightWide
                      ? 40
                      : compact
                      ? 44
                      : 48,
                  child: FilledButton(
                    onPressed: busy ? null : () => run(enter),
                    child: Text(
                      t(
                        busy
                            ? 'loading'
                            : creating
                            ? 'register'
                            : 'login',
                      ),
                      style: TextStyle(fontSize: sketchNarrow ? 11 : null),
                    ),
                  ),
                ),
                if (!creating) ...[
                  const SizedBox(height: 4),
                  OutlinedButton(
                    onPressed: busy
                        ? null
                        : () => run(() async {
                            final repo = await LocalRepository.open(
                              currency,
                              country: country,
                            );
                            if (mounted) widget.onOpen(repo);
                          }),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(
                        0,
                        sketchNarrow
                            ? narrowTight
                                  ? 32
                                  : 34
                            : tightWide
                            ? 34
                            : compact
                            ? 40
                            : 44,
                      ),
                      side: const BorderSide(color: border),
                    ),
                    child: Text(
                      t('preview'),
                      style: TextStyle(fontSize: sketchNarrow ? 11 : null),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton.icon(
                      onPressed: () => _openLegal(context),
                      icon: const Icon(Icons.privacy_tip_outlined, size: 16),
                      label: Text(
                        t('legalRead'),
                        style: TextStyle(
                          fontSize: sketchNarrow
                              ? 10
                              : tightWide
                              ? 11
                              : 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _legalConsent(
    BuildContext context, {
    bool compact = false,
    bool condensed = false,
  }) => condensed
      ? Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 26,
                height: 26,
                child: Checkbox(
                  value: legalAccepted,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: busy
                      ? null
                      : (value) =>
                            setState(() => legalAccepted = value ?? false),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      t('legalAcceptShort'),
                      style: const TextStyle(fontSize: 10, height: 1.15),
                    ),
                    TextButton(
                      onPressed: () => _openLegal(context),
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        t('legalRead'),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: compact,
              visualDensity: compact ? VisualDensity.compact : null,
              controlAffinity: ListTileControlAffinity.leading,
              value: legalAccepted,
              onChanged: busy
                  ? null
                  : (value) => setState(() => legalAccepted = value ?? false),
              title: Text(
                t('legalAccept'),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _openLegal(context),
                icon: const Icon(Icons.privacy_tip_outlined, size: 18),
                label: Text(t('legalRead')),
              ),
            ),
          ],
        );

  List<Widget> setupFields({
    bool compact = false,
    bool sideBySide = false,
    bool tighter = false,
    double? fieldHeight,
  }) {
    final fieldPadding = compact
        ? EdgeInsets.symmetric(horizontal: 10, vertical: tighter ? 12 : 10)
        : null;
    final countryField = DropdownButtonFormField<String>(
      initialValue: country,
      isExpanded: true,
      itemHeight: fieldHeight,
      decoration: InputDecoration(
        labelText: t('country'),
        isDense: compact,
        constraints: fieldHeight == null
            ? null
            : BoxConstraints(minHeight: fieldHeight),
        contentPadding: fieldPadding,
      ),
      items: [
        ...countries.keys,
        'otherCountry',
      ].map((c) => DropdownMenuItem(value: c, child: Text(t(c)))).toList(),
      onChanged: (v) {
        if (v != null) {
          setState(() {
            country = v;
            currency = countries[v] ?? currency;
          });
        }
      },
    );
    final currencyField = DropdownButtonFormField<String>(
      key: ValueKey(currency),
      initialValue: currency,
      itemHeight: fieldHeight,
      decoration: InputDecoration(
        labelText: t('currency'),
        isDense: compact,
        constraints: fieldHeight == null
            ? null
            : BoxConstraints(minHeight: fieldHeight),
        contentPadding: fieldPadding,
      ),
      items: currencies
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: (v) {
        if (v != null) setState(() => currency = v);
      },
    );
    final countryControl = fieldHeight == null
        ? countryField
        : SizedBox(height: fieldHeight, child: countryField);
    final currencyControl = fieldHeight == null
        ? currencyField
        : SizedBox(height: fieldHeight, child: currencyField);
    if (sideBySide) {
      return [
        Row(
          children: [
            Expanded(child: countryControl),
            const SizedBox(width: 8),
            Expanded(child: currencyControl),
          ],
        ),
        const SizedBox(height: 4),
        Text(t('currencyHelp'), style: const TextStyle(fontSize: 10)),
      ];
    }
    return [
      countryControl,
      SizedBox(height: compact ? (tighter ? 5 : 8) : 14),
      currencyControl,
      SizedBox(height: tighter ? 4 : 6),
      Text(
        t('currencyHelp'),
        style: TextStyle(
          fontSize: tighter
              ? 9
              : compact
              ? 10
              : 12,
        ),
      ),
    ];
  }
}
