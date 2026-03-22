import 'package:flutter/material.dart';
import 'package:pruebatecnica/interfaceadapters/service/login_service.dart';
import 'forgot_password_page.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final LoginService _loginService = LoginService();

  bool _isLoading = false;
  bool _isPasswordObscured = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 12,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/logo3.jpeg', height: 100),
                      const SizedBox(height: 24),
                      
                      // --- Campo Email/Usuario ---
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('Email', Icons.email),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return 'Por favor ingresa tu email';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(email)) {
                            return 'Por favor ingresa un email válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // --- Campo Contraseña ---
                      TextFormField(
                        controller: passwordController,
                        obscureText: _isPasswordObscured,
                        decoration: _inputDecoration('Contraseña', Icons.lock).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                              color: const Color(0xFF3450A1),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordObscured = !_isPasswordObscured;
                              });
                            },
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          if (password.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // --- Botón Iniciar Sesión ---
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signInWithEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3450A1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('Iniciar Sesión'),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // --- Enlace ¿Olvidaste tu contraseña? ---
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
                        ),
                        child: const Text(
                          '¿Has olvidado tu contraseña?',
                          style: TextStyle(color: Color(0xFF3450A1)),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      const Text("O inicia sesión con", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),

                      // --- Botón Google Sign In ---
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _signInWithGoogle,
                          icon: _isLoading
                              ? const SizedBox.shrink() // Oculta el icono al cargar
                              : Image.asset('assets/Google__G__logo.png', height: 20),
                          label: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Iniciar sesión con Google'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF3450A1),
                            side: const BorderSide(color: Color(0xFF3450A1)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // --- Enlace Registro ---
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("¿No tienes cuenta?"),
                          TextButton(
                            onPressed: widget.onClickedSignUp,
                            child: const Text(
                              'Regístrate',
                              style: TextStyle(
                                color: Color(0xFF3450A1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),*/
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  // Decoración para los campos de entrada
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF3450A1)),
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF3450A1)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFB0B3B8)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF3450A1), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // Iniciar sesión con email y contraseña
  Future<void> _signInWithEmail() async {
    // Valida el formulario usando la GlobalKey
    /*final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    setState(() => _isLoading = true);

    try {
      await _loginService.signInWithEmailPassword(
        context: context,
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } catch (e) {
      // TODO: Implementar manejo de errores específico para una mejor UX.
      // Por ejemplo, si usas Firebase Auth:
      // if (e is FirebaseAuthException) {
      //   if (e.code == 'user-not-found') {
      //     _showErrorSnackBar('No se encontró un usuario con ese email.');
      //   } else if (e.code == 'wrong-password') {
      //     _showErrorSnackBar('Contraseña incorrecta.');
      //   } else {
      //     _showErrorSnackBar('Ocurrió un error. Inténtalo de nuevo.');
      //   }
      // }
      if (mounted) {
        _showErrorSnackBar('Error al iniciar sesión. Verifica tus credenciales.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }*/
  }

  // Iniciar sesión con Google
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      await _loginService.signInWithGoogle(context: context);
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error al iniciar sesión con Google.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Mostrar mensaje de error
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(10),
        ),
      );
    }
  }
}
