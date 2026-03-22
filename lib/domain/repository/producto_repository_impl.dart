// domain/repository/producto_repository_impl.dart
import 'dart:convert';
import 'package:pruebatecnica/constants/constants.dart';

import '../entities/producto.dart';
import '../models/producto_model.dart';
import 'producto_repository.dart';

class ProductoRepositoryImpl implements ProductoRepository {

  @override
  Future<List<Producto>> listarTodos() async {
    try {
      final response = await ApiProvider.get('/api/productos');
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        return json.map((e) => ProductoModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error listarTodos: $e');
      return [];
    }
  }

  @override
  Future<List<Producto>> buscar(String texto) async {
    try {
      final response = await ApiProvider.get('/api/productos/buscar?texto=$texto');
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        return json.map((e) => ProductoModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error buscar: $e');
      return [];
    }
  }

  @override
  Future<bool> actualizarPrecio(int id, double precio) async {
    try {
      final response = await ApiProvider.patch(
        '/api/productos/$id/precio',
        {'precio': precio},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error actualizarPrecio: $e');
      return false;
    }
  }
}