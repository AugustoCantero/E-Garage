import 'package:flutter_application_1/screens/calendar_demo.dart';
import 'package:flutter_application_1/screens/datos_cuenta_screen.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/intro_screen.dart';
import 'package:flutter_application_1/screens/login_exitoso.dart';
import 'package:flutter_application_1/screens/registro_admin_screen.dart';
import 'package:flutter_application_1/screens/registro_screen.dart';
import 'package:flutter_application_1/screens/registro_usuario_screen.dart';
import 'package:flutter_application_1/screens/screen_principal.dart';
import 'package:flutter_application_1/screens/selection_screen.dart';
import 'package:flutter_application_1/screens/todasLasReservas.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(initialLocation: '/intro', routes: [
  GoRoute(
    path: '/intro',
    builder: (context, state) => const IntroScreen(),
  ),
  GoRoute(
    path: '/selection',
    builder: (context, state) => const SelectionScreen(),
  ),
  GoRoute(
    path: '/registro',
    builder: (context, state) => const RegistroScreen(),
  ),
  GoRoute(
    path: '/registro-usuario',
    builder: (context, state) => const RegistroUsuarioScreen(),
  ),
  GoRoute(
    path: '/registro-admin',
    builder: (context, state) => const RegistroAdminScreen(),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => const Login(),
    builder: (context, state) => Login(),
    name: Login.name,
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) => const Home(),
    name: Home.name,
  ),
  GoRoute(
      path: '/Screenlogin',
      builder: (context, state) => const ScreenPrincipal(),
      name: ScreenPrincipal.nombre),
  GoRoute(
    path: '/todasLasReservas',
    builder: (context, state) => todasLasReservas(),
    name: todasLasReservas.nombre,
  ),
  GoRoute(
    path: '/calendarioReserva',
    builder: (context, state) => const CalendarDemo(),
    name: CalendarDemo.name,
  ),
  GoRoute(
    path: '/EditarCuentaScreen',
    builder: (context, state) => TEST_EDICION_CUENTA(),
    name: TEST_EDICION_CUENTA.name,
  ),
]);
