import '../entities/usuario.dart';

abstract class UsuarioRepository {
  Future<bool> create(Usuario usuario);
  Future<Usuario?> login(String nombre, String clave);
  Future<Usuario?> obtenerById(int id);
  Future<Usuario?> obtenerByFirebaseUid(String uid);
  Future<bool> modificar(Usuario usuario, int id);
  Future<bool> delete(int id);
}