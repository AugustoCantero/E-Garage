import 'package:flutter_application_1/screens/intro_screen.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/registro_admin_screen.dart';
import 'package:flutter_application_1/screens/registro_screen.dart';
import 'package:flutter_application_1/screens/registro_usuario_screen.dart';
import 'package:flutter_application_1/screens/screen_principal.dart';
import 'package:flutter_application_1/screens/selection_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(initialLocation: '/intro', routes: [
  GoRoute(
    path: '/intro',
    builder: (context, state) => IntroScreen(),
  ),
  GoRoute(
    path: '/selection',
    builder: (context, state) => SelectionScreen(),
  ),
  GoRoute(
    path: '/registro',
    builder: (context, state) => RegistroScreen(),
  ),
  GoRoute(
    path: '/registro-usuario',
    builder: (context, state) => RegistroUsuarioScreen(),
  ),
  GoRoute(
    path: '/registro-admin',
    builder: (context, state) => RegistroAdminScreen(),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => Login(),
  ),
  GoRoute(
    path: '/Screenlogin',
    builder: (context, state) => ScreenPrincipal(),
  ),
]);
