import 'package:flutter/material.dart';

abstract class CrearUsuarioOutput {
  void onUsuarioCreado();
  void onUsuarioError(String mensaje);
}

class CrearUsuarioPresenter implements CrearUsuarioOutput {
  final BuildContext context;
  CrearUsuarioPresenter(this.context);

  @override
  void onUsuarioCreado() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuario creado correctamente'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void onUsuarioError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }
}