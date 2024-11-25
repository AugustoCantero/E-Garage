import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuUsuario.dart';
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
  String? documentId; // ID del documento existente (si lo hay)

  @override
  void initState() {
    super.initState();
    _cargarComentarioExistente();
  }

  Future<void> _cargarComentarioExistente() async {
    final laReserva = ref.read(reservaEnGarageProvider);

    if (laReserva != null) {
      final comentarioExistente = await _fetchReservas(laReserva);
      if (comentarioExistente != null) {
        setState(() {
          _rating = comentarioExistente.puntuacion!;
          textoController.text = comentarioExistente.comentario ?? '';
          documentId = comentarioExistente.id; // Guarda el ID del documento
        });
      }
    }
  }

  Future<Comentarioreserva?> _fetchReservas(Reserva laReserva) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('ComentarioReserva')
          .where('idReserva', isEqualTo: laReserva.id)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        documentId = doc.id; // Guarda el ID del documento
        return Comentarioreserva(
          id: doc.id, // Aquí pasas el ID del documento
          idGarage: data['idGarage'],
          idReserva: data['idReserva'],
          idUsuario: data['idUsuario'],
          comentario: data['comentario'],
          puntuacion: data['puntuacion'],
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error al obtener comentario: $e');
      return null;
    }
  }

  Future<void> _guardarComentario(Reserva reserva, String idDelUsuario,
      double laPuntuacion, String elComentario) async {
    final comentarioNuevo = Comentarioreserva(
      id: documentId, // Usa el ID del documento si existe, o null si es nuevo
      idGarage: reserva.garajeId,
      idReserva: reserva.id,
      idUsuario: idDelUsuario,
      comentario: elComentario,
      puntuacion: laPuntuacion,
    );

    if (documentId != null) {
      // Actualiza el documento existente
      await db
          .collection('ComentarioReserva')
          .doc(documentId)
          .update(comentarioNuevo.toFirestore());
      print('Comentario actualizado con ID: $documentId');
    } else {
      // Crea un nuevo documento
      DocumentReference docRef = await db
          .collection('ComentarioReserva')
          .add(comentarioNuevo.toFirestore());
      documentId = docRef.id; // Guarda el ID del nuevo documento
      print('Nuevo comentario creado con ID: $documentId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final laReserva = ref.read(reservaEnGarageProvider);
    final elUsuario = ref.read(usuarioProvider);

    return Scaffold(
      backgroundColor: Colors.black,
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
      drawer: const MenuUsuario(),
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
            const Text(
              'Puntúa la experiencia:',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Escribe tu comentario:',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: textoController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.multiline,
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
            Text(
              'Tu puntuación: $_rating',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
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
            Positioned(
              bottom: 20,
              left: 20,
              child: BackButtonWidget(
                onPressed: () {
                  context.push('/historialReservas');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
