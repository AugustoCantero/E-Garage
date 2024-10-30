import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/screens/login_exitoso_home_user.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ReservasUsuario extends StatefulWidget {
  @override
  _ReservasUsuarioState createState() => _ReservasUsuarioState();
}



class _ReservasUsuarioState extends State<ReservasUsuario> {
  // Función para manejar el botón de retroceso
  void _goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Vuelve a la pantalla anterior si es posible
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const login_exitoso_home_user()), // Redirige a la pantalla inicial si no hay pantallas previas
      );
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors
              .white, // Cambia el color de las tres barras del menú hamburguesa
        ),
        elevation: 0,
        automaticallyImplyLeading:
            true, // Esto añadirá automáticamente el icono del Drawer
      ),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.asset(
              'assets/images/car_logo.png',
              height: 100,
            ),
          ),
          const Text(
            'GESTION de RESERVAS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Expanded(
            child: _ListView(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 20,
            bottom: 20,
            child:  FloatingActionButton(
    onPressed: () => _goBack(context), // Llamada a la función _goBack
    backgroundColor: Colors.white,
    child: const Icon(Icons.arrow_back, color: Colors.black),
  ),
          ),
        ],
      ),
    );
  }

  

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[200],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                'Menú',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, size: 40, color: Colors.black),
              title: const Text('Editar Datos', style: TextStyle(fontSize: 18)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.timer, size: 40, color: Colors.black),
              title: const Text('Gestión de Vehiculos',
                  style: TextStyle(fontSize: 18)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.history, size: 40, color: Colors.black),
              title: const Text('Historial y Registro',
                  style: TextStyle(fontSize: 18)),
              onTap: () {},
            ),
            ListTile(
              leading:
                  const Icon(Icons.exit_to_app, size: 40, color: Colors.black),
              title: const Text('Salir', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ListView extends ConsumerWidget {
  const _ListView({super.key});

  Future<List<Reserva>> _fetchReservas(WidgetRef ref) async {
    final usuarioState = ref.watch(usuarioProvider);
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('Reservas')
        .where('elvehiculo.idDuenio', isEqualTo: usuarioState.id)
        .get();

    return snapshot.docs.map((doc) {
      return Reserva.fromFirestore(doc);
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Reserva>>(
      future: _fetchReservas(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No hay reservas.',
                  style: TextStyle(color: Colors.white)));
        } else {
          List<Reserva> listaReservas = snapshot.data!;
          return ListView.builder(
            itemCount: listaReservas.length,
            itemBuilder: (context, index) {
              Reserva reserva = listaReservas[index];

              String formattedStartTime =
                  DateFormat('yyyy-MM-dd HH:mm').format(reserva.startTime);
              String formattedEndTime =
                  DateFormat('yyyy-MM-dd HH:mm').format(reserva.endTime);

              return Card(
                color: Colors.grey[800],
                child: ListTile(
                  title: Text(
                    'Lote: $formattedStartTime',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Fecha fin: $formattedEndTime, Modelo: ${reserva.elvehiculo.modelo}, patente: ${reserva.elvehiculo.patente}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
