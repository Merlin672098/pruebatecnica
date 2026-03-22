// interfaceadapters/views/services_roles.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pruebatecnica/domain/entities/usuario.dart';
import 'package:pruebatecnica/domain/repository/usuario_repository_impl.dart';
import 'package:pruebatecnica/interfaceadapters/views/bottom_bar.dart';
import 'package:pruebatecnica/interfaceadapters/views/bottom_bar_prov.dart';

class VerificacionRolWidget extends StatefulWidget {
  final String firebaseUid;  // ← viene del login de Google

  const VerificacionRolWidget({Key? key, required this.firebaseUid}) : super(key: key);

  @override
  State<VerificacionRolWidget> createState() => _VerificacionRolWidgetState();
}
class _VerificacionRolWidgetState extends State<VerificacionRolWidget> {
 final _repository = UsuarioRepositoryImpl();
  late Future<Usuario?> _usuarioFuture;
  // Donde navegas a VerificacionRolWidget
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    // FutureBuilder reemplaza al StreamBuilder de Firebase
    _usuarioFuture = _repository.obtenerByFirebaseUid(widget.firebaseUid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Usuario?>(
      future: _usuarioFuture,
      builder: (context, snapshot) {
        // Cargando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Error de conexión
        if (snapshot.hasError) {
          return _buildErrorScreen('Error al conectar con el servidor');
        }

        // Usuario no encontrado
        if (!snapshot.hasData || snapshot.data == null) {
          return _buildErrorScreen('Usuario no encontrado');
        }

        final usuario = snapshot.data!;
        final condicion = usuario.usuarioCondicion;
        final idRol = usuario.idRol;

        // Sin rol asignado → seleccionar rol
        if (idRol == null) {
          return RoleSelectionScreen(
            firebaseUid: widget.firebaseUid,
            repository: _repository,
          );
        }

        // Condicion 0 = inactivo, 2 = suspendido
        if (condicion == 0) {
          return _buildEstadoInactivoScreen('inactivo');
        }
        if (condicion == 2) {
          return _buildEstadoInactivoScreen('suspendido');
        }

        // Condicion 1 = activo → navegar según rol
        if (condicion == 1) {
          if (idRol == 1) {
            return const BottomBar();           // rol cliente
          } else if (idRol == 2) {
            return const BottomBarProveedor();  // rol proveedor
          } else {
            return _buildRolDesconocidoScreen(idRol.toString());
          }
        }

        return _buildErrorScreen('Estado desconocido');
      },
    );
  }

