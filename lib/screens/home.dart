import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/form_reserva.dart';
import 'package:flutter_application_1/screens/pantalla_principal.dart';
import 'package:flutter_application_1/screens/screen_buscar_auto.dart';
import 'package:flutter_application_1/screens/screen_menu_lateral.dart';
import 'package:flutter_application_1/screens/screen_retiro_auto.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/drawer_menu_lateral.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/my_bottom_navbar.dart';

//import 'package:go_router/go_router.dart';

class Home extends StatefulWidget {
  static const String name = 'Home';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index + 1;
    });
  }

  // Paginas a mostrar
  final List<Widget> _pages = [
    pantallaPrincipal(),
    //registro de reserva

    ConfirmReservationPage(),
    // Calendario de las reservas
    //const CalendarDemo(),
    //const AdminReservationCalendar(),

    // Screen de retiro de auto

    // Screen de busqueda de auto
    const RetirarAuto(),
    const BuscadorAuto(),
  ];
//admin@admin.com
//admin2024
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScreenMenuLateral(),
      drawer: const DrawerMenuLateral(),
      bottomNavigationBar: MyButtomNavbar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: _selectedIndex == 0 ? pantallaPrincipal() : _pages[_selectedIndex],
    );
  }
}
