import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class pantallaPrincipal extends StatelessWidget {
  static const String name = 'pantallaPrincipal';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  pantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('EGarage (EG)')),
        ),
        body: Center(
          child: FutureBuilder<DocumentSnapshot>(
            future: _firestore
                .collection('Lugares')
                .doc('68PCmlqAUB3JJdDFBodl')
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  int totalLugares = data['cantTotalLugares'] ?? 0;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Todavía hay',
                        style: TextStyle(fontSize: 24),
                      ),
                      Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.rectangle,
                        ),
                        child: Center(
                          child: Text(
                            totalLugares.toString(),
                            style: const TextStyle(
                                fontSize: 48, color: Colors.white),
                          ),
                        ),
                      ),
                      const Text(
                        'lugares',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  );
                } else {
                  return const Text("Datos no encontrados");
                }
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
