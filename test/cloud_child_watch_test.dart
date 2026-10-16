// Firebase SDK test doubles only; production uses the sealed SDK classes.
// ignore_for_file: subtype_of_sealed_class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chorejar/models/family.dart';
import 'package:chorejar/services/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_async/fake_async.dart';

class ProfileSnapshot extends Fake
    implements DocumentSnapshot<Map<String, dynamic>> {
  @override
  bool get exists => true;
  @override
  Map<String, dynamic> data() =>
      ChildData(id: 'kid', name: 'Alex', currency: 'USD').toJson();
}

class ProfileReference extends Fake
    implements DocumentReference<Map<String, dynamic>> {
  @override
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) =>
      ProfileCollection();
  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots({
    bool includeMetadataChanges = false,
    ListenSource source = ListenSource.defaultSource,
  }) => Stream.error(
    FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
  );
}

class ProfileCollection extends Fake
    implements CollectionReference<Map<String, dynamic>> {
  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) =>
      ProfileReference();
}

class ProfileTransaction extends Fake implements Transaction {
  @override
  Future<DocumentSnapshot<T>> get<T extends Object?>(
    DocumentReference<T> documentReference,
  ) async => ProfileSnapshot() as DocumentSnapshot<T>;
}

class ProfileFirestore extends Fake implements FirebaseFirestore {
  bool denied = false;
  int reads = 0;
  @override
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) =>
      ProfileCollection();
  @override
  Future<T> runTransaction<T>(
    TransactionHandler<T> transactionHandler, {
    Duration timeout = const Duration(seconds: 30),
    int maxAttempts = 5,
  }) async {
    reads++;
    if (denied) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
      );
    }
    return transactionHandler(ProfileTransaction());
  }
}

void main() {
  test('Child stream recovers authorized reads and stops after revocation', () {
    fakeAsync((clock) {
      final db = ProfileFirestore();
      final repo = CloudRepository(
        owner: 'owner',
        currency: 'USD',
        linkedChild: 'kid',
        firestore: db,
      );
      final profiles = <List<ChildData>>[], errors = <Object>[];
      final subscription = repo.watch().listen(
        profiles.add,
        onError: errors.add,
      );
      clock.flushMicrotasks();
      expect(profiles.single.single.name, 'Alex');
      expect(db.reads, 1);
      db.denied = true;
      clock.elapse(const Duration(seconds: 10));
      clock.flushMicrotasks();
      expect(errors.single, isA<FirebaseException>());
      expect(profiles.length, 1);
      final readsAtRevocation = db.reads;
      clock.elapse(const Duration(seconds: 30));
      clock.flushMicrotasks();
      expect(db.reads, readsAtRevocation);
      subscription.cancel();
      clock.flushMicrotasks();
      expect(clock.pendingTimers, isEmpty);
    });
  });
  test('Closing the child screen cancels the fallback timer', () {
    fakeAsync((clock) {
      final db = ProfileFirestore();
      final repo = CloudRepository(
        owner: 'owner',
        currency: 'USD',
        linkedChild: 'kid',
        firestore: db,
      );
      final subscription = repo.watch().listen((_) {});
      clock.flushMicrotasks();
      subscription.cancel();
      clock.flushMicrotasks();
      clock.elapse(const Duration(seconds: 30));
      expect(db.reads, 1);
      expect(clock.pendingTimers, isEmpty);
    });
  });
}
