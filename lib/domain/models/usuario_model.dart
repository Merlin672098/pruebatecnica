import '../entities/usuario.dart';

class UsuarioModel extends Usuario {
  UsuarioModel({
    super.idUsuario,
    super.usuarioNombre,
    super.usuarioClave,
    super.usuarioEmail,
    super.idPersona,
    super.usuarioCondicion,
    super.idRol,
    super.firebaseUid,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
  return UsuarioModel(
    idUsuario:        json['IdUsuario']        ?? json['idUsuario'],
    usuarioNombre:    json['UsuarioNombre']    ?? json['usuarioNombre'],
    usuarioClave:     json['UsuarioClave']     ?? json['usuarioClave'],
    usuarioEmail:     json['UsuarioEmail']     ?? json['usuarioEmail'],
    idPersona:        json['IdPersona']        ?? json['idPersona'],
    usuarioCondicion: json['UsuarioCondicion'] ?? json['usuarioCondicion'],
    idRol:            json['IdRol']            ?? json['idRol'],
    firebaseUid:      json['FirebaseUid']      ?? json['firebaseUid'],
  );
}

  Map<String, dynamic> toJson() => {
    'usuarioNombre':    usuarioNombre,
    'usuarioClave':     usuarioClave,
    'usuarioEmail':     usuarioEmail,
    'idPersona':        idPersona,
    'usuarioCondicion': usuarioCondicion,
    'idRol':            idRol,
    'firebaseUid':      firebaseUid,
  };
}