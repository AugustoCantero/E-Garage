import 'package:flutter/material.dart';

class Lote extends StatelessWidget {
  final int id;
  final bool isSelected;
  final VoidCallback onSelected;

  Lote({
    super.key,
    required this.id,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onSelected,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(isSelected ? Colors.red : Colors.green),
        ),

        //Nro de lote
        child: Text(
          'P$id',
          style: const TextStyle(color: Colors.white),
        ));
  }
}
