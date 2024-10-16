import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BoxDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final String message;

  BoxDialog({
    super.key,
    required this.onCancel,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[200],
      content: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            MaterialButton(onPressed: onCancel, child: const Text('Volver')),
          ],
        ),
      ),
    );
  }
}
