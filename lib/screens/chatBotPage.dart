import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  List<Map<String, dynamic>> _messages = [];
  final String witAiToken = 'NXI4QFXBAW6JV7TPWT3VBQZ7EU2PAOA4';  // Token de Wit.ai
  List<String> options = [];  // Opciones clicables que aparecen después de la respuesta

  // Función para enviar el mensaje del usuario y obtener la respuesta del bot
  void _sendMessage(String message) async {
    setState(() {
      _messages.insert(0, {'data': 1, 'message': message}); // Mensaje del usuario
    });

    // Llamar a la API de Wit.ai para obtener la respuesta
    String botResponse = await _getChatbotResponse(message);
    setState(() {
      _messages.insert(0, {'data': 0, 'message': botResponse, 'options': options}); // Respuesta del bot

      // Mostrar opciones dependiendo de la respuesta del bot
      if (botResponse.contains("reservar")) {
        options = ["Para hoy", "Para mañana", "Para esta semana"];
      } else if (botResponse.contains("cancelar")) {
        options = ["Cancelar reserva actual", "No cancelar"];
      } else {
        options = ["Reservar un espacio", "Consultar precio", "Cancelar una reserva"];
      }
    });
  }

  // Función que hace la llamada a la API de Wit.ai
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

  // Procesar la respuesta de Wit.ai
  String _parseWitResponse(Map<String, dynamic> data) {
    if (data['intents'] != null && data['intents'].isNotEmpty) {
      String intent = data['intents'][0]['name'];
      // Manejo de intents
      switch (intent) {
        case 'reservar_espacio':
          return "¿Para cuándo te gustaría reservar?";
        case 'consultar_precio':
          return "Los precios comienzan desde 10 por hora.";
        case 'cancelar_reserva':
          return "¿Estás seguro de que deseas cancelar la reserva?";
        case 'saludo':
        return "Hola! soy tu asistente virtual, en que puedo ayudarte hoy?";
        default:
          return "No entiendo tu solicitud.";
      }
    } else {
      return "No pude entender lo que dijiste.";
    }
  }

  // Manejo de clic en las opciones
  void _handleOptionClick(String option) {
    _sendMessage(option);  // Envía la opción seleccionada como si fuera un mensaje del usuario
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('carBot'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Mostrar los mensajes en el chat
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
                            padding: EdgeInsets.all(10),
                            color: Colors.green[100],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_messages[index]['message']),
                                // Mostrar opciones clicables en el mismo cuadro que la respuesta del bot
                                if (isBotMessage && _messages[index]['options'] != null)
                                  Wrap(
                                    children: _messages[index]['options'].map<Widget>((option) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.green[200],
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          ),
                                          onPressed: () {
                                            _handleOptionClick(option);  // Al hacer clic, enviar la opción como mensaje
                                          },
                                          child: Text(option, style: TextStyle(color: Colors.black)),
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
                            padding: EdgeInsets.all(10),
                            color: Colors.blue[100],
                            child: Text(_messages[index]['message']),
                          ),
                        ),
                );
              },
            ),
          ),

          // Campo de entrada de texto
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      _sendMessage(value);  // Envía el mensaje cuando el usuario presiona "Enter"
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage("Mensaje enviado");  // Envía el mensaje al presionar el botón
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
