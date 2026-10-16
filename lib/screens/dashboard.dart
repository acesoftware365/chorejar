import '../widgets/child_invitation_dialog.dart';
import '../services/advertising.dart';
import '../widgets/parent_ad_banner.dart';
import 'membership.dart';
import 'legal_privacy.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../services/parent_invitation.dart';
import '../l10n/strings.dart';
import '../models/family.dart';
import '../services/repository.dart';
import '../services/money.dart';
import '../services/regional_brand.dart';
import '../widgets/editor.dart';
import '../widgets/surfaces.dart';
import '../widgets/child_money.dart';
import '../widgets/goal_image.dart';

class Dashboard extends StatefulWidget {
  final FamilyRepository repository;
  final Strings strings;
  final String language, languageChoice;
  final Future<void> Function(String) onLanguage;
  final Future<void> Function() onExit;
  final Future<void> Function()? onAccount;
  const Dashboard({
    super.key,
    required this.repository,
    required this.strings,
    required this.language,
    required this.languageChoice,
    required this.onLanguage,
    required this.onExit,
    this.onAccount,
  });
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  StreamSubscription<List<ChildData>>? subscription;
  List<ChildData> children = [];
  String? selected, error;
  bool loading = true, busy = false, previewChild = false;
  int tab = 0;
  final accruing = <String>{};
  FamilyRepository get repo => widget.repository;
  String t(String k) => k == 'name'
      ? appNameFor(repo.country, fallback: widget.strings(k))
      : widget.strings(k);
  bool get compact => compactPhone(context);
  bool get parent => repo.parent && !previewChild;
  String cash(int v, ChildData c) => money(v, c.currency, widget.language);
  ChildData? get current {
    final found = children.where((c) => c.id == selected).toList();
    if (found.isNotEmpty) return found.first;
    final active = children.where((c) => !c.archived).toList();
    return active.isEmpty ? null : active.first;
  }

  @override
  void initState() {
    super.initState();
    if (!repo.parent) tab = 1;
    WidgetsBinding.instance.addObserver(this);
    listen();
    if (repo.parent) Advertising.instance.initializeForParent();
  }