  Widget _buildEstadoInactivoScreen(String estado) {
    String mensaje = estado == 'inactivo'
        ? 'Tu cuenta está inactiva. Contacta al soporte para más información.'
        : 'Tu cuenta ha sido suspendida. Contacta al soporte para más información.';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  estado == 'inactivo' ? Icons.pause_circle_outline : Icons.block,
                  size: 80,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Cuenta ${estado == 'inactivo' ? 'Inactiva' : 'Suspendida'}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Contactar Soporte'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRolDesconocidoScreen(String rol) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.help_outline, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              Text(
                'Rol desconocido: $rol',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Contacta al administrador para resolver este problema.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String mensaje) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber, size: 80, color: Colors.amber),
              const SizedBox(height: 24),
              Text(
                mensaje,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Pantalla de selección de rol — igual que antes
// pero guarda en .NET en vez de Firestore
// ─────────────────────────────────────────────
class RoleSelectionScreen extends StatefulWidget {
  final String firebaseUid;  // ← String en vez de int
  final UsuarioRepositoryImpl repository;

  const RoleSelectionScreen({
    Key? key,
    required this.firebaseUid,
    required this.repository,
  }) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  int? _selectedRolId;      // 1 = cliente, 2 = proveedor
  String? _selectedRolNombre;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 40),
                _buildProgressIndicator(),
                const SizedBox(height: 48),
                const Text(
                  '¿Cómo quieres usar la app?',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Selecciona el rol que mejor se adapte a tus necesidades',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.4),
                ),
                const SizedBox(height: 40),
                _buildRoleOption(
                  rolId: 1,
                  role: 'cliente',
                  title: 'Soy Cliente',
                  subtitle: 'Busco productos en el catálogo',
                  icon: Icons.shopping_bag_outlined,
                  color: const Color(0xFF3450A1),
                  features: ['Ver catálogo de productos', 'Buscar por nombre o SKU', 'Ver precios actualizados'],
                ),
                const SizedBox(height: 20),
                _buildRoleOption(
                  rolId: 2,
                  role: 'proveedor',
                  title: 'Soy Proveedor',
                  subtitle: 'Gestiono precios de productos',
                  icon: Icons.business_center,
                  color: const Color(0xFF10B981),
                  features: ['Actualizar precios', 'Gestionar catálogo', 'Ver stock disponible'],
                ),
                const SizedBox(height: 40),
                _buildContinueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3450A1), Color(0xFF5B7EC8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.inventory_2, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        const Text(
          'Prueba Técnica',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Paso 2 de 2',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700])),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: 1.0,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3450A1)),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleOption({
    required int rolId,
    required String role,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<String> features,
  }) {
    final isSelected = _selectedRolId == rolId;

    return GestureDetector(
      onTap: () => setState(() {
        _selectedRolId = rolId;
        _selectedRolNombre = role;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8))]
              : [],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? color : const Color(0xFF1A1A1A))),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? color : Colors.transparent,
                    border: Border.all(color: isSelected ? color : Colors.grey[400]!, width: 2),
                  ),
                  child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.2), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Características:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
                    const SizedBox(height: 12),
                    ...features.map((feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, size: 18, color: color),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Text(feature,
                                      style: TextStyle(fontSize: 14, color: Colors.grey[700]))),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    final isEnabled = _selectedRolId != null && !_isLoading;

    return AnimatedOpacity(
      opacity: isEnabled ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: isEnabled
              ? const LinearGradient(
                  colors: [Color(0xFF3450A1), Color(0xFF5B7EC8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isEnabled ? null : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
          boxShadow: isEnabled
              ? [BoxShadow(color: const Color(0xFF3450A1).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? _establecerRol : null,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Continuar',
                            style: TextStyle(
                                color: isEnabled ? Colors.white : Colors.grey[600],
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5)),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward,
                            color: isEnabled ? Colors.white : Colors.grey[600], size: 20),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _establecerRol() async {
  if (_selectedRolId == null) return;
  setState(() => _isLoading = true);

  try {
    // Obtienes el usuario real por firebaseUid para sacar su idUsuario (int)
    final usuarioActual =
        await widget.repository.obtenerByFirebaseUid(widget.firebaseUid);

    if (usuarioActual == null || usuarioActual.idUsuario == null) {
      if (mounted) _mostrarSnackbar('Usuario no encontrado', Colors.red);
      return;
    }

    final usuario = Usuario(
      idUsuario:        usuarioActual.idUsuario,
      idRol:            _selectedRolId,
      usuarioCondicion: 1,
    );

    // Ahora sí le pasas el int
    final resultado = await widget.repository.modificar(
      usuario,
      usuarioActual.idUsuario!,  // ← int correcto
    );

    if (resultado && mounted) {
      _mostrarSnackbar('¡Perfil completado exitosamente!', Colors.green);
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => _selectedRolId == 1
                ? const BottomBar()
                : const BottomBarProveedor(),
          ),
        );
      }
    } else {
      if (mounted) _mostrarSnackbar('Error al guardar el rol', Colors.red);
    }
  } catch (e) {
    if (mounted) _mostrarSnackbar('Error inesperado: $e', Colors.red);
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  void _mostrarSnackbar(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.red ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(mensaje, style: const TextStyle(fontSize: 15))),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}