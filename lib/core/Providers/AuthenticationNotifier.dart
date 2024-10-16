import 'package:flutter_riverpod/flutter_riverpod.dart';

// Clase que manejará el estado de autenticación
class AuthenticationNotifier extends StateNotifier<bool> {
  AuthenticationNotifier() : super(false);

  // Método para cambiar el estado de autenticación
  void setAuthenticated(bool isAuthenticated) {
    state = isAuthenticated;
  }
}

// Proveedor de Riverpod para manejar la autenticación
final authenticationProvider =
    StateNotifierProvider<AuthenticationNotifier, bool>(
  (ref) => AuthenticationNotifier(),
);
