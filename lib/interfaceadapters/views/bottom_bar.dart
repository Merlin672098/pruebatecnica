import 'package:flutter/material.dart';
import 'package:pruebatecnica/interfaceadapters/views/cliente/dasboard/dashboard_screen.dart';
import '../../constants/global_variables.dart';
import '../service/login_service.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  List<Widget> get _pages => [
        DashboardClienteScreen(onNavigate: updatePage),
      ];

  // ── Paleta BoliShop ──────────────────────────────────────────────────────
  static const Color _boliBlue    = GlobalVariables.secondaryColor;      // #3450A1
  static const Color _boliWhite   = GlobalVariables.appBarColor;         // blanco
  static const Color _boliSurface = GlobalVariables.greyBackgroundCOlor; // #EAF1FB
  static const Color _boliBg      = GlobalVariables.backgroundColor;     // #F5F7FA
  static const Color _boliActive  = GlobalVariables.selectedNavBarColor; // negro
  static const Color _boliGrey    = GlobalVariables.unselectedNavBarColor;// blueGrey

  // ── Nav item ─────────────────────────────────────────────────────────────
  Widget _buildNavItem(IconData icon, String label, int pageIndex) {
    final isSelected = _page == pageIndex;
    return InkWell(
      onTap: () => updatePage(pageIndex),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        decoration: isSelected
            ? BoxDecoration(
                color: _boliBlue.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? _boliBlue : _boliGrey,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? _boliBlue : _boliGrey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Drawer item ──────────────────────────────────────────────────────────
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int pageIndex,
  }) {
    final isSelected = _page == pageIndex;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? _boliBlue.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? _boliBlue : _boliActive),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? _boliBlue : _boliActive,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: _boliBlue, size: 20)
            : null,
        onTap: () {
          updatePage(pageIndex);
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildDrawerNavigationItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(icon, color: _boliActive),
        title: Text(title,
            style: const TextStyle(
                color: _boliActive, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: _boliGrey),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _boliBg,
      appBar: AppBar(
        backgroundColor: _boliWhite,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'BoliShop',
          style: TextStyle(
            color: _boliBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: _boliActive),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: _boliActive),
            onPressed: () => LoginService().signOut(context),
          ),
        ],
      ),

      // ── Drawer ──────────────────────────────────────────────────────────
      drawer: Drawer(
        backgroundColor: _boliWhite,
        child: Column(
          children: [
            // Header con gradiente azul BoliShop
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _boliBlue,
                    _boliBlue.withOpacity(0.75),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      child: Image.asset('assets/logo3.jpeg',
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'BoliShop',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tu marketplace boliviano de confianza',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.88),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Ítems de navegación
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                      icon: Icons.storefront_outlined,
                      title: 'Marketplace',
                      pageIndex: 0),
                  _buildDrawerItem(
                      icon: Icons.dashboard_outlined,
                      title: 'Dashboard',
                      pageIndex: 1),
                  _buildDrawerItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Mis Pedidos',
                      pageIndex: 2),
                  _buildDrawerItem(
                      icon: Icons.favorite_border,
                      title: 'Favoritos',
                      pageIndex: 3),
                  _buildDrawerItem(
                      icon: Icons.person_outline,
                      title: 'Perfil',
                      pageIndex: 4),
                  const Divider(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    child: Text(
                      'Más opciones',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _boliGrey,
                      ),
                    ),
                  ),
                  _buildDrawerNavigationItem(
                    icon: Icons.local_offer_outlined,
                    title: 'Ofertas',
                    onTap: () {},
                  ),
                  _buildDrawerNavigationItem(
                    icon: Icons.support_agent_outlined,
                    title: 'Soporte',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Footer solo con logout
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.all(16),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w600),
                ),
                onTap: () => LoginService().signOut(context),
              ),
            ),
          ],
        ),
      ),

      body: IndexedStack(index: _page, children: _pages),

      // ── Bottom Navigation Bar ────────────────────────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _boliWhite,
          boxShadow: [
            BoxShadow(
              color: _boliBlue.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.storefront_outlined, 'Marketplace', 0),
                _buildNavItem(Icons.dashboard_outlined, 'Dashboard', 1),
                _buildNavItem(Icons.shopping_bag_outlined, 'Pedidos', 2),
                _buildNavItem(Icons.favorite_border, 'Favoritos', 3),
                _buildNavItem(Icons.person_outline, 'Perfil', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}