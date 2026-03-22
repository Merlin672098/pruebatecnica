import '../../../domain/entities/producto.dart';
import '../../../domain/repository/producto_repository.dart';
import '../../../interfaceadapters/presenters/producto_presenter.dart';

class ProductoInteractor {
  final ProductoOutput output;
  final ProductoRepository repository;

  ProductoInteractor({
    required this.output,
    required this.repository,
  });

  Future<List<Producto>> listarTodos() async {
    try {
      final productos = await repository.listarTodos();
      if (productos.isEmpty) {
        output.onProductoError('No hay productos disponibles');
      } else {
        output.onProductosCargados(productos);
      }
      return productos;
    } catch (e) {
      output.onProductoError('Error al cargar productos: $e');
      return [];
    }
  }

  Future<List<Producto>> buscar(String texto) async {
    try {
      if (texto.trim().isEmpty) {
        output.onProductoError('Ingresa un texto para buscar');
        return [];
      }
      final productos = await repository.buscar(texto);
      output.onProductosCargados(productos);
      return productos;
    } catch (e) {
      output.onProductoError('Error al buscar: $e');
      return [];
    }
  }

  Future<void> actualizarPrecio(int id, double precio) async {
    try {
      // Validación de negocio — igual que el backend
      if (precio <= 0) {
        output.onProductoError('El precio debe ser mayor a 0');
        return;
      }
      final resultado = await repository.actualizarPrecio(id, precio);
      if (resultado) {
        output.onPrecioActualizado(id, precio);
      } else {
        output.onProductoError('No se pudo actualizar el precio');
      }
    } catch (e) {
      output.onProductoError('Error al actualizar precio: $e');
    }
  }
}