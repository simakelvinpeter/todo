import 'package:flutter/material.dart';
import '../data/database.dart';
import '../util/todo_tile.dart';
import '../util/dialog_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final _database = ToDoDataBase();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _database.loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> saveTasks(List<List<dynamic>> updated) async {
    if (_saving) return false;
    final previous = _database.toDoList;
    _database.toDoList = updated;
    setState(() => _saving = true);
    try {
      await _database.updateDataBase();
      return true;
    } catch (_) {
      _database.toDoList = previous;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save tasks. Please try again.')),
        );
      }
      return false;
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> checkBoxChanged(bool? value, int index) async {
    final updated = _database.toDoList.map((task) => List<dynamic>.from(task)).toList();
    updated[index][1] = value ?? false;
    await saveTasks(updated);
  }

  Future<void> saveNewTask() async {
    final name = _controller.text.trim();
    if (name.isEmpty || _saving) return;
    final saved = await saveTasks([
      ..._database.toDoList,
      [name, false],
    ]);
    if (saved && mounted) {
      _controller.clear();
      Navigator.of(context).pop();
    }
  }

  Future<void> deleteTask(int index) async {
    final updated = List<List<dynamic>>.from(_database.toDoList)..removeAt(index);
    await saveTasks(updated);
  }

  void createNewTask() {
    _controller.clear();
    showDialog<void>(
      context: context,
      builder: (context) => DialogBox(
        controller: _controller,
        onSave: saveNewTask,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(title: const Text('TO DO'), elevation: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: _saving ? null : createNewTask,
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
      body: _database.toDoList.isEmpty
          ? const Center(child: Text('No tasks yet. Tap + to add one.'))
          : ListView.builder(
              itemCount: _database.toDoList.length,
              itemBuilder: (context, index) => TodoTile(
                taskName: _database.toDoList[index][0] as String,
                taskCompleted: _database.toDoList[index][1] as bool,
                onChanged: _saving ? null : (value) => checkBoxChanged(value, index),
                onDelete: _saving ? null : () => deleteTask(index),
              ),
            ),
    );
  }
}
