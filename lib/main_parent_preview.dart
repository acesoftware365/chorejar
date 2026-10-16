// Isolated parent preview. Does not initialize Firebase or access real families.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart' as application;
import 'main_child_preview.dart' show ChildPreviewRepository;
import 'models/family.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('language', 'es');
  runApp(
    application.ChoreJar(
      prefs: prefs,
      initialRepository: ParentPreviewRepository(prefs),
    ),
  );
}

class ParentPreviewRepository extends ChildPreviewRepository {
  final _children = <String, ChildData>{};
  final _events = StreamController<List<ChildData>>.broadcast();
  ParentPreviewRepository(super.prefs) {
    _children[child.id] = child.copy();
  }
  @override
  bool get parent => true;
  List<ChildData> get _values => _children.values.map((c) => c.copy()).toList();
  @override
  Stream<List<ChildData>> watch() async* {
    yield _values;
    yield* _events.stream;
  }

  @override
  Future<void> change(String id, void Function(ChildData) edit) async {
    require(_children.containsKey(id));
    final next = _children[id]!.copy();
    edit(next);
    next.validate();
    _children[id] = next;
    _events.add(_values);
  }

  @override
  Future<void> create(ChildData value) async {
    require(!_children.containsKey(value.id));
    value.validate();
    _children[value.id] = value.copy();
    _events.add(_values);
  }

  @override
  Future<void> submit(String childId, String taskId) =>
      change(childId, (c) => c.submit(taskId, DateTime.now()));
  @override
  Future<void> deleteChild(String childId) async {
    require(_children.containsKey(childId));
    _children.remove(childId);
    _events.add(_values);
  }

  @override
  Future<void> close() async {
    await _events.close();
    await super.close();
  }
}
