// ignore_for_file: library_private_types_in_public_api, file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBotPage extends ConsumerStatefulWidget {
  const ChatBotPage({super.key});

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends ConsumerState<ChatBotPage> {
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
        "Consultar garajes afiliados",
        "Consultar mis reservas",
        "Reservar un espacio",
        "Cancelar una reserva",
        
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

  Future<List<Map<String, dynamic>>> _obtenerGarajes() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('garages').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error al obtener garajes afiliados: $e");
      return [];
    }
  }

  Future<List<Reserva>> _obtenerReservas (String usuarioId) async {
    List <Reserva> reservas = [];
    final QuerySnapshot = await FirebaseFirestore.instance
    .collection('Reservas')
    .where('idUsuario', isEqualTo: usuarioId)
    .where('seRetiro', isEqualTo: false)
    .get();

    for (var doc in QuerySnapshot.docs) {
      reservas.add(Reserva.fromFirestore(doc));
    }
    return reservas;
  }

  String _parseWitResponse(Map<String, dynamic> data) {
    if (data['intents'] != null && data['intents'].isNotEmpty) {
      String intent = data['intents'][0]['name'];
      switch (intent) {
        case 'reservar_espacio':
          return "¿Para cuándo te gustaría reservar?";
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

  void _handleOptionClick(String option) async {
    if (option == "Para hoy" ||
        option == "Para mañana" ||
        option == "Para esta semana") {
      context.push('/mapa');
    } else if (option == "Cancelar una reserva") {
      context.push('/reservasUsuario');
    } else if (option == "Consultar garajes afiliados") {
      List<Map<String, dynamic>> garages = await _obtenerGarajes();
      String garajesInfo = "Garajes afiliados : \n";
      for (var garage in garages) {
        garajesInfo += "Nombre: ${garage['nombre']}\nDireccion: ${garage['direccion']}\n\n";
      }
      setState(() {
        _messages.insert(0, {'data': 0, 'message': garajesInfo});
      });

    } 
    else if (option == "Consultar mis reservas") {
      final usuario = ref.read(usuarioProvider);
      List<Reserva> reservas = await _obtenerReservas(usuario.id);
      String reservasMessage = reservas.isEmpty
      ? "No tienes reservas activas"
      : reservas.map((reserva) => reserva.infoReserva()).join("\n\n");
      setState(() {
        _messages.insert(0, {'data': 0, 'message': reservasMessage});
      });
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
