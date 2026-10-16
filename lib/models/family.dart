import 'dart:convert';
import 'dart:math';
import '../assets/library.dart';

String newId() => List.generate(
  16,
  (_) => Random.secure().nextInt(256).toRadixString(16).padLeft(2, '0'),
).join();
String day(DateTime d) => [
  d.year.toString().padLeft(4, '0'),
  d.month.toString().padLeft(2, '0'),
  d.day.toString().padLeft(2, '0'),
].join('-');
DateTime nextDate(DateTime d, String cadence, {int? dayOfMonth}) {
  if (cadence == 'daily') return DateTime(d.year, d.month, d.day + 1);
  if (cadence == 'weekly') return DateTime(d.year, d.month, d.day + 7);
  final end = DateTime(d.year, d.month + 2, 0);
  return DateTime(end.year, end.month, min(dayOfMonth ?? d.day, end.day));
}

class DomainError implements Exception {
  final String key;
  DomainError(this.key);
  @override
  String toString() => key;
}

void require(bool value, [String key = 'invalid']) {
  if (!value) throw DomainError(key);
}

Map<String, dynamic> object(dynamic value) =>
    Map<String, dynamic>.from(value as Map);

class Task {
  String id, title, instructions, frequency, due, status, feedback;
  int amount;
  Task({
    required this.id,
    required this.title,
    this.instructions = '',
    this.frequency = 'once',
    required this.due,
    this.status = 'pending',
    this.feedback = '',
    required this.amount,
  });
  factory Task.fromJson(Map<String, dynamic> j) => Task(
    id: j['id'],
    title: j['title'],
    instructions: j['instructions'],
    frequency: j['frequency'],
    due: j['due'],
    status: j['status'],
    feedback: j['feedback'],
    amount: j['amount'],
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'instructions': instructions,
    'frequency': frequency,
    'due': due,
    'status': status,
    'feedback': feedback,
    'amount': amount,
  };
}

class Movement {
  final String id, kind, date, note, reference;
  final int amount;
  final List<int> delta;
  final Map<String, int> allocations;
  Movement({
    required this.id,
    required this.kind,
    required this.date,
    required this.amount,
    required this.delta,
    this.note = '',
    this.reference = '',
    this.allocations = const {},
  });
  factory Movement.fromJson(Map<String, dynamic> j) => Movement(
    id: j['id'],
    kind: j['kind'],
    date: j['date'],
    amount: j['amount'],
    delta: List<int>.from(j['delta']),
    note: j['note'],
    reference: j['reference'],
    allocations: Map<String, int>.from(j['allocations']),
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind,
    'date': date,
    'amount': amount,
    'delta': delta,
    'note': note,
    'reference': reference,
    'allocations': allocations,
  };
}

class ChildData {
  final String id, currency;
  String name,
      avatar,
      mode,
      goalName,
      goalImage,
      allowanceFrequency,
      allowanceNext,
      allowancePlan;
  int goalAmount,
      allowanceAmount,
      accessVersion,
      allowanceAnchor,
      cashOutRequest;
  bool archived;
  final Map<String, Task> tasks;
  final Map<String, Movement> entries;
  ChildData({
    required this.id,
    required this.name,
    required this.currency,
    this.avatar = 'star',
    this.mode = 'both',
    this.goalName = '',
    this.goalImage = 'auto',
    this.goalAmount = 0,
    this.allowanceAmount = 0,
    this.allowanceFrequency = 'weekly',
    this.allowanceNext = '',
    this.allowancePlan = '',
    this.archived = false,
    this.accessVersion = 0,
    this.allowanceAnchor = 1,
    this.cashOutRequest = 0,
    Map<String, Task>? tasks,
    Map<String, Movement>? entries,
  }) : tasks = tasks ?? {},
       entries = entries ?? {};
  factory ChildData.fromJson(Map<String, dynamic> j) => ChildData(
    id: j['id'],
    name: j['name'],
    currency: j['currency'],
    accessVersion: j['accessVersion'] ?? 0,
    allowanceAnchor: j['allowanceAnchor'] ?? 1,
    cashOutRequest: j['cashOutRequest'] ?? 0,
    avatar: j['avatar'],
    mode: j['mode'],
    goalName: j['goalName'],
    goalImage: j['goalImage'] ?? 'auto',
    goalAmount: j['goalAmount'],
    allowanceAmount: j['allowanceAmount'],
    allowanceFrequency: j['allowanceFrequency'],
    allowanceNext: j['allowanceNext'],
    allowancePlan: j['allowancePlan'],
    archived: j['archived'],
    tasks: object(
      j['tasks'],
    ).map((k, v) => MapEntry(k, Task.fromJson(object(v)))),
    entries: object(
      j['entries'],
    ).map((k, v) => MapEntry(k, Movement.fromJson(object(v)))),
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'currency': currency,
    'accessVersion': accessVersion,
    'allowanceAnchor': allowanceAnchor,
    'cashOutRequest': cashOutRequest,
    'avatar': avatar,
    'mode': mode,
    'goalName': goalName,
    'goalImage': goalImage,
    'goalAmount': goalAmount,
    'allowanceAmount': allowanceAmount,
    'allowanceFrequency': allowanceFrequency,
    'allowanceNext': allowanceNext,
    'allowancePlan': allowancePlan,
    'archived': archived,
    'tasks': tasks.map((k, v) => MapEntry(k, v.toJson())),
    'entries': entries.map((k, v) => MapEntry(k, v.toJson())),
  };
  ChildData copy() =>
      ChildData.fromJson(object(jsonDecode(jsonEncode(toJson()))));
  List<int> get balances {
    final b = List<int>.filled(5, 0);
    for (final e in entries.values) {
      for (var i = 0; i < 5; i++) {
        b[i] += e.delta[i];
      }
    }
    return b;
  }

