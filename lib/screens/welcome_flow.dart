import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../assets/library.dart';
import '../l10n/strings.dart';
import '../models/family.dart';
import '../services/money.dart';
import '../services/repository.dart';
import '../widgets/surfaces.dart';
import '../widgets/money_input.dart';
import 'sign_in.dart';

/// The app-mark is a square icon.  The first screen instead uses the full
/// transparent jar artwork so it feels like a welcome illustration rather
/// than a small logo floating in a box.
class _WelcomeRoleHero extends StatelessWidget {
  const _WelcomeRoleHero();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.clamp(220.0, 300.0).toDouble();
        final height = (width * .58).clamp(138.0, 174.0).toDouble();
        final jar = (height * .98).clamp(136.0, 170.0).toDouble();
        return Center(
          child: SizedBox(
            width: width,
            height: height,
            child: CustomPaint(
              painter: const _WelcomeRoleArcPainter(),
              child: Center(
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
        );
      },
    );
  }
}

class _WelcomeRoleArcPainter extends CustomPainter {
  const _WelcomeRoleArcPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * .50, size.height * .50);
    final radius = size.width * .44;
    final circle = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: const [Color(0x16D7F2E6), Color(0x00FFFFFF)],
          stops: const [.12, 1],
        ).createShader(circle),
    );
    canvas.drawArc(
      circle,
      3.34,
      3.62,
      false,
      Paint()
        ..color = const Color(0x4C98DABF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _WelcomeRoleArcPainter oldDelegate) => false;
}

class _WelcomeCenteredHeading extends StatelessWidget {
  final String title, subtitle;
  const _WelcomeCenteredHeading({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final compact = compactPhone(context);
    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 20 : 28,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: muted),
          ),
        ],
      ),
    );
  }
}

class WelcomeFlow extends StatefulWidget {
  final Strings strings;
  final bool firebaseReady;
  final String? invitation, initialMode;
  final bool childInvitation;
  final Future<FamilyRepository> Function()? previewFactory;
  final void Function(FamilyRepository) onOpen;
  const WelcomeFlow({
    super.key,
    required this.strings,
    required this.firebaseReady,
    required this.onOpen,
    this.invitation,
    this.initialMode,
    this.childInvitation = false,
    this.previewFactory,
  });
  @override
  State<WelcomeFlow> createState() => _WelcomeFlowState();
}

class _WelcomeFlowState extends State<WelcomeFlow> {
  String? mode;
  FamilyRepository? setup;
  FamilyRepository? restoredParent;
  bool busy = false;
  bool adultConfirmed = false;
  String? error;
  String t(String key) => widget.strings(key);
  @override
  void initState() {
    super.initState();
    mode = widget.initialMode;
    if (widget.invitation != null) {
      mode = widget.childInvitation ? 'child' : 'join';
    } else if (widget.firebaseReady && mode == null) {
      restore();
    }
  }

