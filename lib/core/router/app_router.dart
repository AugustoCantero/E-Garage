import 'package:flutter_application_1/screens/GesionarReserva.dart';
import 'package:flutter_application_1/Test/test_modif_reserva.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/Aprobado.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/PantallaPagos.dart';
import 'package:flutter_application_1/screens/EditarDatos.dart';
import 'package:flutter_application_1/screens/ReservaSeleccionVehic.dart';
import 'package:flutter_application_1/screens/AgregarVehiculo.dart';
import 'package:flutter_application_1/screens/VehiculosUsuario.dart';
import 'package:flutter_application_1/screens/EdicionDatosVehiculo.dart';
import 'package:flutter_application_1/screens/PantallaReserva.dart';
import 'package:flutter_application_1/screens/PantallaInicio.dart';
import 'package:flutter_application_1/screens/LoginUsuario.dart';
import 'package:flutter_application_1/screens/PantallaSeleccion.dart';
import 'package:flutter_application_1/screens/todasLasReservas.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(initialLocation: '/selection', routes: [
  GoRoute(
    path: '/intro',
    builder: (context, state) => const IntroScreen(),
  ),
  GoRoute(
    name: 'SelectionScreen',
    path: '/selection',
    builder: (context, state) => const SelectionScreen(),
  ),
  GoRoute(
    path: '/todasLasReservas',
    builder: (context, state) => todasLasReservas(),
    name: todasLasReservas.nombre,
  ),
  GoRoute(
    path: '/EditarDatosAuto',
    builder: (context, state) => const EditarDatosAuto(),
    name: EditarDatosAuto.name,
  ),
  GoRoute(
    path: '/HomeUser',
    builder: (context, state) => const LoginUsuario(),
    name: LoginUsuario.name,
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
    path: '/',
    builder: (context, state) => const PagoScreen(),
  ),
  GoRoute(
    path: '/aprobado',
    builder: (context, state) => const AprobadoScreen(),
  ),
  GoRoute(
    path: '/editarReserva',
    builder: (context, state) => editarReserva(),
    name: editarReserva.name,
  ),
  GoRoute(
    path: '/ModificacionReservationScreen',
    builder: (context, state) => ModificacionReservationScreen(),
    name: ModificacionReservationScreen.name,
  ),
]);
