// interfaceadapters/views/product/productos_screen.dart
import 'package:flutter/material.dart';
import 'package:pruebatecnica/domain/entities/producto.dart';
import 'package:pruebatecnica/domain/models/producto_model.dart';
import 'package:pruebatecnica/domain/repository/producto_repository_impl.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({Key? key}) : super(key: key);

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  final _repository = ProductoRepositoryImpl();
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  List<Producto> _todos = [];
  List<Producto> _filtrados = [];
  bool _isLoading = true;
  bool _hasError = false;

  // Filtros
  String _ordenamiento = 'nombre';   // nombre, precio_asc, precio_desc, stock
  double _precioMin = 0;
  double _precioMax = 99999;
  bool _soloConStock = false;
  String _monedaFiltro = 'Todas';

  // Paginación
  int _paginaActual = 1;
  final int _porPagina = 5;
  int get _totalPaginas => (_filtrados.length / _porPagina).ceil();
  List<Producto> get _productosPagina {
    final inicio = (_paginaActual - 1) * _porPagina;
    final fin = (inicio + _porPagina).clamp(0, _filtrados.length);
    return _filtrados.sublist(inicio, fin);
  }

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarProductos() async {
    setState(() { _isLoading = true; _hasError = false; });
    try {
      final productos = await _repository.listarTodos();
      setState(() {
        _todos = productos;
        _aplicarFiltros();
        _isLoading = false;
      });
    } catch (e) {
      setState(() { _isLoading = false; _hasError = true; });
    }
  }

  void _aplicarFiltros() {
    var resultado = List<Producto>.from(_todos);

    // Búsqueda
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      resultado = resultado.where((p) =>
        (p.nombre?.toLowerCase().contains(query) ?? false) ||
        (p.sku?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    // Filtro stock
    if (_soloConStock) {
      resultado = resultado.where((p) => (p.stock ?? 0) > 0).toList();
    }

    // Filtro moneda
    if (_monedaFiltro != 'Todas') {
      resultado = resultado.where((p) => p.moneda == _monedaFiltro).toList();
    }

    // Filtro precio
    resultado = resultado.where((p) =>
      (p.precio ?? 0) >= _precioMin && (p.precio ?? 0) <= _precioMax
    ).toList();

    // Ordenamiento
    switch (_ordenamiento) {
      case 'precio_asc':
        resultado.sort((a, b) => (a.precio ?? 0).compareTo(b.precio ?? 0));
        break;
      case 'precio_desc':
        resultado.sort((a, b) => (b.precio ?? 0).compareTo(a.precio ?? 0));
        break;
      case 'stock':
        resultado.sort((a, b) => (b.stock ?? 0).compareTo(a.stock ?? 0));
        break;
      default:
        resultado.sort((a, b) => (a.nombre ?? '').compareTo(b.nombre ?? ''));
    }

    setState(() {
      _filtrados = resultado;
      _paginaActual = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFiltrosRapidos(),
          Expanded(child: _buildBody()),
          if (!_isLoading && _filtrados.isNotEmpty) _buildPaginacion(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (_) => _aplicarFiltros(),
        decoration: InputDecoration(
          hintText: 'Buscar por nombre o SKU...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF3450A1)),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () { _searchCtrl.clear(); _aplicarFiltros(); },
                )
              : IconButton(
                  icon: const Icon(Icons.tune, color: Color(0xFF3450A1)),
                  onPressed: _mostrarFiltros,
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFiltrosRapidos() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _chipOrden('Nombre', 'nombre'),
          const SizedBox(width: 8),
          _chipOrden('Precio ↑', 'precio_asc'),
          const SizedBox(width: 8),
          _chipOrden('Precio ↓', 'precio_desc'),
          const SizedBox(width: 8),
          _chipOrden('Stock', 'stock'),
          const SizedBox(width: 8),
          FilterChip(
            label: Text('Con stock', style: TextStyle(fontSize: 12, color: _soloConStock ? Colors.white : Colors.black87)),
            selected: _soloConStock,
            onSelected: (v) { setState(() => _soloConStock = v); _aplicarFiltros(); },
            selectedColor: const Color(0xFF3450A1),
            backgroundColor: Colors.white,
            side: BorderSide(color: _soloConStock ? const Color(0xFF3450A1) : Colors.grey[300]!),
          ),
        ],
      ),
    );
  }

  Widget _chipOrden(String label, String valor) {
    final selected = _ordenamiento == valor;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 12, color: selected ? Colors.white : Colors.black87)),
      selected: selected,
      onSelected: (_) { setState(() => _ordenamiento = valor); _aplicarFiltros(); },
      selectedColor: const Color(0xFF3450A1),
      backgroundColor: Colors.white,
      side: BorderSide(color: selected ? const Color(0xFF3450A1) : Colors.grey[300]!),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF3450A1)));
    }
    if (_hasError) {
      return _buildEstadoVacio(
        icon: Icons.wifi_off,
        titulo: 'Error de conexión',
        subtitulo: 'No se pudo conectar al servidor',
        boton: 'Reintentar',
        onTap: _cargarProductos,
      );
    }
    if (_filtrados.isEmpty) {
      return _buildEstadoVacio(
        icon: Icons.search_off,
        titulo: 'Sin resultados',
        subtitulo: 'No se encontraron productos con los filtros aplicados',
        boton: 'Limpiar filtros',
        onTap: () { _searchCtrl.clear(); setState(() { _soloConStock = false; _monedaFiltro = 'Todas'; _ordenamiento = 'nombre'; }); _aplicarFiltros(); },
      );
    }
    return RefreshIndicator(
      onRefresh: _cargarProductos,
      color: const Color(0xFF3450A1),
      child: ListView.builder(
        controller: _scrollCtrl,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _productosPagina.length,
        itemBuilder: (_, i) => _buildProductoCard(_productosPagina[i]),
      ),
    );
  }

  Widget _buildProductoCard(Producto producto) {
    final stockBajo = (producto.stock ?? 0) < 5;
    final sinStock = (producto.stock ?? 0) == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Ícono producto
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF3450A1).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF3450A1), size: 32),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          producto.nombre ?? '',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (sinStock)
                        _badge('Sin stock', Colors.red)
                      else if (stockBajo)
                        _badge('Stock bajo', Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('SKU: ${producto.sku ?? ''}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${producto.moneda ?? ''} ${producto.precio?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3450A1)),
                      ),
                      Text(
                        'Stock: ${producto.stock ?? 0}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Botón editar precio
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _mostrarEditarPrecio(producto),
              icon: const Icon(Icons.edit, color: Color(0xFF3450A1), size: 20),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF3450A1).withOpacity(0.08),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String texto, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(texto, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildEstadoVacio({
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required String boton,
    required VoidCallback onTap,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 8),
            Text(subtitulo, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3450A1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(boton),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginacion() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _paginaActual > 1 ? () => setState(() => _paginaActual--) : null,
            icon: const Icon(Icons.chevron_left),
            color: const Color(0xFF3450A1),
          ),
          ...List.generate(_totalPaginas, (i) {
            final pagina = i + 1;
            final isActive = pagina == _paginaActual;
            return GestureDetector(
              onTap: () => setState(() => _paginaActual = pagina),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF3450A1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isActive ? const Color(0xFF3450A1) : Colors.grey[300]!),
                ),
                child: Center(
                  child: Text(
                    '$pagina',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            );
          }),
          IconButton(
            onPressed: _paginaActual < _totalPaginas ? () => setState(() => _paginaActual++) : null,
            icon: const Icon(Icons.chevron_right),
            color: const Color(0xFF3450A1),
          ),
        ],
      ),
    );
  }

  void _mostrarFiltros() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filtros', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('Rango de precio', style: TextStyle(fontWeight: FontWeight.w600)),
              RangeSlider(
                values: RangeValues(_precioMin, _precioMax.clamp(0, 5000)),
                min: 0,
                max: 5000,
                divisions: 50,
                activeColor: const Color(0xFF3450A1),
                labels: RangeLabels('${_precioMin.toInt()}', '${_precioMax.toInt()}'),
                onChanged: (v) => setModalState(() { _precioMin = v.start; _precioMax = v.end; }),
              ),
              const SizedBox(height: 12),
              const Text('Moneda', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Todas', 'BOB', 'USD'].map((m) {
                  final sel = _monedaFiltro == m;
                  return ChoiceChip(
                    label: Text(m),
                    selected: sel,
                    onSelected: (_) => setModalState(() => _monedaFiltro = m),
                    selectedColor: const Color(0xFF3450A1),
                    labelStyle: TextStyle(color: sel ? Colors.white : Colors.black87),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () { Navigator.pop(context); _aplicarFiltros(); },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3450A1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Aplicar filtros'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarEditarPrecio(Producto producto) {
    final ctrl = TextEditingController(text: producto.precio?.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Editar precio\n${producto.nombre}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Nuevo precio (${producto.moneda})',
            prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF3450A1)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3450A1), width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final nuevo = double.tryParse(ctrl.text);
              if (nuevo == null || nuevo <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Precio inválido'), backgroundColor: Colors.red),
                );
                return;
              }
              Navigator.pop(context);
              await _actualizarPrecio(producto, nuevo);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3450A1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _actualizarPrecio(Producto producto, double nuevoPrecio) async {
    try {
      final ok = await _repository.actualizarPrecio(producto.idProducto!, nuevoPrecio);
      if (ok) {
        // Actualiza localmente sin recargar toda la lista
        setState(() {
          final idx = _todos.indexWhere((p) => p.idProducto == producto.idProducto);
          if (idx != -1) {
            _todos[idx] = ProductoModel(
              idProducto: producto.idProducto,
              sku:        producto.sku,
              nombre:     producto.nombre,
              precio:     nuevoPrecio,
              moneda:     producto.moneda,
              stock:      producto.stock,
            );
          }
          _aplicarFiltros();
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('Precio actualizado a ${producto.moneda} ${nuevoPrecio.toStringAsFixed(2)}'),
              ]),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar precio'), backgroundColor: Colors.red),
        );
      }
    }
  }
}