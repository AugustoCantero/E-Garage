import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavbar extends StatelessWidget {
  final void Function(int)? onTabChange;

  const MyBottomNavbar({
    super.key,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GNav(
        color: Colors.grey[400],
        activeColor: Colors.grey.shade700,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Colors.grey.shade100,
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 16,
        onTabChange: onTabChange,
        gap: 8,
        tabs: const [
          GButton(
            icon: Icons.garage_outlined,
            text: 'Reservar',
          ),
          GButton(
            icon: Icons.car_rental_sharp,
            text: 'Retirar',
          ),
          GButton(
            icon: Icons.search,
            text: 'Buscar Auto',
          ),
        ],
      ),
    );
  }
}