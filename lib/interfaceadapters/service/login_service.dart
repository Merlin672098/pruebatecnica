// interfaceadapters/service/login_service.dart
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pruebatecnica/domain/entities/usuario.dart';
import 'package:pruebatecnica/domain/repository/usuario_repository_impl.dart';

class LoginService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle({required BuildContext context}) async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User? firebaseUser = userCredential.user;
    if (firebaseUser == null) throw Exception('Error al autenticar');

    print('✅ Firebase OK - uid: ${firebaseUser.uid}');

    final repository = UsuarioRepositoryImpl();

    try {
      final usuarioExistente =
          await repository.obtenerByFirebaseUid(firebaseUser.uid);

      if (usuarioExistente == null) {
        print('🆕 Creando usuario en .NET...');
        final creado = await repository.create(Usuario(
          firebaseUid:      firebaseUser.uid,
          usuarioEmail:     firebaseUser.email,
          usuarioNombre:    firebaseUser.displayName,
          usuarioCondicion: 1,
        ));
        print('✅ Resultado create: $creado');
      }

      // ← Firebase authStateChanges() detecta el login
      // y main.dart redirige a VerifyEmailPage → VerificacionRolWidget
      // No necesitamos navegar manualmente aquí

    } catch (e) {
      print('❌ Error de red: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se puede conectar al servidor'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

  } catch (e) {
    print('Error Google sign-in: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al iniciar sesión con Google'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

  Future<void> signOut(BuildContext context) async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    // authStateChanges() detecta el logout y redirige a AuthPage
  }
}