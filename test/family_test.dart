import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:chorejar/models/family.dart';
import 'package:chorejar/services/money.dart';

void main() {
  test('Goal image persists and older profiles remain compatible', () {
    final child = ChildData(
      id: 'a',
      name: 'Alex',
      currency: 'USD',
      goalImage: 'iphone',
    );
    expect(child.copy().goalImage, 'iphone');
    final legacy = child.toJson()..remove('goalImage');
    expect(ChildData.fromJson(legacy).goalImage, 'auto');
    child.goalImage = '../unknown';
    expect(child.validate, throwsA(isA<DomainError>()));
  });
  test('Monthly allowance preserves the chosen day through short months', () {
    final c = ChildData(
      id: 'a',
      name: 'Alex',
      currency: 'USD',
      allowanceAmount: 100,
      allowanceFrequency: 'monthly',
      allowanceNext: '2026-01-31',
      allowanceAnchor: 31,
      allowancePlan: 'p',
    );
    c.accrue(DateTime(2026, 3, 31));
    expect(c.pending, 300);
    expect(c.allowanceNext, '2026-04-30');
    expect(c.entries.values.map((e) => e.note), [
      '2026-01-31',
      '2026-02-28',
      '2026-03-31',
    ]);
  });
  ChildData fresh() => ChildData(id: 'c', name: 'Alex', currency: 'USD');
  final now = DateTime(2026, 10, 7);
  void approve(ChildData c, String id, int amount) {
    c.addTask(Task(id: id, title: 'Task', due: day(now), amount: amount));
    c.submit(id, now);
    c.review(id, true, '', now);
  }

  test('Review, corrections, recurrence and immutable reward snapshot', () {
    final c = fresh();
    c.addTask(
      Task(
        id: 't',
        title: 'Read',
        due: day(now),
        amount: 200,
        frequency: 'weekly',
      ),
    );
    c.submit('t', now);
    expect(c.pending, 0);
    c.review('t', false, 'Try again', now);
    expect(c.tasks['t']!.status, 'correction');
    c.submit('t', now);
    c.review('t', true, '', now);
    expect(c.pending, 200);
    expect(c.tasks.length, 2);
    final next = c.tasks.values.singleWhere((t) => t.status == 'pending');
    expect(next.due, '2026-10-14');
    expect(() => c.review('t', true, '', now), throwsA(isA<DomainError>()));
    expect(() => c.submit(next.id, now), throwsA(isA<DomainError>()));
  });
  test(
    'Partial payments, saving, spending, withdrawals and reversals reconcile',
    () {
      final c = fresh();
      approve(c, 'a', 500);
      approve(c, 'b', 300);
      c.move('pay', 'payment', 600, 'Cash', now);
      expect(c.entries['pay']!.allocations, {'task-a': 500, 'task-b': 100});
      c.move('save', 'saving', 200, 'Goal', now);
      c.move('spend', 'spending', 50, 'Book', now);
      expect(c.balances, [200, 350, 200, 600, 50]);
      expect(
        () => c.reverse('task-a', 'Error', now),
        throwsA(isA<DomainError>()),
      );
      expect(() => c.reverse('pay', 'Error', now), throwsA(isA<DomainError>()));
      c.move('withdraw', 'withdrawal', 200, '', now);
      c.reverse('spend', 'Returned', now);
      c.reverse('pay', 'Wrong entry', now);
      expect(c.balances, [800, 0, 0, 0, 0]);
      c.reverse('task-a', 'Wrong reward', now);
      expect(c.pending, 300);
      expect(
        () => c.reverse('task-a', 'Again', now),
        throwsA(isA<DomainError>()),
      );
      expect(c.entries['task-a']!.amount, 500);
    },
  );
  test(
    'Cash-out requests preserve control until a parent records the cash',
    () {
      final c = fresh();
      approve(c, 'a', 500);
      c.move('pay', 'payment', 500, '', now);
      c.move('save', 'saving', 200, '', now);
      expect(c.goalMoney, 500);
      c.requestCashOut(500);
      expect(c.cashOutRequest, 500);
      expect(c.goalMoney, 500);
      c.cashOut('cash', now);
      expect(c.cashOutRequest, 0);
      expect(c.goalMoney, 0);
      expect(c.spent, 500);
      expect(c.balances, [0, 0, 0, 500, 500]);
    },
  );
  test('Duplicate operations remain rejected after serialization', () {
    final c = fresh();
    approve(c, 'a', 500);
    c.move('pay', 'payment', 100, '', now);
    final restored = ChildData.fromJson(
      object(jsonDecode(jsonEncode(c.toJson()))),
    );
    expect(
      () => restored.move('pay', 'payment', 100, '', now),
      throwsA(isA<DomainError>()),
    );
    expect(restored.balances, [400, 100, 0, 100, 0]);
    expect(
      () => restored.move('s', 'saving', 101, '', now),
      throwsA(isA<DomainError>()),
    );
    expect(
      () => restored.move('n', 'payment', -1, '', now),
      throwsA(isA<DomainError>()),
    );
    expect(restored.entries.length, 2);
  });
  test(
    'Allowance catches up, never doubles and respects task-only/archive',
    () {
      final c = fresh()
        ..allowanceAmount = 200
        ..allowanceNext = '2026-09-23'
        ..allowancePlan = 'p';
      c.accrue(now);
      expect(c.pending, 600);
      expect(c.allowanceNext, '2026-10-14');
      c.accrue(now);
      expect(c.pending, 600);
      final restored = c.copy();
      restored.accrue(DateTime(2026, 10, 14));
      expect(restored.pending, 800);
      restored.archived = true;
      restored.accrue(DateTime(2027));
      expect(restored.pending, 800);
      restored.archived = false;
      restored.mode = 'tasks';
      restored.accrue(DateTime(2027));
      expect(restored.pending, 800);
    },
  );
  test('Currency parsing uses exact integer minor units', () {
    expect(parseMoney('10,05', 'USD'), 1005);
    expect(parseMoney('10', 'JPY'), 10);
    expect(parseMoney('1.234', 'KWD'), 1234);
    for (final raw in ['-1', 'NaN', '1e3', '1.001', '1,000.00', '']) {
      expect(() => parseMoney(raw, 'USD'), throwsA(isA<DomainError>()));
    }
    expect(() => parseMoney('1.1', 'JPY'), throwsA(isA<DomainError>()));
    expect(parseMoney('0', 'USD', zero: true), 0);
  });
  test(
    'Independent children and cancelled/review tasks cannot be resubmitted',
    () {
      final a = fresh(), b = ChildData(id: 'b', name: 'Sam', currency: 'USD');
      approve(a, 'task', 300);
      expect(b.pending, 0);
      expect(() => a.submit('task', now), throwsA(isA<DomainError>()));
      expect(() => a.submit('missing', now), throwsA(isA<DomainError>()));
      expect(nextDate(DateTime(2026, 1, 31), 'monthly'), DateTime(2026, 2, 28));
    },
  );
}
