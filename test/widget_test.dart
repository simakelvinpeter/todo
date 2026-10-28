import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/data/database.dart';

void main() {
  late Directory directory;
  late Box box;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('todo-test-');
    Hive.init(directory.path);
    box = await Hive.openBox('mybox');
  });

  tearDown(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test('tasks and completion survive closing and reopening storage', () async {
    final database = ToDoDataBase(box: box)..loadData();
    database.toDoList = [['Read a book', true]];
    await database.updateDataBase();
    await box.close();
    box = await Hive.openBox('mybox');
    final reopened = ToDoDataBase(box: box)..loadData();
    expect(reopened.toDoList, [['Read a book', true]]);
    reopened.toDoList.clear();
    await reopened.updateDataBase();
    expect((ToDoDataBase(box: box)..loadData()).toDoList, isEmpty);
  });

  testWidgets('add, reject blank input, complete and delete a saved task', (tester) async {
    await tester.runAsync(() => box.put('TODOLIST', <List<dynamic>>[]));
    await tester.pumpWidget(const MyApp());
    expect(find.text('No tasks yet. Tap + to add one.'), findsOneWidget);
    await tester.tap(find.byTooltip('Add task'));
    await tester.pumpAndSettle();
    final saveButton = find.widgetWithText(MaterialButton, 'Save');
    expect(tester.widget<MaterialButton>(saveButton).onPressed, isNull);
    await tester.enterText(find.byType(TextField), '  Read a book  ');
    await tester.pump();
    await tester.tap(saveButton);
    await tester.runAsync(() => box.flush());
    await tester.pumpAndSettle();
    expect(find.text('Read a book'), findsOneWidget);
    expect(box.get('TODOLIST'), [['Read a book', false]]);
    await tester.tap(find.byType(Checkbox));
    await tester.runAsync(() => box.flush());
    await tester.pumpAndSettle();
    expect(box.get('TODOLIST'), [['Read a book', true]]);
    await tester.tap(find.byTooltip('Delete task'));
    await tester.runAsync(() => box.flush());
    await tester.pumpAndSettle();
    expect(box.get('TODOLIST'), isEmpty);
    expect(find.text('No tasks yet. Tap + to add one.'), findsOneWidget);
  });
}
