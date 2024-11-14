import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/Mapa.dart';
import 'package:flutter_application_1/screens/reservasUsuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final List<Map<String, dynamic>> _messages = [];
  final String witAiToken = 'NXI4QFXBAW6JV7TPWT3VBQZ7EU2PAOA4';
  List<String> options = [];
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage(String message) async {
    setState(() {
      _messages.insert(0, {'data': 1, 'message': message});
      _messageController.clear();
    });

    String botResponse = await _getChatbotResponse(message);

    List<String> opcionesBot = [];

    if (botResponse.contains("reservar")) {
      opcionesBot = ["Para hoy", "Para mañana", "Para esta semana"];
    } else if (botResponse.contains("cancelar")) {
      opcionesBot = ["Cancelar reserva actual", "No cancelar"];
    } else {
      opcionesBot = [
        "Reservar un espacio",
        "Consultar precio",
        "Cancelar una reserva"
      ];
    }

    setState(() {
      _messages.insert(
          0, {'data': 0, 'message': botResponse, 'options': opcionesBot});
    });
  }

  Future<String> _getChatbotResponse(String message) async {
    const String apiUrl = "https://api.wit.ai/message";

    var response = await http.get(
      Uri.parse('$apiUrl?q=$message'),
      headers: {
        'Authorization': 'Bearer $witAiToken',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return _parseWitResponse(data);
    } else {
      return "Lo siento, no puedo procesar esa solicitud en este momento.";
    }
  }

  String _parseWitResponse(Map<String, dynamic> data) {
    if (data['intents'] != null && data['intents'].isNotEmpty) {
      String intent = data['intents'][0]['name'];
      switch (intent) {
        case 'reservar_espacio':
          return "¿Para cuándo te gustaría reservar?";
        case 'consultar_precio':
          return "Los precios comienzan desde 10 por hora.";
        case 'cancelar_reserva':
          return "¿Estás seguro de que deseas cancelar la reserva?";
        case 'saludo':
          return "Hola! soy tu asistente virtual, en qué puedo ayudarte hoy?";
        default:
          return "No entiendo tu solicitud.";
      }
    } else {
      return "No pude entender lo que dijiste.";
    }
  }

  void _handleOptionClick(String option) {
    if (option == "Para hoy" ||
        option == "Para mañana" ||
        option == "Para esta semana") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OpenStreetMapScreen()),
      );
    } else if (option == "Cancelar una reserva") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReservasUsuario()),
      );
    } else {
      _sendMessage(option);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('carBot'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isBotMessage = _messages[index]['data'] == 0;
                return ListTile(
                  title: isBotMessage
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.green[100],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_messages[index]['message']),
                                if (_messages[index]['options'] != null &&
                                    _messages[index]['options'].isNotEmpty)
                                  Wrap(
                                    children: _messages[index]['options']
                                        .map<Widget>((option) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green[200],
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                          ),
                                          onPressed: () {
                                            _handleOptionClick(option);
                                          },
                                          child: Text(option,
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.blue[100],
                            child: Text(_messages[index]['message']),
                          ),
                        ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
