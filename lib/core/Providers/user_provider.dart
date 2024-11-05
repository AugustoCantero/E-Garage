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
            telefono: '',
            esAdmin: false));

  void setUsuario(String id, String nombre, String apellido, String email,
      String password, String dni, String telefono, bool esAdmin) {
    state = state.copywith(
        id: id,
        nombre: nombre,
        apellido: apellido,
        password: password,
        email: email,
        dni: dni,
        telefono: telefono,
        esAdmin: esAdmin);
  }

  // Método para limpiar los datos del usuario (cierre de sesión)
  void clearUsuario() {
    state = Usuario(
      id: '',
      email: '',
      password: '',
      nombre: '',
      apellido: '',
      dni: '',
      telefono: '',
      esAdmin: false,
    );
  }
}