  int get pending => balances[0];
  int get available => balances[1];
  int get savings => balances[2];
  int get received => balances[3];
  int get spent => balances[4];
  int get reviewing => tasks.values
      .where((t) => t.status == 'review')
      .fold(0, (s, t) => s + t.amount);
  bool reversed(String id) =>
      entries.values.any((e) => e.kind == 'reversal' && e.reference == id);
  void validate() {
    require(goalImage == 'auto' || goalImageIds.contains(goalImage));
    require(name.trim().isNotEmpty && name.length <= 40);
    require(['tasks', 'allowance', 'both'].contains(mode));
    require(['weekly', 'monthly'].contains(allowanceFrequency));
    require(goalAmount >= 0 && allowanceAmount >= 0);
    require(cashOutRequest >= 0 && cashOutRequest <= 100000000000);
    final b = balances;
    require(b.every((v) => v >= 0), 'insufficient');
    require(b[3] == b[1] + b[2] + b[4]);
    require(utf8.encode(jsonEncode(toJson())).length < 750000, 'historyFull');
  }

  void addTask(Task t) {
    require(!archived && !tasks.containsKey(t.id));
    require(
      t.title.trim().isNotEmpty &&
          t.title.length <= 80 &&
          t.instructions.length <= 500,
    );
    require(t.amount >= 0 && t.amount <= 100000000000);
    require(['once', 'daily', 'weekly', 'monthly'].contains(t.frequency));
    DateTime.parse(t.due);
    tasks[t.id] = t;
  }

  void submit(String id, DateTime now) {
    final t = tasks[id];
    require(
      !archived && t != null && ['pending', 'correction'].contains(t.status),
    );
    require(t!.due.compareTo(day(now)) <= 0, 'notDue');
    t.status = 'review';
  }

  void review(String id, bool approve, String feedback, DateTime now) {
    final t = tasks[id];
    require(t != null && t.status == 'review');
    if (!approve) {
      require(feedback.trim().isNotEmpty && feedback.length <= 500);
      t!.status = 'correction';
      t.feedback = feedback.trim();
      return;
    }
    if (t!.amount > 0) {
      _append(
        Movement(
          id: 'task-$id',
          kind: 'reward',
          date: now.toUtc().toIso8601String(),
          amount: t.amount,
          delta: [t.amount, 0, 0, 0, 0],
          reference: id,
          note: t.title,
        ),
      );
    }
    t.status = 'approved';
    t.feedback = '';
    if (t.frequency != 'once') {
      final next = newId();
      tasks[next] = Task(
        id: next,
        title: t.title,
        instructions: t.instructions,
        frequency: t.frequency,
        due: day(nextDate(now, t.frequency)),
        amount: t.amount,
      );
    }
  }

