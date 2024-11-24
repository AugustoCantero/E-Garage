import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Entities/ComentarioReserva.dart';
import 'package:flutter_application_1/core/Providers/reservaGarage.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/screens/HistorialReservasUsuario.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class cargarComentarioReserva extends ConsumerStatefulWidget {
  static final String name = 'cargarComentarioReserva';
  const cargarComentarioReserva({super.key});

  @override
  _cargarComentarioReservaState createState() =>
      _cargarComentarioReservaState();
}

class _cargarComentarioReservaState
    extends ConsumerState<cargarComentarioReserva> {
  double _rating = 0.0; // Variable para almacenar el puntaje
  TextEditingController textoController = TextEditingController();
  final db = FirebaseFirestore.instance;

  Future<void> _guardarComentario(Reserva reserva, String idDelUsuario,
      double laPuntuacion, String elComentario) async {
    final comentarioNuevo = cometarioReserva(
        idGarage: reserva.garajeId,
        idReserva: reserva.id,
        idUsuario: idDelUsuario,
        comentario: elComentario,
        puntuacion: laPuntuacion);

    await db.collection('ComentarioReserva').add(comentarioNuevo.toFirestore());
  }

  @override
  Widget build(BuildContext context) {
    // Aquí no necesitas el WidgetRef
    final laReserva = ref.read(reservaEnGarageProvider);
    final elUsuario = ref.read(usuarioProvider);

    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Image.asset(
              'assets/images/car_logo.png',
              height: 100,
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'COMENTARIO',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Puntuación con estrellas
            const Text(
              'Puntúa la experiencia:',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: _rating == 0
                    ? Colors.grey // Estrellas grises antes de seleccionar
                    : Colors.amber, // Estrellas doradas después de seleccionar
                size: 40,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 20),

            // Campo de comentario ampliado
            const Text(
              'Escribe tu comentario:',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: textoController,
              maxLines: 5, // Número máximo de líneas
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.multiline, // Permite multilinea
              decoration: InputDecoration(
                labelText: 'Comentario',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Mostrar puntuación seleccionada
            Text(
              'Tu puntuación: $_rating',
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 20),

            // Botón para guardar o continuar
            ElevatedButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Guardaste $_rating estrellas y el comentario: "${textoController.text}"'),
                  ),
                );
                await _guardarComentario(
                    laReserva, elUsuario.id, _rating, textoController.text);
                context.goNamed(HistorialReservasUsuario.name);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
