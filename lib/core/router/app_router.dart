import 'package:flutter_application_1/screens/Test_agregar_vehiculos.dart';
import 'package:flutter_application_1/screens/VehiculosUsuario.dart';
import 'package:flutter_application_1/screens/calendar_demo.dart';
import 'package:flutter_application_1/screens/test_datos_cuenta.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/intro_screen.dart';
import 'package:flutter_application_1/screens/login_exitoso_home_user.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/test-registro_admin_screen.dart';
import 'package:flutter_application_1/screens/test-registro-usuario-admin.dart';
import 'package:flutter_application_1/screens/TestRegistracionUser.dart';
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
    path: '/LoginScreen',
    builder: (context, state) => LoginScreen(),
    name: LoginScreen.name,
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
    path: '/TEST_EDICION_CUENTA',
    builder: (context, state) => const TEST_EDICION_CUENTA(),
    name: TEST_EDICION_CUENTA.name,
  ),
  GoRoute(
    path: '/loginExitosoHomeUser',
    builder: (context, state) => const login_exitoso_home_user(),
    name: login_exitoso_home_user.name,
  ),
  GoRoute(
    path: '/TestAgregarVehiculos',
    builder: (context, state) => const TestAgregarVehiculos(),
    name: TestAgregarVehiculos.name,
  ),
  GoRoute(
    path: '/vehiculosUsuario',
    builder: (context, state) => const vehiculosUsuario(),
    name: vehiculosUsuario.name,
  ),
]);
