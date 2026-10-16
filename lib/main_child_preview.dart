// Isolated child preview. No Firebase initialization or real family data.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart' as application;
import 'models/family.dart';
import 'services/repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('language', 'es');
  runApp(
    application.ChoreJar(
      prefs: prefs,
      initialRepository: ChildPreviewRepository(prefs),
    ),
  );
}

class ChildPreviewRepository implements FamilyRepository {
  final SharedPreferences prefs;
  final _updates = StreamController<List<ChildData>>.broadcast();
  late ChildData child;
  ChildPreviewRepository(this.prefs) {
    final now = DateTime.now();
    child = ChildData(
      id: 'preview',
      name: 'Alex',
      currency: 'USD',
      goalName: prefs.getString('previewGoalName') ?? 'Mi iPhone',
      goalImage: prefs.getString('previewGoalImage') ?? 'iphone',
      goalAmount: prefs.getInt('previewGoalAmount') ?? 10000,
      mode: 'tasks',
    );
    child.addTask(
      Task(id: 'earned', title: 'Ayudar en casa', amount: 10050, due: day(now)),
    );
    child.submit('earned', now);
    child.review('earned', true, '', now);
    child.move('pay', 'payment', 9000, '', now);
    child.move('save', 'saving', 5700, '', now);
    child.addTask(
      Task(id: 'latest', title: 'Leer', amount: 200, due: day(now)),
    );
    child.submit('latest', now.add(const Duration(seconds: 1)));
    child.review('latest', true, '', now.add(const Duration(seconds: 1)));
    child.addTask(
      Task(
        id: 'room',
        title: 'Ordenar mi habitación',
        instructions: 'Guarda tus juguetes y deja la cama lista.',
        amount: 200,
        due: day(now),
      ),
    );
    child.addTask(
      Task(
        id: 'plants',
        title: 'Regar las plantas',
        instructions: 'Un poquito de agua para cada planta.',
        amount: 100,
        due: day(now),
      ),
    );
  }
  @override
  bool get local => true;
  @override
  bool get parent => false;
  @override
  String get currency => 'USD';
  @override
  String get country => 'US';
  @override
  Stream<List<ChildData>> watch() async* {
    yield [child.copy()];
    yield* _updates.stream;
  }

  @override
  Future<void> submit(String childId, String taskId) async {
    require(childId == child.id);
    child.submit(taskId, DateTime.now());
    _updates.add([child.copy()]);
  }

  @override
  Future<void> requestCashOut(String childId, int amount) async {
    require(childId == child.id);
    child.requestCashOut(amount);
    _updates.add([child.copy()]);
  }

  @override
  Future<void> change(String id, void Function(ChildData) edit) async {
    require(id == child.id, 'permission');
    final next = child.copy();
    edit(next);
    next.validate();
    // Preview permits goal customization only; balances and chores stay protected.
    final restored = next.copy()
      ..goalName = child.goalName
      ..goalImage = child.goalImage
      ..goalAmount = child.goalAmount;
    require(
      restored.toJson().toString() == child.toJson().toString(),
      'permission',
    );
    await prefs.setString('previewGoalName', next.goalName);
    await prefs.setString('previewGoalImage', next.goalImage);
    await prefs.setInt('previewGoalAmount', next.goalAmount);
    child = next;
    _updates.add([child.copy()]);
  }

  @override
  Future<void> create(ChildData value) async => throw DomainError('permission');
  @override
  Future<void> deleteChild(String childId) async =>
      throw DomainError('permission');
  @override
  Future<String> invite(String id) async => throw DomainError('cloudOnly');
  @override
  Future<void> revoke(String id) async => throw DomainError('permission');
  @override
  Future<void> close() => _updates.close();
}
