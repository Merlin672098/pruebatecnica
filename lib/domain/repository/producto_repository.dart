import '../entities/producto.dart';

abstract class ProductoRepository {
  Future<List<Producto>> listarTodos();
  Future<List<Producto>> buscar(String texto);
  Future<bool> actualizarPrecio(int id, double precio);
}