  Map<String, int> get unpaid {
    final remaining = <String, int>{};
    for (final e in entries.values) {
      if (['reward', 'allowanceEntry'].contains(e.kind)) {
        remaining[e.id] = e.amount;
      }
    }
    for (final e in entries.values) {
      if (e.kind == 'payment' && !reversed(e.id)) {
        for (final a in e.allocations.entries) {
          remaining[a.key] = (remaining[a.key] ?? 0) - a.value;
        }
      }
    }
    for (final id in remaining.keys.toList()) {
      if (reversed(id)) remaining[id] = 0;
    }
    return remaining;
  }

  void move(String id, String kind, int amount, String note, DateTime now) {
    require(amount > 0 && amount <= 100000000000);
    final d = <int>[0, 0, 0, 0, 0];
    final allocations = <String, int>{};
    switch (kind) {
      case 'payment':
        require(amount <= pending, 'insufficient');
        var left = amount;
        for (final a in unpaid.entries) {
          final take = min(left, a.value);
          if (take > 0) {
            allocations[a.key] = take;
            left -= take;
          }
          if (left == 0) break;
        }
        require(left == 0);
        d[0] = -amount;
        d[1] = amount;
        d[3] = amount;
      case 'saving':
        require(amount <= available, 'insufficient');
        d[1] = -amount;
        d[2] = amount;
      case 'withdrawal':
        require(amount <= savings, 'insufficient');
        d[1] = amount;
        d[2] = -amount;
      case 'spending':
        require(amount <= available, 'insufficient');
        d[1] = -amount;
        d[4] = amount;
      case 'cashout':
        require(amount <= goalMoney, 'insufficient');
        final fromSavings = amount > available ? amount - available : 0;
        d[1] = -(amount - fromSavings);
        d[2] = -fromSavings;
        d[4] = amount;
      default:
        throw DomainError('invalid');
    }
    _append(
      Movement(
        id: id,
        kind: kind,
        date: now.toUtc().toIso8601String(),
        amount: amount,
        delta: d,
        note: note,
        allocations: allocations,
      ),
    );
  }

  int get goalMoney => available + savings;

  void requestCashOut(int amount) {
    require(amount > 0 && amount <= goalMoney, 'insufficient');
    cashOutRequest = amount;
  }

  void cashOut(String id, DateTime now) {
    final amount = cashOutRequest;
    require(amount > 0 && amount <= goalMoney, 'insufficient');
    move(id, 'cashout', amount, '', now);
    cashOutRequest = 0;
  }

  void reverse(String id, String reason, DateTime now) {
    final e = entries[id];
    require(e != null && e.kind != 'reversal' && !reversed(id), 'duplicate');
    require(reason.trim().isNotEmpty && reason.length <= 500);
    if (['reward', 'allowanceEntry'].contains(e!.kind)) {
      require(unpaid[id] == e.amount, 'reversePaymentFirst');
    }
    final delta = e.delta.map((v) => -v).toList();
    final b = balances;
    for (var i = 0; i < 5; i++) {
      require(b[i] + delta[i] >= 0, 'insufficient');
    }
    _append(
      Movement(
        id: 'reverse-$id',
        kind: 'reversal',
        date: now.toUtc().toIso8601String(),
        amount: e.amount,
        delta: delta,
        reference: id,
        note: reason.trim(),
      ),
    );
  }

  void accrue(DateTime now) {
    if (archived ||
        mode == 'tasks' ||
        allowanceAmount <= 0 ||
        allowanceNext.isEmpty) {
      return;
    }
    var due = DateTime.parse(allowanceNext);
    var count = 0;
    while (day(due).compareTo(day(now)) <= 0 && count < 120) {
      final key = 'allowance-$allowancePlan-${day(due)}';
      if (!entries.containsKey(key)) {
        _append(
          Movement(
            id: key,
            kind: 'allowanceEntry',
            date: now.toUtc().toIso8601String(),
            amount: allowanceAmount,
            delta: [allowanceAmount, 0, 0, 0, 0],
            note: day(due),
          ),
        );
      }
      due = nextDate(due, allowanceFrequency, dayOfMonth: allowanceAnchor);
      count++;
    }
    allowanceNext = day(due);
  }

  void _append(Movement e) {
    require(!entries.containsKey(e.id), 'duplicate');
    entries[e.id] = e;
    try {
      validate();
    } catch (_) {
      entries.remove(e.id);
      rethrow;
    }
  }
}
