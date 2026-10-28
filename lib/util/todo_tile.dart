import 'package:flutter/material.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    this.onDelete,
  });

  final String taskName;
  final bool taskCompleted;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 25, right: 25),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Checkbox(value: taskCompleted, onChanged: onChanged, activeColor: Colors.black),
            Expanded(
              child: Text(
                taskName,
                style: TextStyle(decoration: taskCompleted ? TextDecoration.lineThrough : null),
              ),
            ),
            IconButton(onPressed: onDelete, tooltip: 'Delete task', icon: const Icon(Icons.delete_outline)),
          ],
        ),
      ),
    );
  }
}
