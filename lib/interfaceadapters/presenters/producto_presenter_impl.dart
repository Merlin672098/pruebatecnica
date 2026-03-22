// interfaceadapters/presenters/producto_presenter_impl.dart
import 'package:flutter/material.dart';
import 'producto_presenter.dart';

class ProductoPresenter implements ProductoOutput {
  final BuildContext context;
  ProductoPresenter(this.context);

  @override
  void onProductosCargados(List<dynamic> productos) {
    // La pantalla maneja el estado, esto es opcional
  }

  @override
  void onProductoError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void onPrecioActualizado(int id, double nuevoPrecio) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Precio actualizado correctamente'),
        backgroundColor: Colors.green,
      ),
    );
  }
}