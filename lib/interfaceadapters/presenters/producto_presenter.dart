abstract class ProductoOutput {
  void onProductosCargados(List<dynamic> productos);
  void onProductoError(String mensaje);
  void onPrecioActualizado(int id, double nuevoPrecio);
}