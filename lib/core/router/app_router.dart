import 'package:flutter_application_1/screens/intro_screen.dart';
import 'package:flutter_application_1/screens/login_exitoso.dart';
import 'package:flutter_application_1/screens/registro_admin_screen.dart';
import 'package:flutter_application_1/screens/registro_screen.dart';
import 'package:flutter_application_1/screens/registro_usuario_screen.dart';
import 'package:flutter_application_1/screens/screen_principal.dart';
import 'package:flutter_application_1/screens/selection_screen.dart';
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
  ),
  GoRoute(
    path: '/Screenlogin',
    builder: (context, state) => const ScreenPrincipal(),
  ),
]);
