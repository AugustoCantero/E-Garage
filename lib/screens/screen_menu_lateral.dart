//import 'package:app_de_estacionamiento/presentations/screens/login.dart';
import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';

class ScreenMenuLateral extends StatelessWidget implements PreferredSizeWidget {
  static const String name = 'ScreenMenuLateral';

  const ScreenMenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            )),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
