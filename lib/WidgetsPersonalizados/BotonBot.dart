import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/ChatBotPage.dart';

class BotLogoButton extends StatelessWidget {
  const BotLogoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatBotPage()),
          );
        },
        backgroundColor: const Color.fromARGB(0, 33, 149, 243),
        child: Image.asset('assets/images/bot.png'),
      ),
    );
  }
}
