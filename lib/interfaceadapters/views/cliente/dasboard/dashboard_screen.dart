import 'package:flutter/material.dart';
import 'package:pruebatecnica/constants/global_variables.dart';

class DashboardClienteScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const DashboardClienteScreen({Key? key, required this.onNavigate})
      : super(key: key);

  @override
  State<DashboardClienteScreen> createState() => _DashboardClienteScreenState();
}

class _DashboardClienteScreenState extends State<DashboardClienteScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Paleta BoliShop
  static const Color _boliBlue   = GlobalVariables.secondaryColor;
  static const Color _boliBg     = GlobalVariables.backgroundColor;
  static const Color _boliSurface= GlobalVariables.greyBackgroundCOlor;
  static const Color _boliGrey   = GlobalVariables.unselectedNavBarColor;
  static const Color _boliActive = GlobalVariables.selectedNavBarColor;

  // Datos de ejemplo
  final List<Map<String, dynamic>> _productos = [
    {
      'nombre': 'Auriculares Bluetooth',
      'precio': 199.90,
      'precioAnterior': 808.0,
      'stock': 'IN STOCK: 214 UNITS',
      'imagen': 'assets/productos/auriculares.jpg',
      'tag': 'BOB 808',
      'color': const Color(0xFF4A7C59), // verde del fondo
    },
    {
      'nombre': 'Reloj Minimalista',
      'precio': 490.00,
      'precioAnterior': 808.0,
      'stock': 'IN STOCK: 12 UNITS',
      'imagen': 'assets/productos/reloj.jpg',
      'tag': 'BOB 1461',
      'color': const Color(0xFF4A7C59),
    },
    {
      'nombre': 'Lámpara Moderna',
      'precio': 350.00,
      'precioAnterior': 600.0,
      'stock': 'IN STOCK: 45 UNITS',
      'imagen': 'assets/productos/lampara.jpg',
      'tag': 'BOB 600',
      'color': const Color(0xFF5B8A6F),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _boliBg,
      body: CustomScrollView(
        slivers: [
          // ── Barra de búsqueda sticky ─────────────────────────────────
          SliverAppBar(
            backgroundColor: _boliBg,
            floating: true,
            snap: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by product name or SKU...',
                      hintStyle: TextStyle(
                        color: _boliGrey,
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(Icons.search, color: _boliGrey, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Lista de productos ───────────────────────────────────────
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _ProductCard(producto: _productos[index]),
              childCount: _productos.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}

// ── Tarjeta de producto ──────────────────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> producto;

  const _ProductCard({required this.producto});

  static const Color _boliBlue  = GlobalVariables.secondaryColor;
  static const Color _boliGrey  = GlobalVariables.unselectedNavBarColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Imagen con tag de precio tachado ──────────────────────
          Stack(
            children: [
              // Imagen
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16)),
                child: Container(
                  height: 220,
                  width: double.infinity,
                  color: producto['color'] as Color,
                  child: Image.asset(
                    producto['imagen'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(Icons.image_outlined,
                          color: Colors.white54, size: 60),
                    ),
                  ),
                ),
              ),
              // Tag precio anterior (esquina superior derecha)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Text(
                    producto['tag'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: _boliGrey,
                      decoration: TextDecoration.lineThrough,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Info del producto ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre
                Text(
                  producto['nombre'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 4),

                // Precio actual
                Text(
                  'BOB ${(producto['precio'] as double).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 8),

                // Stock
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      producto['stock'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Botón Add to Selection
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _boliBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Add to Selection',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Botón Details (secundario)
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _boliBlue,
                      side: const BorderSide(color: _boliBlue, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Details',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}