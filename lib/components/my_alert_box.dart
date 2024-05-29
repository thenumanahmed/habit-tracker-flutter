import 'package:flutter/material.dart';

class MyAlertBox extends StatelessWidget {
  final dynamic textController;
  final String hintText;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  const MyAlertBox({
    super.key,
    required this.textController,
    required this.hintText,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      content: TextField(
        controller: textController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[600]),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.white,
            )),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.white,
            ))),
      ),
      actions: [
        MaterialButton(
          onPressed: onSave,
          color: Colors.black,
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
        ),
        MaterialButton(
          onPressed: onCancel,
          color: Colors.black,
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
