import 'package:flutter/material.dart';

class CardReserva extends StatelessWidget {
  final String titulito;

  const CardReserva({
    super.key, 
    required this.titulito
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 250,
          height: 150,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey)
            
          ),
          child: Text(titulito),
        ),

        const SizedBox(height: 25,),

        
      ],
    );
  }
}