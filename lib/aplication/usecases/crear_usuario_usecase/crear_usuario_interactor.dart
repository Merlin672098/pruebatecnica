import 'package:pruebatecnica/domain/repository/usuario_repostiroy.dart';

import '../../../domain/entities/usuario.dart';
import '../../../interfaceadapters/presenters/crear_usuario_presenter.dart';

class CrearUsuarioInteractor {
  final CrearUsuarioOutput output;
  final UsuarioRepository repository;

  CrearUsuarioInteractor({
    required this.output,
    required this.repository,
  });

  Future<void> crearUsuario(Usuario usuario) async {
    try {
      // Validaciones de negocio
      if (usuario.usuarioNombre == null || usuario.usuarioNombre!.isEmpty) {
        output.onUsuarioError('El nombre de usuario es requerido');
        return;
      }
      if (usuario.usuarioClave == null || usuario.usuarioClave!.length < 6) {
        output.onUsuarioError('La contraseña debe tener al menos 6 caracteres');
        return;
      }
      if (usuario.usuarioEmail == null || !usuario.usuarioEmail!.contains('@')) {
        output.onUsuarioError('El correo no es válido');
        return;
      }

      final resultado = await repository.create(usuario);

      if (resultado) {
        output.onUsuarioCreado();
      } else {
        output.onUsuarioError('No se pudo crear el usuario');
      }
    } catch (e) {
      output.onUsuarioError('Error inesperado: $e');
    }
  }
}