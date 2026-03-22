import '../entities/producto.dart';

class ProductoModel extends Producto {
  ProductoModel({
    super.idProducto,
    super.sku,
    super.nombre,
    super.precio,
    super.moneda,
    super.stock,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
  return ProductoModel(
    idProducto: json['IdProducto'] ?? json['idProducto'],
    sku:        json['Sku']        ?? json['sku'],
    nombre:     json['Nombre']     ?? json['nombre'],
    precio:     (json['Precio']    ?? json['precio'] as num?)?.toDouble(),
    moneda:     json['Moneda']     ?? json['moneda'],
    stock:      json['Stock']      ?? json['stock'],
  );
}

  Map<String, dynamic> toJson() => {
    'sku':    sku,
    'nombre': nombre,
    'precio': precio,
    'moneda': moneda,
    'stock':  stock,
  };
}