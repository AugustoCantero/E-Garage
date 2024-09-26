class User {

    int usuarioID;
    String nombre;
    String apellido;
    String email;
    String password;
    String telefono;
    Role rol;

    //agregar tema de faceID huella

  User({
  required this.usuarioID,
  required this.nombre,
  required this.apellido,
  required this.email,
  required this.password,
  required this.telefono,
  required this.rol
   });
  

}

enum Role {
  Admin,
  Usuario,
}