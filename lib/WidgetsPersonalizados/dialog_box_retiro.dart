import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BoxDialogRetiro extends StatelessWidget {
  final String message;
  final VoidCallback onCancel;

  const BoxDialogRetiro({
    super.key,
    required this.message,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[200],
      content: Column(
        mainAxisSize: MainAxisSize.min, 
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            message,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20), 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: onCancel,
                child: const Text('Ok'),
              ),
              MaterialButton(
                onPressed: onCancel,
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
