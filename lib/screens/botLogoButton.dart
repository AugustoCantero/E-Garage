import 'package:flutter/material.dart';
import 'chatBotPage.dart';  // Asegúrate de importar la pantalla del chatbot

class BotLogoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Al hacer clic, se navega a la pantalla del bot
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatBotPage()),
        );
      },
      backgroundColor: Colors.blue,
      child: Image.asset('assets/images/bot.png'), 
    );
  }
}
