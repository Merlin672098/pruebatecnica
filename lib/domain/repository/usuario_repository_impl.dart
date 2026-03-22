// domain/repository/usuario_repository_impl.dart
import 'dart:convert';
import 'package:pruebatecnica/constants/constants.dart';
import 'package:pruebatecnica/domain/repository/usuario_repostiroy.dart';

import '../entities/usuario.dart';
import '../models/usuario_model.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {

  @override
  Future<bool> create(Usuario usuario) async {
    try {
      final model = UsuarioModel(
        usuarioNombre:    usuario.usuarioNombre,
        usuarioClave:     usuario.usuarioClave,
        usuarioEmail:     usuario.usuarioEmail,
        idRol:            usuario.idRol,
        usuarioCondicion: usuario.usuarioCondicion,
        firebaseUid:      usuario.firebaseUid,
      );
          print('📦 Enviando a .NET: ${model.toJson()}');

      final response = await ApiProvider.post('/api/usuarios', model.toJson());
      return response.statusCode == 201;
    } catch (e) {
      print('Error create: $e');
      return false;
    }
  }

  @override
  Future<Usuario?> login(String nombre, String clave) async {
    try {
      final response = await ApiProvider.post('/api/usuarios/login', {
        'usuarioNombre': nombre,
        'usuarioClave':  clave,
      });
      if (response.statusCode == 200) {
        return UsuarioModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error login: $e');
      return null;
    }
  }

  @override
  Future<Usuario?> obtenerById(int id) async {
    try {
      final response = await ApiProvider.get('/api/usuarios/$id');
      if (response.statusCode == 200) {
        return UsuarioModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error obtenerById: $e');
      return null;
    }
  }

  @override
  Future<bool> modificar(Usuario usuario, int id) async {
    try {
      final model = UsuarioModel(
        usuarioNombre:    usuario.usuarioNombre,
        usuarioClave:     usuario.usuarioClave,
        usuarioEmail:     usuario.usuarioEmail,
        idRol:            usuario.idRol,
        usuarioCondicion: usuario.usuarioCondicion,
      );
      final response = await ApiProvider.put('/api/usuarios/$id', model.toJson());
      return response.statusCode == 200;
    } catch (e) {
      print('Error modificar: $e');
      return false;
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      final response = await ApiProvider.delete('/api/usuarios/$id');
      return response.statusCode == 200;
    } catch (e) {
      print('Error delete: $e');
      return false;
    }
  }

  @override
  Future<Usuario?> obtenerByFirebaseUid(String uid) async {
    final response = await ApiProvider.get('/api/usuarios/firebase/$uid');
    if (response.statusCode == 200) {
      return UsuarioModel.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode == 404) {
      return null; // usuario no existe — crear
    }
    throw Exception('Error del servidor: ${response.statusCode}');
    // Si hay timeout lanzará excepción y no intentará crear
  }
}