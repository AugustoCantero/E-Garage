import 'package:flutter_application_1/WidgetsPersonalizados/Aprobado.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MercadoPago.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/PantallaPagos.dart';
import 'package:flutter_application_1/screens/EditarDatos.dart';
import 'package:flutter_application_1/screens/LoginAdministrador.dart';
import 'package:flutter_application_1/screens/ReservaSeleccionVehic.dart';
import 'package:flutter_application_1/screens/AgregarVehiculo.dart';
import 'package:flutter_application_1/screens/VehiculosUsuario.dart';
import 'package:flutter_application_1/Test/test-pantallaAdmin.dart';
import 'package:flutter_application_1/Test/testEdicionVehiculo.dart';
import 'package:flutter_application_1/screens/PantallaReserva.dart';
import 'package:flutter_application_1/Test/test_datos_cuenta.dart';
import 'package:flutter_application_1/screens/PantallaInicio.dart';
import 'package:flutter_application_1/screens/LoginUsuario.dart';
import 'package:flutter_application_1/Test/test-registro-usuario-admin.dart';
import 'package:flutter_application_1/Test/TestRegistracionUser.dart';
/* import 'package:flutter_application_1/screens/screen_principal.dart'; */
import 'package:flutter_application_1/screens/PantallaSeleccion.dart';
import 'package:flutter_application_1/screens/todasLasReservas.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(initialLocation: '/selection', routes: [
  GoRoute(
    path: '/intro',
    builder: (context, state) => const IntroScreen(),
  ),
  GoRoute(
    name: 'SelectionScreen', // Asigna un nombre a la ruta
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

  /*  GoRoute(
      path: '/Screenlogin',
      builder: (context, state) => const ScreenPrincipal(),
      name: ScreenPrincipal.nombre), */
  GoRoute(
    path: '/todasLasReservas',
    builder: (context, state) => todasLasReservas(),
    name: todasLasReservas.nombre,
  ),
  GoRoute(
    path: '/EditarDatosAuto',
    builder: (context, state) => const EditarDatosAuto(),
    name: EditarDatosAuto.name,
    //descomentar por si se quiere probar TEST_EDICION_CUENTA.name,
  ),
  GoRoute(
    path: '/HomeUser',
    builder: (context, state) => const LoginUsuario(),
    name: LoginUsuario.name,
  ),
  GoRoute(
    path: '/HomeAdmin',
    builder: (context, state) => const AdminHomePage(),
    name: AdminHomePage.name,
  ),
  GoRoute(
    path: '/AgregarVehiculos',
    builder: (context, state) => const AgregarVehiculos(),
    name: AgregarVehiculos.name,
  ),
  GoRoute(
    path: '/vehiculosUsuario',
    builder: (context, state) => const vehiculosUsuario(),
    name: vehiculosUsuario.name,
  ),
  GoRoute(
    path: '/testAdminScreen',
    builder: (context, state) => const testAdminScreen(),
    name: testAdminScreen.name,
  ),
  GoRoute(
    path: '/EditarDatos',
    builder: (context, state) => const EditarDatosScreen(),
    name: EditarDatosScreen.name,
  ),
  GoRoute(
    path: '/ReservationScreen',
    builder: (context, state) => ReservationScreen(),
    name: ReservationScreen.name,
  ),
  GoRoute(
    path: '/ReservationSelectVehicule',
    builder: (context, state) => const GestionVehiculosScreen(),
    name: GestionVehiculosScreen.name,
  ),
  GoRoute(
    path: '/MercadoPagoScreen',
    builder: (context, state) => MercadoPagoScreen(),
    name: MercadoPagoScreen.name,
  ),
  GoRoute(
    path: '/',
    builder: (context, state) => const PagoScreen(),
  ),
  GoRoute(
    path: '/aprobado',
    builder: (context, state) => const AprobadoScreen(),
  ),
]);
