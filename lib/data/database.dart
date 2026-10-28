import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  ToDoDataBase({Box? box}) : _box = box ?? Hive.box('mybox');

  final Box _box;
  List<List<dynamic>> toDoList = [];

  void loadData() {
    final stored = _box.get('TODOLIST');
    if (stored == null) {
      toDoList = [
        ['Make Tutorial', false],
        ['Do Exercise', false],
      ];
      return;
    }
    // Read lists written by older versions without keeping invalid entries.
    toDoList = stored is List
        ? stored.whereType<List>().where((task) {
            return task.length == 2 && task[0] is String && task[1] is bool;
          }).map((task) => <dynamic>[task[0], task[1]]).toList()
        : [];
  }

  Future<void> updateDataBase() async {
    await _box.put('TODOLIST', toDoList);
  }
}
