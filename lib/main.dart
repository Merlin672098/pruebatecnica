import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pruebatecnica/interfaceadapters/views/login/auth_page.dart';
import 'package:pruebatecnica/interfaceadapters/views/login/verify_email_page.dart';
import 'package:pruebatecnica/interfaceadapters/views/bottom_bar.dart'; // Agregado para evitar verificación de correo
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(

MyApp(),
  
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  static const String title = 'Firebase Auth';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp.title,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Algo salió mal!'));
            } else if (snapshot.hasData) {
              // TODO: Descomentar cuando se active la verificación de correo
               return VerifyEmailPage();
              //return VerificacionRolWidget(); // Temporal: salta la verificación de correo
            } else {
              return AuthPage();
            }
          },
        ),
      );
}
