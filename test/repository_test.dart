import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:chorejar/models/family.dart';
import 'package:chorejar/services/repository.dart';

void main() {
  test(
    'Deleted local child stays deleted after reopening; siblings remain',
    () async {
      final dir = await Directory.systemTemp.createTemp(
        'chorejar-delete-test-',
      );
      try {
        final file = File('${dir.path}/data.json');
        final repo = await LocalRepository.fromFile(file, 'USD');
        await repo.create(ChildData(id: 'a', name: 'Alex', currency: 'USD'));
        await repo.create(ChildData(id: 'b', name: 'Sam', currency: 'USD'));
        await repo.deleteChild('a');
        await repo.close();
        final reopened = await LocalRepository.fromFile(file, 'USD');
        expect((await reopened.watch().first).map((c) => c.id), ['b']);
        await reopened.close();
      } finally {
        await dir.delete(recursive: true);
      }
    },
  );
  test(
    'Local preview survives reopening and failed writes do not change history',
    () async {
      final dir = await Directory.systemTemp.createTemp('chorejar-test-');
      final file = File('${dir.path}/data.json');
      final repo = await LocalRepository.fromFile(file, 'USD');
      await repo.create(ChildData(id: 'a', name: 'Alex', currency: 'USD'));
      await repo.change('a', (c) {
        c.addTask(Task(id: 't', title: 'Task', amount: 500, due: '2026-10-07'));
        c.submit('t', DateTime(2026, 10, 7));
        c.review('t', true, '', DateTime(2026, 10, 7));
        c.move('pay', 'payment', 300, 'Cash', DateTime(2026, 10, 7));
      });
      final before = await file.readAsString();
      await expectLater(
        repo.change(
          'a',
          (c) => c.move('oops', 'saving', 301, '', DateTime.now()),
        ),
        throwsA(isA<DomainError>()),
      );
      expect(await file.readAsString(), before);
      await repo.close();
      final reopened = await LocalRepository.fromFile(file, 'EUR');
      expect(reopened.currency, 'USD');
      final children = await reopened.watch().first;
      expect(children.single.balances, [200, 300, 0, 300, 0]);
      await expectLater(
        reopened.change(
          'a',
          (c) => c.move('pay', 'payment', 100, '', DateTime.now()),
        ),
        throwsA(isA<DomainError>()),
      );
      await reopened.close();
      await dir.delete(recursive: true);
    },
  );
  test(
    'Local concurrent writes serialize instead of losing a payment',
    () async {
      final dir = await Directory.systemTemp.createTemp('chorejar-test-');
      final repo = await LocalRepository.fromFile(
        File('${dir.path}/data.json'),
        'USD',
      );
      final child = ChildData(id: 'a', name: 'Alex', currency: 'USD')
        ..allowancePlan = 'p'
        ..allowanceAmount = 1000
        ..allowanceNext = '2026-10-07';
      child.accrue(DateTime(2026, 10, 7));
      await repo.create(child);
      await Future.wait([
        repo.change(
          'a',
          (c) => c.move('p1', 'payment', 300, '', DateTime.now()),
        ),
        repo.change(
          'a',
          (c) => c.move('p2', 'payment', 200, '', DateTime.now()),
        ),
      ]);
      final c = (await repo.watch().first).single;
      expect(c.pending, 500);
      expect(c.received, 500);
      await repo.close();
      await dir.delete(recursive: true);
    },
  );
}