  Future<void> restore() async {
    setState(() => busy = true);
    try {
      final repo = await CloudRepository.resume();
      if (repo != null && repo.parent) {
        // Do not enter the parent area from a restored session until the
        // adult has confirmed this is the parent/caregiver area. That keeps
        // the child route free of both the parent controls and ad SDK use.
        if (mounted) setState(() => restoredParent = repo);
      } else if (repo != null) {
        await opened(repo);
      }
    } catch (_) {
      if (mounted) setState(() => error = t('connectionError'));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> opened(FamilyRepository repo) async {
    try {
      // Invited parents and children bypass setup; existing families remain intact.
      if (repo.parent && mode != 'join' && (await repo.watch().first).isEmpty) {
        if (mounted) setState(() => setup = repo);
      } else if (mounted) {
        widget.onOpen(repo);
      }
    } catch (_) {
      await repo.close();
      if (mounted) setState(() => error = t('connectionError'));
    }
  }

  Future<void> leaveRestoredParent() async {
    final repo = restoredParent;
    if (repo == null) return;
    await FirebaseAuth.instance.signOut();
    await repo.close();
    if (mounted) setState(() => restoredParent = null);
  }

  Future<void> continueRestoredParent() async {
    final repo = restoredParent;
    if (repo == null) return;
    setState(() {
      restoredParent = null;
      adultConfirmed = true;
    });
    await opened(repo);
  }

  @override
  Widget build(BuildContext context) {
    if (setup != null) {
      return ParentSetup(
        strings: widget.strings,
        repository: setup!,
        onOpen: widget.onOpen,
      );
    }
    if (restoredParent != null) {
      return _ParentAccessGate(
        strings: widget.strings,
        onBack: leaveRestoredParent,
        onContinue: continueRestoredParent,
      );
    }
    if (mode != null && mode != 'child' && !adultConfirmed) {
      return _ParentAccessGate(
        strings: widget.strings,
        onBack: () => setState(() => mode = null),
        onContinue: () => setState(() => adultConfirmed = true),
      );
    }
    if (mode != null) {
      if (widget.previewFactory != null && mode == 'create') {
        return Scaffold(
          appBar: AppBar(
            title: Text(t('name')),
            leading: BackButton(
              onPressed: busy ? null : () => setState(() => mode = null),
            ),
          ),
          body: pageBody([
            Text(t('stepOf').replaceAll('{step}', '1')),
            const SizedBox(height: 20),
            heading(t('createAccountTitle'), t('wizardDemo')),
            FilledButton(
              onPressed: busy
                  ? null
                  : () async {
                      setState(() => busy = true);
                      try {
                        await opened(await widget.previewFactory!());
                      } catch (_) {
                        if (mounted) {
                          setState(() => error = t('connectionError'));
                        }
                      } finally {
                        if (mounted) setState(() => busy = false);
                      }
                    },
              child: Text(t('continue')),
            ),
            if (error != null) Text(error!),
          ]),
        );
      }
      return SignIn(
        strings: widget.strings,
        firebaseReady: widget.firebaseReady,
        invitation: widget.invitation,
        mode: mode,
        onBack: () => setState(() => mode = null),
        onOpen: opened,
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(t('name'))),
      body: pageBody([
        const _WelcomeRoleHero(),
        const SizedBox(height: 12),
        _WelcomeCenteredHeading(
          title: t('whoUses'),
          subtitle: t('welcomeEasy'),
        ),
        FilledButton.icon(
          onPressed: busy ? null : () => setState(() => mode = 'create'),
          icon: const Icon(Icons.family_restroom),
          label: Text(t('imParent')),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: busy ? null : () => setState(() => mode = 'child'),
          icon: const Icon(Icons.face),
          label: Text(t('imChild')),
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: busy ? null : () => setState(() => mode = 'login'),
          child: Text(t('alreadyAccount')),
        ),
        TextButton(
          onPressed: busy ? null : () => setState(() => mode = 'join'),
          child: Text(t('joinParent')),
        ),
        if (busy) const Center(child: CircularProgressIndicator()),
        if (error != null)
          Center(
            child: Text(error!, style: const TextStyle(color: danger)),
          ),
        if (widget.previewFactory != null) Center(child: Text(t('wizardDemo'))),
      ]),
    );
  }
}

/// A calm adult confirmation before any parent account or parent invitation
/// flow. The child route never reaches this screen and never initializes ads.
class _ParentAccessGate extends StatelessWidget {
  final Strings strings;
  final VoidCallback onBack, onContinue;
  const _ParentAccessGate({
    required this.strings,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(strings('name')),
      leading: BackButton(onPressed: onBack),
    ),
    body: pageBody([
      const SizedBox(height: 28),
      const Icon(Icons.family_restroom, size: 48, color: green),
      const SizedBox(height: 20),
      heading(strings('parentGateTitle'), strings('parentGateBody')),
      FilledButton(
        key: const Key('parent-access-continue'),
        onPressed: onContinue,
        child: Text(strings('parentGateContinue')),
      ),
      const SizedBox(height: 10),
      TextButton(onPressed: onBack, child: Text(strings('parentGateBack'))),
    ]),
  );
}

/// The first screen is intentionally a different composition from the app
/// screens: it gives the jar its own visual space and keeps the choice small
/// and calm. Duo gets two balanced panes; phones use the same ingredients in a
/// compact vertical layout.
/*
class _WelcomeStart extends StatelessWidget {
  final String title, question, helper, parent, child, signIn, invitation;
  final String? error;
  final bool busy;
  final VoidCallback onParent, onChild, onSignIn, onInvitation;
  const _WelcomeStart({
    required this.title,
    required this.question,
    required this.helper,
    required this.parent,
    required this.child,
    required this.signIn,
    required this.invitation,
    required this.busy,
    required this.onParent,
    required this.onChild,
    required this.onSignIn,
    required this.onInvitation,
    this.error,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title), centerTitle: true),
    body: SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide =
              constraints.maxWidth >= 700 && constraints.maxHeight >= 400;
          final content = wide
              ? Row(
                  children: [
                    Expanded(child: _JarWelcomeHero(wide: true)),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Center(
                        child: _WelcomeChoices(
                          question: question,
                          helper: helper,
                          parent: parent,
                          child: child,
                          signIn: signIn,
                          invitation: invitation,
                          error: error,
                          busy: busy,
                          onParent: onParent,
                          onChild: onChild,
                          onSignIn: onSignIn,
                          onInvitation: onInvitation,
                          compact: false,
                        ),
                      ),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 2),
                      const _JarWelcomeHero(wide: false),
                      const SizedBox(height: 8),
                      _WelcomeChoices(
                        question: question,
                        helper: helper,
                        parent: parent,
                        child: child,
                        signIn: signIn,
                        invitation: invitation,
                        error: error,
                        busy: busy,
                        onParent: onParent,
                        onChild: onChild,
                        onSignIn: onSignIn,
                        onInvitation: onInvitation,
                        compact: true,
                      ),
                    ],
                  ),
                );
          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _WelcomeArcPainter(wide)),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: wide ? 44 : 0,
                      vertical: wide ? 18 : 0,
                    ),
                    child: content,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

class _JarWelcomeHero extends StatelessWidget {
  final bool wide;
  const _JarWelcomeHero({required this.wide});

  @override
  Widget build(BuildContext context) {
    final jarSize = wide ? 280.0 : 168.0;
    return SizedBox(
      height: wide ? double.infinity : 190,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: jarSize + (wide ? 96 : 52),
              height: jarSize + (wide ? 96 : 52),
              decoration: BoxDecoration(
                color: const Color(0x1516765B),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x3B16765B), width: 2),
              ),
            ),
            Positioned(
              top: wide ? -2 : 4,
              child: Icon(
                Icons.auto_awesome,
                color: const Color(0xFFFFC94E),
                size: wide ? 30 : 20,
              ),
            ),
            Image.asset(
              AssetLibrary.jar.path,
              height: jarSize,
              fit: BoxFit.contain,
              semanticLabel: 'ChoreJar',
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeChoices extends StatelessWidget {
  final String question, helper, parent, child, signIn, invitation;
  final String? error;
  final bool busy, compact;
  final VoidCallback onParent, onChild, onSignIn, onInvitation;
  const _WelcomeChoices({
    required this.question,
    required this.helper,
    required this.parent,
    required this.child,
    required this.signIn,
    required this.invitation,
    required this.busy,
    required this.onParent,
    required this.onChild,
    required this.onSignIn,
    required this.onInvitation,
    required this.compact,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = compact ? 44.0 : 48.0;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 370),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(220),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0x2B16765B)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x120F3027),
              blurRadius: 22,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            compact ? 18 : 28,
            24,
            compact ? 16 : 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                question,
                textAlign: compact ? TextAlign.center : TextAlign.left,
                style: TextStyle(
                  fontSize: compact ? 19 : 25,
                  height: 1.12,
                  fontWeight: FontWeight.w800,
                  color: ink,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                helper,
                textAlign: compact ? TextAlign.center : TextAlign.left,
                style: TextStyle(
                  fontSize: compact ? 12 : 14,
                  color: const Color(0xFF576D68),
                ),
              ),
              SizedBox(height: compact ? 18 : 26),
              SizedBox(
                height: buttonHeight,
                child: FilledButton.icon(
                  onPressed: busy ? null : onParent,
                  icon: const Icon(Icons.family_restroom, size: 18),
                  label: Text(parent),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: buttonHeight,
                child: OutlinedButton.icon(
                  onPressed: busy ? null : onChild,
                  icon: const Icon(Icons.face, size: 18),
                  label: Text(child),
                ),
              ),
              SizedBox(height: compact ? 12 : 18),
              TextButton(
                onPressed: busy ? null : onSignIn,
                style: TextButton.styleFrom(minimumSize: const Size(0, 34)),
                child: Text(signIn),
              ),
              TextButton(
                onPressed: busy ? null : onInvitation,
                style: TextButton.styleFrom(minimumSize: const Size(0, 34)),
                child: Text(invitation),
              ),
              if (busy) ...[
                const SizedBox(height: 10),
                const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ],
              if (error != null) ...[
                const SizedBox(height: 10),
                Text(
                  error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeArcPainter extends CustomPainter {
  final bool wide;
  const _WelcomeArcPainter(this.wide);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x2E16765B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = wide ? 3 : 2;
    final radius = wide ? size.height * .78 : size.width * .72;
    final center = wide
        ? Offset(size.width * .48, size.height * .50)
        : Offset(size.width * .50, -size.width * .18);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      wide ? -1.18 : .12,
      wide ? 2.36 : 2.90,
      false,
      paint,
    );
    final smallPaint = Paint()
      ..color = const Color(0x2016765B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * .78),
      wide ? -1.08 : .22,
      wide ? 2.16 : 2.70,
      false,
      smallPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _WelcomeArcPainter oldDelegate) =>
      oldDelegate.wide != wide;
}

*/
class ParentSetup extends StatefulWidget {
  final Strings strings;
  final FamilyRepository repository;
  final void Function(FamilyRepository) onOpen;
  const ParentSetup({
    super.key,
    required this.strings,
    required this.repository,
    required this.onOpen,
  });
  @override
  State<ParentSetup> createState() => _ParentSetupState();
}

class _ParentSetupState extends State<ParentSetup> {
  final name = TextEditingController(), reward = TextEditingController();
  final childId = newId(), taskId = newId();
  int step = 2;
  String avatar = 'star', task = 'firstToys';
  bool busy = false;
  String? error;
  String t(String key) => widget.strings(key);
  @override
  void dispose() {
    name.dispose();
    reward.dispose();
    super.dispose();
  }

  Future<void> save({bool skip = false}) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final child = ChildData(
        id: childId,
        name: name.text.trim(),
        avatar: avatar,
        currency: widget.repository.currency,
      );
      if (!skip) {
        child.addTask(
          Task(
            id: taskId,
            title: t(task),
            due: day(DateTime.now()),
            amount: parseMoney(reward.text, child.currency, zero: true),
          ),
        );
      }
      child.validate();
      // A stable ID makes a retry safe after an ambiguous network result.
      final existing = await widget.repository.watch().first;
      if (!existing.any((c) => c.id == childId)) {
        await widget.repository.create(child);
      }
      if (mounted) setState(() => step = 4);
    } on DomainError catch (e) {
      if (mounted) setState(() => error = t(e.key));
    } catch (_) {
      if (mounted) setState(() => error = t('connectionError'));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(t('name')), automaticallyImplyLeading: false),
    body: pageBody([
      Text(t('stepOf').replaceAll('{step}', '$step')),
      const SizedBox(height: 10),
      LinearProgressIndicator(value: step / 4),
      const SizedBox(height: 24),
      if (step == 2) ...[
        heading(t('addYourChild'), t('childSetupHelp')),
        TextField(
          controller: name,
          maxLength: 40,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: t('childName')),
        ),
        const SizedBox(height: 16),
        Text(t('chooseAvatar')),
        Wrap(
          spacing: 12,
          children: [
            for (final entry in {
              'star': '⭐',
              'cat': '🐱',
              'dog': '🐶',
              'rocket': '🚀',
            }.entries)
              ChoiceChip(
                label: Text(entry.value, style: const TextStyle(fontSize: 32)),
                selected: avatar == entry.key,
                onSelected: busy
                    ? null
                    : (_) => setState(() => avatar = entry.key),
              ),
          ],
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () {
            if (name.text.trim().isEmpty) {
              setState(() => error = t('childNameRequired'));
              return;
            }
            setState(() {
              step = 3;
              error = null;
            });
          },
          child: Text(t('continue')),
        ),
      ],
      if (step == 3) ...[
        heading(t('firstTask'), t('firstTaskHelp')),
        for (final choice in ['firstToys', 'firstBed', 'firstPlants'])
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OutlinedButton.icon(
              onPressed: busy ? null : () => setState(() => task = choice),
              icon: Icon(
                task == choice ? Icons.check_circle : Icons.circle_outlined,
              ),
              label: Text(t(choice)),
            ),
          ),
        MoneyInput(
          controller: reward,
          enabled: !busy,
          label: '${t('rewardLabel')} (${widget.repository.currency})',
          helperText: t('rewardHelp'),
          doneLabel: t('keyboardDone'),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: busy ? null : () => save(),
          child: Text(t(busy ? 'loading' : 'continue')),
        ),
        TextButton(
          onPressed: busy ? null : () => save(skip: true),
          child: Text(t('taskLater')),
        ),
        TextButton(
          onPressed: busy
              ? null
              : () => setState(() {
                  step = 2;
                  error = null;
                }),
          child: Text(t('back')),
        ),
      ],
      if (step == 4) ...[
        const Icon(Icons.check_circle, size: 80, color: green),
        const SizedBox(height: 20),
        heading(
          t('allReady'),
          t('readyHelp').replaceAll('{name}', name.text.trim()),
        ),
        Text(t('optionalSetupHelp')),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => widget.onOpen(widget.repository),
          child: Text(t('goParents')),
        ),
      ],
      if (error != null)
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(error!, style: const TextStyle(color: danger)),
        ),
    ]),
  );
}
