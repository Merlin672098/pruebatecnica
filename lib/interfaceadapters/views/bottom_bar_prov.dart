import 'package:flutter/material.dart';
import 'package:pruebatecnica/interfaceadapters/service/login_service.dart';
import 'package:pruebatecnica/interfaceadapters/views/product/productos_screen.dart';

import '../../constants/global_variables.dart';

class BottomBarProveedor extends StatefulWidget {
  static const String routeName = '/home-proveedor';
  const BottomBarProveedor({Key? key}) : super(key: key);

  @override
  State<BottomBarProveedor> createState() => _BottomBarProveedorState();
}

class _BottomBarProveedorState extends State<BottomBarProveedor> {
  int _page = 0;
  List<Widget>? _pages;
  bool _isLoading = true;
  bool _isDarkMode = false;

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  // Colores dinámicos según el tema
  Color get backgroundColor =>
      _isDarkMode ? const Color(0xFF121212) : Colors.white;
  Color get surfaceColor =>
      _isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5);
  Color get textColor => _isDarkMode ? Colors.white : const Color(0xFF212121);
  Color get textSecondaryColor =>
      _isDarkMode ? Colors.white70 : const Color(0xFF757575);
  Color get accentColor => GlobalVariables.selectedNavBarColor;
  Color get appBarIconColor => _isDarkMode ? Colors.white : Colors.black;

  @override
  void initState() {
    super.initState();
    _initializeWithDelay();
  }

  Future<void> _initializeWithDelay() async {
    await _waitForUserIdInLogs();

    if (mounted) {
      setState(() {
        _pages = [
          ProductosScreen()
          //ServiciosProveedorScreen(onNavigate: updatePage),
          /*SolicitudesRecibidasScreen(onNavigate: updatePage),
          PromocionesProveedorScreen(onNavigate: updatePage),
          AgendaProveedorScreen(onNavigate: updatePage),
          GananciasProveedorScreen(onNavigate: updatePage),
          PerfilProveedorScreen(onNavigate: updatePage),*/
        ];
        _isLoading = false;
      });
      print('✅ BottomBarProveedor: Páginas inicializadas correctamente');
    }
  }

  Future<void> _waitForUserIdInLogs() async {
    await Future.delayed(const Duration(milliseconds: 2000));

    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _pages == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: surfaceColor,
          centerTitle: true,
          title: Text('MarketBo', style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: accentColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Inicializando datos del proveedor...',
                style: TextStyle(
                  color: accentColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'MarketBo - Proveedor',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: appBarIconColor),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: appBarIconColor,
            ),
            onPressed: toggleTheme,
            tooltip: _isDarkMode ? 'Modo claro' : 'Modo oscuro',
          ),
          IconButton(
            icon: Icon(Icons.logout, color: appBarIconColor),
            onPressed: () {
              LoginService().signOut(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: surfaceColor,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    GlobalVariables.secondaryColor,
                    GlobalVariables.secondaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Container(
                    width: 140,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/logo3.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Menú Proveedor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.business_center,
                        color: Colors.white.withOpacity(0.9),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Gestiona tus servicios',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Lista de opciones
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    icon: Icons.work_outline,
                    title: 'Mis Servicios',
                    pageIndex: 0,
                  ),
                  _buildDrawerItem(
                    icon: Icons.mail_outline,
                    title: 'Solicitudes',
                    pageIndex: 1,
                  ),
                  _buildDrawerItem(
                    icon: Icons.local_offer_outlined,
                    title: 'Promociones',
                    pageIndex: 2,
                  ),
                  _buildDrawerItem(
                    icon: Icons.calendar_month_outlined,
                    title: 'Agenda',
                    pageIndex: 3,
                  ),
                  _buildDrawerItem(
                    icon: Icons.monetization_on_outlined,
                    title: 'Ganancias',
                    pageIndex: 4,
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_outline,
                    title: 'Perfil',
                    pageIndex: 5,
                  ),
                ],
              ),
            ),
            // Footer con opciones
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: textColor,
                    ),
                    title: Text(
                      _isDarkMode ? 'Modo claro' : 'Modo oscuro',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Switch(
                      value: _isDarkMode,
                      onChanged: (value) {
                        toggleTheme();
                      },
                      activeColor: accentColor,
                    ),
                    onTap: toggleTheme,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      LoginService().signOut(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _page,
        children: _pages!,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: surfaceColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.work_outline, 'Servicios', 0),
            _buildNavItem(Icons.mail_outline, 'Solicitudes', 1),
            _buildNavItem(Icons.calendar_today_outlined, 'Agenda', 3),
            _buildNavItem(Icons.monetization_on_outlined, 'Ganancias', 4),
            _buildNavItem(Icons.person_outline, 'Perfil', 5),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int pageIndex) {
    final isSelected = _page == pageIndex;
    return InkWell(
      onTap: () => updatePage(pageIndex),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? accentColor
                  : (_isDarkMode ? Colors.white70 : const Color(0xFF757575)),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? accentColor
                    : (_isDarkMode ? Colors.white70 : const Color(0xFF757575)),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int pageIndex,
  }) {
    final isSelected = _page == pageIndex;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? GlobalVariables.secondaryColor.withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? GlobalVariables.secondaryColor
              : GlobalVariables.secondaryColor.withOpacity(0.7),
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? GlobalVariables.secondaryColor : textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: GlobalVariables.secondaryColor,
                size: 20,
              )
            : null,
        onTap: () {
          updatePage(pageIndex);
          Navigator.pop(context);
        },
      ),
    );
  }
}
