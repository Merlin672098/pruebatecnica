import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pruebatecnica/interfaceadapters/service/services_roles.dart';
import 'package:pruebatecnica/domain/repository/usuario_repository_impl.dart';
import 'package:pruebatecnica/domain/entities/usuario.dart';
class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({Key? key}) : super(key: key);

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  
  bool _aceptaTerminos = false;
  bool _aceptaPoliticas = false;
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
    
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

  Future<void> _cargarDatosIniciales() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _nombreController.text = user.displayName ?? '';
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header con logo y título
                  _buildHeader(),
                  
                  const SizedBox(height: 32),
                  
                  // Progress indicator
                  _buildProgressIndicator(),
                  
                  const SizedBox(height: 32),
                  
                  // Formulario
                  _buildFormSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Términos y condiciones
                  _buildTerminosModernos(),
                  
                  const SizedBox(height: 32),
                  
                  // Botón continuar
                  _buildContinueButton(),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo con animación
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3450A1), Color(0xFF5B7EC8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3450A1).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.celebration,
            size: 40,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 24),
        
        const Text(
          '¡Bienvenido a Infinity Events!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Completa tu perfil para comenzar',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paso 1 de 2',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: 0.5,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3450A1)),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Información Personal',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Campo Nombre
        _buildModernTextField(
          controller: _nombreController,
          label: 'Nombre Completo',
          icon: Icons.person_outline,
          hint: 'Ej: Juan Pérez',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor ingresa tu nombre';
            }
            if (value.trim().length < 3) {
              return 'El nombre debe tener al menos 3 caracteres';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        // Campo Teléfono
        _buildModernTextField(
          controller: _telefonoController,
          label: 'Teléfono',
          icon: Icons.phone_outlined,
          hint: 'Ej: 70123456',
          keyboardType: TextInputType.phone,
          isOptional: false,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (value.length < 8) {
                return 'El teléfono debe tener al menos 8 dígitos';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    bool isOptional = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            if (isOptional) ...[
              const SizedBox(width: 6),
              Text(
                '(Opcional)',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: const Color(0xFF3450A1), size: 22),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3450A1), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildTerminosModernos() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3450A1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Color(0xFF3450A1),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Acuerdos Legales',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Términos
          _buildCheckboxModerno(
            titulo: 'Términos y Condiciones',
            valor: _aceptaTerminos,
            onChanged: (value) => setState(() => _aceptaTerminos = value ?? false),
            onLeer: () => _mostrarDialogoTerminos(
              'Términos y Condiciones',
              _terminosTexto,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Privacidad
          _buildCheckboxModerno(
            titulo: 'Política de Privacidad',
            valor: _aceptaPoliticas,
            onChanged: (value) => setState(() => _aceptaPoliticas = value ?? false),
            onLeer: () => _mostrarDialogoTerminos(
              'Política de Privacidad',
              _privacidadTexto,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxModerno({
    required String titulo,
    required bool valor,
    required Function(bool?) onChanged,
    required VoidCallback onLeer,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: valor ? const Color(0xFF3450A1) : Colors.grey[300]!,
          width: valor ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(!valor),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Transform.scale(
                  scale: 1.1,
                  child: Checkbox(
                    value: valor,
                    onChanged: onChanged,
                    activeColor: const Color(0xFF3450A1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onLeer,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Leer',
                    style: TextStyle(
                      color: Color(0xFF3450A1),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3450A1), Color(0xFF5B7EC8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3450A1).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _validarYContinuar,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continuar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoTerminos(String titulo, String contenido) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              
              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    contenido,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _validarYContinuar() async {
  if (!_formKey.currentState!.validate()) return;

  if (!_aceptaTerminos) {
    _mostrarSnackbar('Por favor acepta los Términos y Condiciones', Colors.orange);
    return;
  }

  if (!_aceptaPoliticas) {
    _mostrarSnackbar('Por favor acepta la Política de Privacidad', Colors.orange);
    return;
  }

  setState(() => _isLoading = true);

  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    // ── Busca el usuario en .NET por firebaseUid ──
    final repository = UsuarioRepositoryImpl();
    final usuarioActual = await repository.obtenerByFirebaseUid(user.uid);

    if (usuarioActual == null || usuarioActual.idUsuario == null) {
      throw Exception('Usuario no encontrado en el sistema');
    }

    // ── Actualiza nombre en la tabla persona via .NET ──
    final usuarioActualizado = Usuario(
      idUsuario:        usuarioActual.idUsuario,
      usuarioNombre:    _nombreController.text.trim(),
      usuarioEmail:     usuarioActual.usuarioEmail,
      usuarioCondicion: 1,
      idRol:            usuarioActual.idRol,
      firebaseUid:      user.uid,
    );

    final resultado = await repository.modificar(
      usuarioActualizado,
      usuarioActual.idUsuario!,
    );

    if (!resultado) throw Exception('No se pudo actualizar el perfil');

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VerificacionRolWidget(firebaseUid: user.uid),
        ),
      );
    }
  } catch (e) {
    print('Error completando perfil: $e');
    _mostrarSnackbar('Error al guardar los datos. Inténtalo de nuevo.', Colors.red);
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
              color == Colors.red ? Icons.error_outline : Icons.info_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                mensaje,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Textos de términos y condiciones
  final String _terminosTexto = '''TÉRMINOS Y CONDICIONES DE USO - INFINITY EVENTS

Última actualización: Noviembre 2025

Bienvenido/a a la App Infinity Event. Al descargar, acceder o utilizar nuestra aplicación, usted acepta los presentes Términos y Condiciones. Si no está de acuerdo con ellos, le solicitamos no utilizar la aplicación.

1. OBJETO
La aplicación Infinity Event tiene como finalidad ayudar a armar tu evento de forma eficiente, fácil, rápida y garantizada. El presente documento regula las condiciones bajo las cuales los usuarios acceden y utilizan los servicios ofrecidos.

2. ACEPTACIÓN DE LOS TÉRMINOS
El uso de la aplicación implica la aceptación plena y sin reservas de estos Términos y Condiciones, en concordancia con el artículo 519 del Código Civil boliviano, que establece que el contrato es ley entre las partes.

3. REGISTRO DE USUARIO
• Para utilizar ciertas funciones, el usuario deberá registrarse proporcionando información veraz y actualizada.
• El usuario es responsable de mantener la confidencialidad de sus credenciales de acceso.
• Conforme al artículo 452 del Código Civil, el consentimiento debe ser libre y consciente, por lo cual al registrarse se entiende que el usuario acepta voluntariamente estos términos.

4. PAGOS Y POLÍTICA DE NO RETRACTO
• Todos los pagos realizados a través de la aplicación son finales y no reembolsables.
• Una vez confirmado el pago, el usuario no podrá retractarse ni solicitar devolución, salvo en los casos en que la legislación vigente obligue a ello.
• Este principio se enmarca en el artículo 581 del Código Civil, que establece la obligación de cumplir con lo convenido en un contrato.

5. USO PERMITIDO
El usuario se compromete a:
• No utilizar la aplicación para fines ilícitos o no autorizados.
• No manipular, hackear ni alterar el funcionamiento de la aplicación.
• Respetar la propiedad intelectual de la empresa y de terceros.

6. PROPIEDAD INTELECTUAL
Todos los contenidos, logotipos, marcas, diseño y software de la aplicación son propiedad de Infinity Event y están protegidos por las leyes de propiedad intelectual y derechos de autor de Bolivia.

7. LEGISLACIÓN APLICABLE
Estos Términos se rigen por las leyes del Estado Plurinacional de Bolivia.''';

  final String _privacidadTexto = '''POLÍTICA DE PRIVACIDAD - INFINITY EVENTS

Última actualización: Noviembre 2025

La presente Política de Privacidad describe cómo Infinity Event recopila, utiliza y protege la información personal de los usuarios.

1. INFORMACIÓN RECOPILADA
Podemos recopilar:
• Datos de identificación (nombre, correo electrónico, número de teléfono)
• Datos de acceso y uso de la aplicación
• Información de pagos (procesada mediante pasarelas seguras)

2. USO DE LA INFORMACIÓN
La información recopilada se utilizará para:
• Brindar y mejorar los servicios de la aplicación
• Procesar transacciones
• Enviar notificaciones relacionadas con la cuenta o servicios

3. PROTECCIÓN DE DATOS
La empresa implementa medidas de seguridad técnicas y organizativas para proteger la información personal.

4. COMPARTICIÓN DE INFORMACIÓN
Los datos personales no serán compartidos con terceros, salvo:
• Cuando sea necesario para procesar pagos
• Cuando lo exija la ley o una autoridad competente

5. DERECHOS DEL USUARIO
El usuario tiene derecho a:
• Acceder, rectificar o eliminar sus datos personales
• Solicitar la limitación de su tratamiento
• Retirar su consentimiento en cualquier momento

Contacto: infinityeventapp.com''';
}