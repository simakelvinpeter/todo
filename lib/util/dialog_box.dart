import 'package:flutter/material.dart';
import 'my_button.dart';

class DialogBox extends StatelessWidget {

  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[300],

      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextField(
              controller: controller,
              autofocus: true,
              maxLength: 200,
              onSubmitted: (_) => onSave(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new task",
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, child) => MyButton(
                    text: "Save",
                    onPressed: value.text.trim().isEmpty ? null : onSave,
                  ),
                ),

                const SizedBox(width: 8),

                MyButton(
                  text: "Cancel",
                  onPressed: onCancel,
                ),

              ],
            )

          ],
        ),
    );
  }
}