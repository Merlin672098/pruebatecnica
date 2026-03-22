import 'package:flutter/material.dart';
import 'package:pruebatecnica/domain/repository/usuario_repository_impl.dart';
import '../../../aplication/usecases/crear_usuario_usecase/crear_usuario_interactor.dart';
import '../../../domain/entities/usuario.dart';
import '../../presenters/crear_usuario_presenter.dart';

class CrearUsuarioScreen extends StatefulWidget {
  @override
  State<CrearUsuarioScreen> createState() => _CrearUsuarioScreenState();
}

class _CrearUsuarioScreenState extends State<CrearUsuarioScreen> {
  final GlobalKey<FormState> keyForm = GlobalKey();
  final TextEditingController nombreCtrl  = TextEditingController();
  final TextEditingController emailCtrl   = TextEditingController();
  final TextEditingController claveCtrl   = TextEditingController();
  final TextEditingController rolCtrl     = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Usuario')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: keyForm,
          child: Column(
            children: [
              _formItem(Icons.person, TextFormField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre Usuario'),
              )),
              _formItem(Icons.email, TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Correo'),
              )),
              _formItem(Icons.lock, TextFormField(
                controller: claveCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
              )),
              _formItem(Icons.badge, TextFormField(
                controller: rolCtrl,
                decoration: const InputDecoration(labelText: 'ID Rol'),
                keyboardType: TextInputType.number,
              )),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardar,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formItem(IconData icon, Widget item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }

  Future<void> _guardar() async {
    if (keyForm.currentState!.validate()) {
      CrearUsuarioInteractor interactor = CrearUsuarioInteractor(
        output:     CrearUsuarioPresenter(context),
        repository: UsuarioRepositoryImpl(),
      );

      final usuario = Usuario(
        usuarioNombre: nombreCtrl.text,
        usuarioEmail:  emailCtrl.text,
        usuarioClave:  claveCtrl.text,
        idRol:         int.tryParse(rolCtrl.text),
      );

      await interactor.crearUsuario(usuario);
    }
  }
}