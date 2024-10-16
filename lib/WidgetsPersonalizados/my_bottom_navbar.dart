import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyButtomNavbar extends StatelessWidget {
  void Function(int)? onTabChange;
  static const String name = 'MyButtomNavbar';

  MyButtomNavbar({
    super.key,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),

        // Libreria de google_nav_bar
        child: GNav(
          color: Colors.grey[400],
          activeColor: Colors.grey.shade700,
          tabActiveBorder: Border.all(color: Colors.white),
          tabBackgroundColor: Colors.grey.shade100,
          mainAxisAlignment: MainAxisAlignment.center,
          tabBorderRadius: 16,
          onTabChange: (value) => onTabChange!(value),
          gap: 8,
          //onTabChange: (value) => onTabChange!(value),

          tabs: const [
            // Boton de icono + 'Reservar'

            GButton(
              icon: Icons.garage_outlined,
              text: 'Reservar',
            ),

            // Boton de icono + 'Mis Reservas'
            GButton(
              icon: Icons.car_rental_sharp,
              text: 'Retirar',
            ),

            // Boton de icono + 'Buscar Auto'
            GButton(
              icon: Icons.search,
              text: 'Buscar Auto',
            ),
          ],
        ));
  }
}