  @override
  void dispose() {
    subscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) refresh();
    if (state == AppLifecycleState.paused && !repo.local) {
      subscription?.cancel();
    }
  }

  void listen() {
    subscription?.cancel();
    subscription = repo.watch().listen(
      (items) {
        if (!mounted) return;
        setState(() {
          children = items;
          loading = false;
          error = null;
        });
        accrue(items);
      },
      onError: (Object failure) {
        if (mounted) {
          setState(() {
            children = [];
            selected = null;
            error = t(
              failure is FirebaseException &&
                      failure.code == 'permission-denied'
                  ? 'pairAccessRemoved'
                  : 'connectionError',
            );
            loading = false;
          });
        }
      },
    );
  }

  Future<void> accrue(List<ChildData> items) async {
    if (!repo.parent) return;
    for (final c in items) {
      if (c.archived ||
          c.mode == 'tasks' ||
          c.allowanceAmount <= 0 ||
          c.allowanceNext.isEmpty ||
          c.allowanceNext.compareTo(day(DateTime.now())) > 0 ||
          !accruing.add(c.id)) {
        continue;
      }
      try {
        await repo.change(c.id, (fresh) => fresh.accrue(DateTime.now()));
      } catch (_) {
        if (mounted) setState(() => error = t('connectionError'));
      } finally {
        accruing.remove(c.id);
      }
    }
  }

  Future<void> refresh() async {
    listen();
    await accrue(children);
  }

  Future<void> run(
    Future<void> Function() action, {
    String? success = 'success',
  }) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await action();
      if (mounted && success != null) notice(t(success));
    } on DomainError catch (e) {
      if (mounted) notice(t(e.key));
    } catch (_) {
      if (mounted) notice(t('connectionError'));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void notice(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  @override
  Widget build(BuildContext context) {
    final c = current;
    if (!parent && c != null && !c.archived && error == null) {
      return childDashboard(c);
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: compact ? 52 : 56,
        title: Text(
          t('name'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: compact ? 20 : 22,
          ),
        ),
        actions: [settingsButton()],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: pageBody([
          Text(
            t(repo.local ? 'previewBanner' : 'cloud'),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          if (repo.parent &&
              (!compact || children.where((k) => !k.archived).length > 1)) ...[
            SizedBox(height: compact ? 6 : 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final kid in children.where((k) => !k.archived))
                  ChoiceChip(
                    label: Text(kid.name),
                    selected: c?.id == kid.id,
                    onSelected: (_) => setState(() => selected = kid.id),
                  ),
                if (parent)
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 18),
                    label: Text(t('addChild')),
                    onPressed: busy ? null : () => editChild(),
                  ),
              ],
            ),
          ],
          SizedBox(height: compact ? 4 : 22),
          if (error != null)
            panel(
              Column(
                children: [
                  Text(error!),
                  TextButton(onPressed: refresh, child: Text(t('retry'))),
                ],
              ),
            ),
          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (c == null) ...[
            heading(t('noChildren'), t('noChildrenSub')),
            if (parent)
              FilledButton.icon(
                onPressed: () => editChild(),
                icon: const Icon(Icons.add),
                label: Text(t('addChild')),
              ),
          ] else if (c.archived && !repo.parent)
            Text(t('permission'))
          else ...[
            if (parent && compact)
              Column(
                key: const Key('compact-parent-profile'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.name,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        key: const Key('profile-actions'),
                        tooltip: t('profileActions'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 14,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                t('profileShort'),
                                style: const TextStyle(
                                  color: green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Icon(
                                Icons.expand_more,
                                color: green,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                        onSelected: (value) {
                          if (value == 'add') {
                            editChild();
                          }
                          if (value == 'edit') {
                            editChild(c);
                          }
                          if (value == 'preview') {
                            setState(() => previewChild = true);
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'add',
                            child: Text(t('addChild')),
                          ),
                          PopupMenuItem(
                            value: 'edit',
                            child: Text(t('editChild')),
                          ),
                          PopupMenuItem(
                            value: 'preview',
                            child: Text(t('childView')),
                          ),
                        ],
                      ),
                      IconButton(
                        tooltip: t('deleteChild'),
                        color: danger,
                        onPressed: busy ? null : () => deleteChild(c),
                        icon: const Icon(Icons.delete_outline, size: 21),
                      ),
                    ],
                  ),
                  FilledButton.tonalIcon(
                    key: const Key('link-child-device'),
                    onPressed: busy ? null : () => linkChild(c),
                    icon: const Icon(Icons.qr_code_rounded, size: 20),
                    label: Text(t('link')),
                  ),
                ],
              )
            else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: heading(c.name, parent ? null : t('tagline')),
                  ),
                  if (parent) ...[
                    const SizedBox(width: 12),
                    Flexible(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: compact
                            ? IconButton.outlined(
                                tooltip: t('deleteChild'),
                                onPressed: busy ? null : () => deleteChild(c),
                                style: IconButton.styleFrom(
                                  foregroundColor: danger,
                                  side: const BorderSide(color: danger),
                                ),
                                icon: const Icon(Icons.delete_outline),
                              )
                            : OutlinedButton.icon(
                                onPressed: busy ? null : () => deleteChild(c),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: danger,
                                  side: const BorderSide(color: danger),
                                ),
                                icon: const Icon(Icons.delete_outline),
                                label: Text(t('deleteChild')),
                              ),
                      ),
                    ),
                  ],
                ],
              ),
              if (parent)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    TextButton.icon(
                      onPressed: () => editChild(c),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: Text(t('editChild')),
                    ),
                    TextButton.icon(
                      onPressed: () => setState(() => previewChild = true),
                      icon: const Icon(Icons.face_outlined, size: 18),
                      label: Text(t('childView')),
                    ),
                  ],
                ),
              if (parent) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.tonalIcon(
                    key: const Key('link-child-device'),
                    onPressed: busy ? null : () => linkChild(c),
                    icon: const Icon(Icons.qr_code_rounded),
                    label: Text(t('link')),
                  ),
                ),
              ],
            ],
            if (previewChild && repo.parent)
              TextButton(
                onPressed: () => setState(() => previewChild = false),
                child: Text(t('backParents')),
              ),
            const SizedBox(key: Key('section-start'), height: 10),
            if (tab == 0)
              ...taskView(c)
            else if (tab == 1)
              ...moneyView(c)
            else
              ...goalView(c),
          ],
          if (parent && children.any((c) => c.archived))
            ExpansionTile(
              title: Text(t('archived')),
              children: [
                for (final archived in children.where((c) => c.archived))
                  ListTile(
                    title: Text(archived.name),
                    trailing: TextButton(
                      onPressed: () => run(
                        () => repo.change(archived.id, (c) {
                          c.archived = false;
                          c.allowanceNext = day(DateTime.now());
                        }),
                      ),
                      child: Text(t('restore')),
                    ),
                  ),
              ],
            ),
          if (repo.local) ...[
            const SizedBox(height: 24),
            Text(t('previewHelp'), style: const TextStyle(fontSize: 12)),
          ],
          const SizedBox(height: 30),
        ], adaptiveColumns: parent),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: Advertising.instance,
          builder: (context, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: NavigationBar(
                  height: compact ? 64 : 72,
                  selectedIndex: tab,
                  onDestinationSelected: (v) => setState(() => tab = v),
                  destinations: [
                    NavigationDestination(
                      icon: const Icon(Icons.check_circle_outline),
                      label: t('tasks'),
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.account_balance_wallet_outlined),
                      label: t('money'),
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.flag_outlined),
                      label: t('goal'),
                    ),
                  ],
                ),
              ),
              if (parent && Advertising.instance.showBanner)
                ParentAdBanner(spanish: widget.language == 'es'),
            ],
          ),
        ),
      ),
    );
  }

  Widget childDashboard(ChildData c) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        textTheme: theme.textTheme.apply(
          fontFamily: 'Nunito',
          bodyColor: childInk,
          displayColor: childInk,
        ),
        scaffoldBackgroundColor: childCream,
      ),
      child: Scaffold(
        backgroundColor: childCream,
        appBar: AppBar(
          backgroundColor: childCream,
          surfaceTintColor: Colors.transparent,
          toolbarHeight: compact ? 58 : 76,
          centerTitle: true,
          title: Text(
            t(['tasks', 'money', 'goal'][tab]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: compact ? 28 : 36,
              fontWeight: FontWeight.w900,
              color: childGreen,
            ),
          ),
          actions: [settingsButton()],
        ),
        body: Column(
          children: [
            if (repo.local)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  t('previewBanner'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10, color: childMuted),
                ),
              ),
            if (previewChild && repo.parent)
              TextButton(
                onPressed: () => setState(() => previewChild = false),
                child: Text(t('backParents')),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refresh,
                child: tab == 1
                    ? ChildMoney(
                        child: c,
                        strings: widget.strings,
                        language: widget.language,
                        onGoal: () => setState(() => tab = 2),
                        onDetails: () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (_) => FractionallySizedBox(
                            heightFactor: .85,
                            child: pageBody(moneyView(c)),
                          ),
                        ),
                      )
                    : pageBody(tab == 0 ? taskView(c) : goalView(c)),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ChildNavigation(
          selected: tab,
          strings: widget.strings,
          onSelected: (value) => setState(() => tab = value),
        ),
      ),
    );
  }

  Widget hero(ChildData c) => panel(
    Row(
      children: [
        Icon(Icons.savings_rounded, size: compact ? 38 : 48, color: gold),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t(parent ? 'pending' : 'available'),
                style: const TextStyle(color: paper),
              ),
              const SizedBox(height: 4),
              Text(
                cash(parent ? c.pending : c.available, c),
                style: TextStyle(
                  fontSize: compact ? 24 : 30,
                  fontWeight: FontWeight.w800,
                  color: paper,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    color: green,
  );
  List<Widget> taskView(ChildData c) {
    final active =
        c.tasks.values
            .where((v) => !['approved', 'cancelled'].contains(v.status))
            .toList()
          ..sort((a, b) => a.due.compareTo(b.due));
    final past = c.tasks.values
        .where((v) => ['approved', 'cancelled'].contains(v.status))
        .toList();
    return [
      hero(c),
      SizedBox(height: compact ? 0 : 8),
      heading(
        t(parent ? 'reviewTitle' : 'today'),
        parent ? null : t('todaySub'),
      ),
      if (parent && c.mode != 'allowance')
        Padding(
          padding: EdgeInsets.only(bottom: compact ? 10 : 18),
          child: FilledButton.icon(
            onPressed: busy ? null : () => editTask(c),
            icon: const Icon(Icons.add),
            label: Text(t('addTask')),
          ),
        ),
      if (active.isEmpty) panel(Text(t('noTasks'))),
      for (final task in active) taskCard(c, task),
      if (past.isNotEmpty)
        ExpansionTile(
          title: Text(t('history')),
          children: past.reversed.map((task) => taskCard(c, task)).toList(),
        ),
      if (c.mode != 'tasks' && c.allowanceAmount > 0)
        panel(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t('allowance'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${cash(c.allowanceAmount, c)} · ${t(c.allowanceFrequency)}',
              ),
              if (c.allowanceNext.isNotEmpty)
                Text('${t('firstDate')}: ${c.allowanceNext}'),
              const SizedBox(height: 10),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(t('moneyDetails')),
                children: [Text(t('allowanceHelp'))],
              ),
            ],
          ),
        ),
    ];
  }

  Widget taskCard(ChildData c, Task task) => panel(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.auto_awesome_rounded, color: green),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: compact ? 16 : 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (parent && ['pending', 'correction'].contains(task.status))
              IconButton(
                onPressed: () => editTask(c, task),
                tooltip: t('editTask'),
                icon: const Icon(Icons.edit_outlined),
              ),
          ],
        ),
        if (task.instructions.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(task.instructions),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 14,
          runSpacing: 8,
          children: [
            Text(
              cash(task.amount, c),
              style: const TextStyle(color: green, fontWeight: FontWeight.w800),
            ),
            Text(
              '${DateFormat.MMMd(widget.language).format(DateTime.parse(task.due))} · ${t(task.frequency)}',
              style: TextStyle(fontSize: compact ? 12 : 14),
            ),
            Text(t(task.status == 'pending' ? 'openTask' : task.status)),
          ],
        ),
        if (task.feedback.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(task.feedback),
        ],
        if (task.status == 'review' || !parent) const SizedBox(height: 12),
        if (parent && task.status == 'review')
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: busy
                    ? null
                    : () => run(
                        () => repo.change(
                          c.id,
                          (fresh) =>
                              fresh.review(task.id, true, '', DateTime.now()),
                        ),
                      ),
                child: Text(t('approve')),
              ),
              OutlinedButton(
                onPressed: busy
                    ? null
                    : () => editor(
                        context,
                        widget.strings,
                        'correct',
                        [
                          const InputField(
                            'feedback',
                            'feedback',
                            multiline: true,
                            maxLength: 500,
                          ),
                        ],
                        (v) => repo.change(
                          c.id,
                          (fresh) => fresh.review(
                            task.id,
                            false,
                            v['feedback']!,
                            DateTime.now(),
                          ),
                        ),
                      ),
                child: Text(t('correct')),
              ),
            ],
          ),
        if (!parent && ['pending', 'correction'].contains(task.status))
          FilledButton.icon(
            onPressed: busy || task.due.compareTo(day(DateTime.now())) > 0
                ? null
                : () => run(() async {
                    if (repo.parent) {
                      await repo.change(
                        c.id,
                        (fresh) => fresh.submit(task.id, DateTime.now()),
                      );
                    } else {
                      await repo.submit(c.id, task.id);
                    }
                  }, success: 'sent'),
            icon: const Icon(Icons.check),
            label: Text(t('submit')),
          ),
      ],
    ),
  );
  List<Widget> moneyView(ChildData c) => [
    panel(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t('toGive'), style: const TextStyle(color: paper)),
          const SizedBox(height: 8),
          Text(
            cash(c.pending, c),
            style: TextStyle(
              fontSize: compact ? 28 : 36,
              fontWeight: FontWeight.w800,
              color: paper,
            ),
          ),
          const SizedBox(height: 16),
          if (parent)
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: paper,
                foregroundColor: green,
              ),
              onPressed: busy || c.pending <= 0
                  ? null
                  : () => move(c, 'payment'),
              child: Text(t(c.pending > 0 ? 'deliver' : 'nothingToGive')),
            ),
        ],
      ),
      color: green,
    ),
    panel(
      Column(
        children: [
          balance('available', c.available, c),
          balance('saved', c.savings, c),
        ],
      ),
    ),
    if (parent && c.cashOutRequest > 0)
      panel(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('cashOutRequest'),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text('${cash(c.cashOutRequest, c)} · ${t('cashOutParentHelp')}'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton(
                  onPressed: busy
                      ? null
                      : () => run(
                          () => repo.change(
                            c.id,
                            (fresh) => fresh.cashOutRequest = 0,
                          ),
                          success: null,
                        ),
                  child: Text(t('cancel')),
                ),
                FilledButton(
                  onPressed: busy
                      ? null
                      : () => run(
                          () => repo.change(
                            c.id,
                            (fresh) => fresh.cashOut(newId(), DateTime.now()),
                          ),
                          success: 'cashOut',
                        ),
                  child: Text(t('confirm')),
                ),
              ],
            ),
          ],
        ),
      ),
    if (c.reviewing > 0)
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.fact_check_outlined, color: green),
        title: Text(t('reviewMoneyNotice')),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => setState(() => tab = 0),
      ),
    ExpansionTile(
      key: ValueKey('money-details-${c.id}'),
      tilePadding: EdgeInsets.zero,
      title: Text(t('moneyDetails')),
      children: [
        balance('review', c.reviewing, c),
        balance('received', c.received, c),
        balance('spent', c.spent, c),
        Text(t('balanceHelp')),
        if (parent)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton(
                  onPressed: busy || c.available <= 0
                      ? null
                      : () => move(c, 'saving'),
                  child: Text(t('saveMoney')),
                ),
                OutlinedButton(
                  onPressed: busy || c.savings <= 0
                      ? null
                      : () => move(c, 'withdrawal'),
                  child: Text(t('withdraw')),
                ),
                OutlinedButton(
                  onPressed: busy || c.available <= 0
                      ? null
                      : () => move(c, 'spending'),
                  child: Text(t('spend')),
                ),
              ],
            ),
          ),
      ],
    ),
    ExpansionTile(
      key: ValueKey('money-history-${c.id}'),
      tilePadding: EdgeInsets.zero,
      title: Text(t('history')),
      children: [
        if (c.entries.isEmpty) Text(t('noHistory')),
        for (final e in c.entries.values.toList().reversed)
          panel(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    Text(
                      t(e.kind),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(cash(e.amount, c)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormat.yMd(
                    widget.language,
                  ).add_Hm().format(DateTime.parse(e.date).toLocal()),
                  style: const TextStyle(fontSize: 12),
                ),
                if (e.note.isNotEmpty) Text(e.note),
                if (c.reversed(e.id)) Text(t('reversed')),
                if (parent && e.kind != 'reversal' && !c.reversed(e.id))
                  TextButton(
                    onPressed: () => editor(
                      context,
                      widget.strings,
                      'reverse',
                      [
                        const InputField(
                          'reason',
                          'reason',
                          multiline: true,
                          maxLength: 500,
                        ),
                      ],
                      (v) => repo.change(
                        c.id,
                        (fresh) =>
                            fresh.reverse(e.id, v['reason']!, DateTime.now()),
                      ),
                      help: 'reverseHelp',
                    ),
                    child: Text(t('reverse')),
                  ),
              ],
            ),
          ),
      ],
    ),
  ];
  Widget balance(String label, int value, ChildData c) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(t(label))),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            cash(value, c),
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
  List<Widget> goalView(ChildData c) => [
    heading(t('goal'), t('goalSub')),
    panel(
      Column(
        children: [
          GoalImage(goalImageFor(c), size: 150),
          const SizedBox(height: 20),
          Text(
            c.goalName.isEmpty ? t('noGoal') : c.goalName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          if (c.goalAmount > 0) ...[
            LinearProgressIndicator(
              value: (c.goalMoney / c.goalAmount).clamp(0, 1),
              minHeight: 14,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 14),
            Text(
              '${cash(c.goalMoney, c)} ${t('of')} ${cash(c.goalAmount, c)}',
              textAlign: TextAlign.center,
            ),
            if (c.goalMoney >= c.goalAmount) ...[
              const SizedBox(height: 12),
              Text(
                t('goalReached'),
                style: const TextStyle(
                  color: green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ] else
            Text(t('noGoalSub')),
          const SizedBox(height: 16),
          Text(t('goalProgressHelp'), textAlign: TextAlign.center),
          ...[
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => editGoal(c),
              child: Text(t(c.goalName.isEmpty ? 'addGoal' : 'editGoal')),
            ),
            if (parent)
              TextButton(
                onPressed: c.available > 0 ? () => move(c, 'saving') : null,
                child: Text(t('saveMoney')),
              ),
            if (!parent && c.cashOutRequest > 0) ...[
              const SizedBox(height: 8),
              Text(
                t('cashOutWaiting'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ] else if (!parent && c.goalMoney > 0) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: busy ? null : () => requestCashOut(c),
                icon: const Icon(Icons.payments_outlined),
                label: Text(t('cashOutAsk')),
              ),
            ],
          ],
        ],
      ),
    ),
  ];

  Future<void> requestCashOut(ChildData c) async {
    final amount = c.goalMoney;
    if (amount <= 0) return;
    final approved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.payments_outlined, color: green),
        title: Text(t('cashOutAsk')),
        content: Text('${cash(amount, c)}\n\n${t('cashOutAskHelp')}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t('cashOutAsk')),
          ),
        ],
      ),
    );
    if (approved != true || !mounted) return;
    await run(
      () => repo.requestCashOut(c.id, amount),
      success: 'cashOutRequested',
    );
  }

  String amountText(int amount, String currency) =>
      (amount / units(currency)).toStringAsFixed(digits(currency));
  Future<void> editChild([ChildData? old]) async {
    final id = old?.id ?? newId(), plan = newId();
    final currency = old?.currency ?? repo.currency;
    await editor(
      context,
      widget.strings,
      old == null ? 'addChild' : 'editChild',
      [
        InputField(
          'name',
          'nameLabel',
          initial: old?.name ?? '',
          maxLength: 40,
        ),
        InputField(
          'mode',
          'mode',
          initial: old?.mode ?? 'both',
          choices: const ['tasks', 'allowance', 'both'],
        ),
        InputField(
          'amount',
          'allowanceAmount',
          initial: amountText(old?.allowanceAmount ?? 0, currency),
          amount: true,
          maxLength: 16,
        ),
        InputField(
          'frequency',
          'frequency',
          initial: old?.allowanceFrequency ?? 'weekly',
          choices: const ['weekly', 'monthly'],
        ),
        InputField(
          'date',
          'firstDate',
          initial: old?.allowanceNext.isNotEmpty == true
              ? old!.allowanceNext
              : day(DateTime.now()),
          date: true,
        ),
      ],
      (v) async {
        final amount = parseMoney(v['amount']!, currency, zero: true);
        final due = DateTime.parse(v['date']!);
        require(day(due) == v['date']);
        require(v['name']!.isNotEmpty);
        void apply(ChildData c) {
          c.accrue(DateTime.now());
          final changed =
              c.allowanceAmount != amount ||
              c.allowanceFrequency != v['frequency'] ||
              c.mode != v['mode'] ||
              c.allowanceNext != v['date'];
          c.name = v['name']!;
          c.mode = v['mode']!;
          c.allowanceAmount = amount;
          c.allowanceFrequency = v['frequency']!;
          if (changed) {
            require(v['date']!.compareTo(day(DateTime.now())) >= 0, 'invalid');
            c.allowanceNext = v['date']!;
            c.allowancePlan = plan;
            c.allowanceAnchor = due.day;
          }
        }

        if (old == null) {
          final c = ChildData(id: id, name: v['name']!, currency: currency);
          apply(c);
          c.validate();
          await repo.create(c);
        } else {
          await repo.change(id, apply);
        }
        if (mounted) setState(() => selected = id);
      },
      help: 'allowanceHelp',
    );
  }

  Future<void> editTask(ChildData c, [Task? old]) async {
    final id = old?.id ?? newId();
    await editor(
      context,
      widget.strings,
      old == null ? 'addTask' : 'editTask',
      [
        InputField('title', 'taskTitle', initial: old?.title ?? ''),
        InputField(
          'instructions',
          'instructions',
          initial: old?.instructions ?? '',
          multiline: true,
          maxLength: 500,
        ),
        InputField(
          'amount',
          'rewardAmount',
          initial: amountText(old?.amount ?? 0, c.currency),
          amount: true,
          maxLength: 16,
        ),
        InputField(
          'frequency',
          'frequency',
          initial: old?.frequency ?? 'once',
          choices: const ['once', 'daily', 'weekly', 'monthly'],
        ),
        InputField(
          'date',
          'due',
          initial: old?.due ?? day(DateTime.now()),
          date: true,
        ),
        if (old != null)
          const InputField(
            'action',
            'confirm',
            initial: 'save',
            choices: ['save', 'cancelTask'],
          ),
      ],
      (v) => repo.change(c.id, (fresh) {
        if (old != null) {
          require(['pending', 'correction'].contains(fresh.tasks[id]?.status));
          if (v['action'] == 'cancelTask') {
            fresh.tasks[id]!.status = 'cancelled';
            return;
          }
        }
        final task = Task(
          id: id,
          title: v['title']!,
          instructions: v['instructions']!,
          amount: parseMoney(v['amount']!, c.currency, zero: true),
          frequency: v['frequency']!,
          due: v['date']!,
        );
        if (old != null) fresh.tasks.remove(id);
        fresh.addTask(task);
      }),
    );
  }

  Future<void> editGoal(ChildData c) async {
    await editor(
      context,
      widget.strings,
      'editGoal',
      [
        InputField('name', 'goalName', initial: c.goalName, maxLength: 120),
        InputField(
          'image',
          'goalImage',
          initial: goalImageFor(c),
          imageChoices: true,
        ),
        InputField(
          'amount',
          'goalAmount',
          initial: amountText(c.goalAmount, c.currency),
          amount: true,
          maxLength: 16,
        ),
      ],
      (v) async {
        final name = v['name']!.trim(), image = v['image']!;
        final amount = parseMoney(v['amount']!, c.currency);
        require(name.isNotEmpty && name.length <= 120 && amount <= 1000000000);
        if (repo is CloudRepository) {
          await (repo as CloudRepository).chooseGoal(c.id, name, image, amount);
        } else {
          await repo.change(c.id, (fresh) {
            fresh.goalName = name;
            fresh.goalImage = image;
            fresh.goalAmount = amount;
          });
        }
      },
    );
  }

  Future<void> move(ChildData c, String kind) async {
    final id = newId();
    await editor(
      context,
      widget.strings,
      kind,
      [
        const InputField('amount', 'amount', amount: true, maxLength: 16),
        const InputField('note', 'note', multiline: true, maxLength: 500),
      ],
      (v) => repo.change(
        c.id,
        (fresh) => fresh.move(
          id,
          kind,
          parseMoney(v['amount']!, c.currency),
          v['note']!,
          DateTime.now(),
        ),
      ),
      help: kind == 'payment'
          ? 'deliverHelp'
          : kind == 'saving'
          ? 'savingsHelp'
          : null,
    );
  }

  Future<void> deleteChild(ChildData child) async {
    if (!parent || busy) return;
    final approved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, color: danger, size: 36),
        title: Text(t('deleteChildTitle').replaceAll('{name}', child.name)),
        content: Text(t('deleteChildWarning')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t('cancel')),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: danger,
              foregroundColor: paper,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t('deletePermanently')),
          ),
        ],
      ),
    );
    if (approved != true || !mounted || !parent) return;
    await run(() async {
      await repo.deleteChild(child.id);
      if (mounted) setState(() => selected = null);
    }, success: 'childDeleted');
  }

  Future<bool> confirm(String label, String help) async =>
      await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(t(label)),
          content: Text(t(help)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t('cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t('confirm')),
            ),
          ],
        ),
      ) ??
      false;
  Future<void> parentAccess() async {
    final cloud = repo is CloudRepository ? repo as CloudRepository : null;
    String? member;
    var loaded = false;
    await run(() async {
      member = cloud == null ? null : await cloud.secondParent();
      loaded = true;
    }, success: null);
    if (!mounted || !loaded) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t(member == null ? 'inviteParent' : 'familyParents')),
        content: Text(
          t(
            cloud == null
                ? 'parentPreviewHelp'
                : member == null
                ? 'inviteSimpleHelp'
                : 'twoParentsConnected',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t('cancel')),
          ),
          if (cloud != null && (member != null || cloud.familyOwner))
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                if (member != null) {
                  if (await confirm('removeParent', 'removeParentHelp')) {
                    await run(() async {
                      await cloud.removeParent();
                      if (!cloud.familyOwner && mounted) {
                        await widget.onExit();
                      }
                    });
                  }
                } else {
                  await run(() async {
                    final code = await cloud.inviteParent();
                    if (!mounted) return;
                    await showDialog<void>(
                      context: context,
                      builder: (dialog) => AlertDialog(
                        title: Text(t('inviteParent')),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.family_restroom,
                                size: 48,
                                color: green,
                              ),
                              const SizedBox(height: 12),
                              Text(t('shareStep1')),
                              const SizedBox(height: 12),
                              Text(t('shareStep2')),
                              const SizedBox(height: 12),
                              Text(t('inviteExpires')),
                              const SizedBox(height: 16),
                              Builder(
                                builder: (shareContext) => FilledButton.icon(
                                  icon: const Icon(Icons.share_outlined),
                                  label: Text(t('shareInvitation')),
                                  onPressed: () async {
                                    final box =
                                        shareContext.findRenderObject()
                                            as RenderBox?;
                                    final origin = box == null
                                        ? null
                                        : box.localToGlobal(Offset.zero) &
                                              box.size;
                                    try {
                                      await SharePlus.instance.share(
                                        ShareParams(
                                          text:
                                              '${t('invitationMessage')}\n\n${ParentInvitation.link(code)}',
                                          sharePositionOrigin: origin,
                                        ),
                                      );
                                    } catch (_) {
                                      if (mounted) notice(t('shareFallback'));
                                    }
                                  },
                                ),
                              ),
                              ExpansionTile(
                                title: Text(t('manualInvitation')),
                                children: [SelectableText(code)],
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(
                                  text:
                                      '${t('invitationMessage')}\n\n${ParentInvitation.link(code)}',
                                ),
                              );
                              if (mounted) notice(t('copied'));
                            },
                            child: Text(t('copyInvitation')),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(dialog),
                            child: Text(t('confirm')),
                          ),
                        ],
                      ),
                    );
                  });
                }
              },
              child: Text(t(member != null ? 'removeParent' : 'inviteParent')),
            ),
        ],
      ),
    );
  }

  Widget settingsButton() => Tooltip(
    message: t('settings'),
    child: TextButton.icon(
      key: const Key('open-settings'),
      onPressed: busy ? null : settings,
      icon: const Icon(Icons.settings_outlined, size: 20),
      label: Text(t('settings')),
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
  );

  Future<void> linkChild(ChildData c) async {
    if (!parent || busy) return;
    if (repo.local) {
      final start = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          scrollable: true,
          title: Text(t('link')),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(t('linkPreviewHelp')),
              const SizedBox(height: 16),
              Text(t('linkStepParent')),
              const SizedBox(height: 12),
              Text(t('linkStepChild')),
              const SizedBox(height: 12),
              Text(t('childWifiHelp')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t('close')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t('accountStart')),
            ),
          ],
        ),
      );
      if (start == true && mounted) await (widget.onAccount ?? widget.onExit)();
      return;
    }
    await run(() async {
      final code = await repo.invite(c.id);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => ChildInvitationDialog(
          code: code,
          strings: widget.strings,
          childName: c.name,
        ),
      );
    }, success: null);
  }

  Future<void> settings() async {
    final c = current;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (ctx) {
          Widget action(
            IconData icon,
            String label,
            VoidCallback onTap, {
            String? subtitle,
          }) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon, color: green),
            title: Text(t(label)),
            subtitle: subtitle == null ? null : Text(subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: onTap,
          );
          return Scaffold(
            appBar: AppBar(title: Text(t('settings'))),
            body: pageBody([
              if (parent) ...[
                heading(
                  t('familyConnections'),
                  c == null ? t('linkAddChild') : c.name,
                ),
                panel(
                  Column(
                    children: [
                      action(
                        Icons.qr_code_rounded,
                        'link',
                        () {
                          Navigator.pop(ctx);
                          if (c == null) {
                            editChild();
                          } else {
                            linkChild(c);
                          }
                        },
                        subtitle: t(c == null ? 'linkAddChild' : 'linkSummary'),
                      ),
                      const Divider(),
                      action(
                        Icons.people_alt_outlined,
                        'twoParents',
                        () {
                          Navigator.pop(ctx);
                          parentAccess();
                        },
                        subtitle: t('twoParentsSubtitle'),
                      ),
                    ],
                  ),
                ),
              ] else if (c != null) ...[
                heading(t('yourDevice'), c.name),
                Text(t(repo.local ? 'previewHelp' : 'childDeviceHelp')),
                const SizedBox(height: 20),
              ],
              heading(t('preferences')),
              panel(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: widget.languageChoice,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: t('language')),
                      items: ['system', 'es', 'en']
                          .map(
                            (v) => DropdownMenuItem(
                              value: v,
                              child: Text(
                                v == 'system'
                                    ? t('system')
                                    : v == 'es'
                                    ? 'Español'
                                    : 'English',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) async {
                        if (v == null) return;
                        Navigator.pop(ctx);
                        await widget.onLanguage(v);
                      },
                    ),
                    if (parent) ...[
                      const SizedBox(height: 18),
                      Text(
                        '${t('currency')}: ${repo.currency}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(t('currencyHelp')),
                      const Divider(height: 28),
                      action(
                        Icons.workspace_premium_outlined,
                        'membership',
                        () {
                          Navigator.pop(ctx);
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  MembershipScreen(strings: widget.strings),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
              if (parent && c != null)
                panel(
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(t('manageProfile')),
                    subtitle: Text(c.name),
                    children: [
                      if (!repo.local)
                        action(Icons.link_off, 'revoke', () async {
                          Navigator.pop(ctx);
                          if (await confirm('revoke', 'revokeHelp')) {
                            await run(() => repo.revoke(c.id));
                          }
                        }),
                      action(Icons.archive_outlined, 'archive', () async {
                        Navigator.pop(ctx);
                        if (await confirm('archive', 'archiveHelp')) {
                          await run(() async {
                            if (!repo.local) await repo.revoke(c.id);
                            await repo.change(c.id, (fresh) {
                              fresh.accrue(DateTime.now());
                              fresh.archived = true;
                            });
                          });
                          if (mounted) setState(() => selected = null);
                        }
                      }),
                    ],
                  ),
                ),
              panel(
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.privacy_tip_outlined, color: green),
                  title: Text(t('privacyDetails')),
                  subtitle: Text(t('legalUpdated')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          LegalPrivacyScreen(strings: widget.strings),
                    ),
                  ),
                ),
              ),
              if (repo.local && parent) ...[
                Text(t('previewHelp')),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await (widget.onAccount ?? widget.onExit)();
                  },
                  icon: const Icon(Icons.login),
                  label: Text(t('accountStart')),
                ),
              ],
              TextButton.icon(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await widget.onExit();
                },
                icon: const Icon(Icons.logout),
                label: Text(t(repo.local ? 'exitPreview' : 'signout')),
              ),
              if (parent && repo is CloudRepository)
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    deleteAccount();
                  },
                  child: Text(
                    t('deleteAccount'),
                    style: const TextStyle(color: danger),
                  ),
                ),
            ]),
          );
        },
      ),
    );
  }

  Future<void> deleteAccount() async {
    if (!parent || repo is! CloudRepository) return;
    final deleted = await editor(
      context,
      widget.strings,
      'deleteAccount',
      [const InputField('password', 'password', secret: true, maxLength: 128)],
      (v) async {
        final user = FirebaseAuth.instance.currentUser!;
        await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: user.email!,
            password: v['password']!,
          ),
        );
        final cloud = repo as CloudRepository;
        if (cloud.familyOwner) {
          await cloud.deleteFamily();
        } else {
          await cloud.removeParent();
          await user.delete();
        }
      },
      help: (repo as CloudRepository).familyOwner
          ? 'deleteHelp'
          : 'deleteSecondParentHelp',
    );
    if (deleted && mounted) await widget.onExit();
  }
}
