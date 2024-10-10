import 'package:flutter_application_1/core/Entities/Usuario.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usuarioProvider = StateNotifierProvider<UsuarioNotifier, Usuario>((ref) {
  return UsuarioNotifier();
});

class UsuarioNotifier extends StateNotifier<Usuario> {
  UsuarioNotifier()
      : super(Usuario(
            id: '',
            email: '',
            password: '',
            nombre: '',
            apellido: '',
            dni: '',
            esAdmin: false));

  void setUsuario(String id, String nombre, String apellido, String email,
      String password, bool esAdmin) {
    state = state.copywith(
        id: id,
        nombre: nombre,
        apellido: apellido,
        password: password,
        email: email,
        esAdmin: esAdmin);
  }
}
