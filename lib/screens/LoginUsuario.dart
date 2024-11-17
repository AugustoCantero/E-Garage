import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuUsuario.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonBot.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/Mapa.dart';
import 'package:flutter_application_1/services/bloc/notifications_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/preferencias/pref_usuarios.dart';
import 'package:http/http.dart' as http;

class LoginUsuario extends ConsumerWidget {
  static const String name = "HomeUser";
  const LoginUsuario({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    context.read<NotificationsBloc>().requestPermission();
    var prefs = PreferenciasUsuario();
    print('TOKEN: ' + prefs.token);

    final usuario = ref.watch(usuarioProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const MenuUsuario(),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/car_logo.png',
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'BIENVENIDO',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  usuario.nombre,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),
                OutlinedButton(
                  onPressed: () {
///////////////////////////////Prueba Token////////////////////////////////
                    try {
                      http.post(Uri.parse('https://backnoti.onrender.com'),
                          headers: {"Content-type": "application/json"},
                          body: jsonEncode({
                            //aca en vez del token hardcode iria la variable token de arriba
                            "token": [usuario.token],
                            "data": {
                              "title": "busqueda",
                              "body": "elegi tu garage"
                            }
                          }));
                      print(usuario.token);
                    } catch (e) {}
///////////////////////////////prueba token/////////////////////////////////

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OpenStreetMapScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'BUSCAR LUGAR',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          const BotLogoButton(),
        ],
      ),
    );
  }
}