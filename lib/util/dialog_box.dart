import 'package:flutter/material.dart';
import 'my_button.dart';

class DialogBox extends StatelessWidget {

  final TextEditingController controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
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

            // get user input
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new task",
              ),
            ),

            const SizedBox(height: 10),

            // buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                // save button
                MyButton(
                  text: "Save",
                  onPressed: onSave,
                ),

                const SizedBox(width: 8),

                // cancel button
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