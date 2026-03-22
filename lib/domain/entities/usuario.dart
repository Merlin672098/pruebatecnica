class Usuario {
  final int? idUsuario;
  final String? usuarioNombre;
  final String? usuarioClave;
  final String? usuarioEmail;
  final int? idPersona;
  final int? usuarioCondicion;
  final int? idRol;
  final String? firebaseUid;  // ← nuevo

  Usuario({
    this.idUsuario,
    this.usuarioNombre,
    this.usuarioClave,
    this.usuarioEmail,
    this.idPersona,
    this.usuarioCondicion,
    this.idRol,
    this.firebaseUid,           // ← nuevo
  });
}