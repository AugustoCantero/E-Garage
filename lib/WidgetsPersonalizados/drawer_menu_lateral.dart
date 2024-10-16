import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/screens/test_datos_cuenta.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/TestLogin.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/todasLasReservas.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DrawerMenuLateral extends ConsumerWidget {
  const DrawerMenuLateral({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuarioState = ref.watch(usuarioProvider);
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // logo
              DrawerHeader(
                  child: Image.network(
                      'https://www.split.io/wp-content/uploads/flutter.png')),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(
                  color: Colors.grey[800],
                ),
              ),

              // Icono de Home
              Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    context.goNamed(Home.name);
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Mi cuenta',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    //context.goNamed(TEST_EDICION_CUENTA.name);
                  },
                ),
              ),

              // Icono de Buscar Auto
              /*const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Buscar Auto',
                    style: TextStyle(color: Colors.white),
                  ),
                  /* onTap: () {
                    context.goNamed(BuscadorAuto.name);
                  },*/
                ),
              ),*/

              // Icono de Acerca de...
              const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Acerca de',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              // Icono de lista de...
              Padding(
                padding: EdgeInsets.only(left: 14.0),
                child: ListTile(
                  leading:
                      const Icon(color: Colors.white, Icons.list_alt_rounded),
                  title: const Text(
                    'Mis reservas',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    print(usuarioState.esAdmin);

                    if (usuarioState.esAdmin == true) {
                      context.goNamed(todasLasReservas.nombre);
                    } else {
                      //   context.goNamed(ReservasUsuario.nombre);
                    }
                  },
                ),
              ),
            ],
          ),

          // Icono de Cerrar Sesión
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                context.goNamed(LoginScreen.name);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReservasUsuario {}
