import 'package:flutter/material.dart';
import 'package:pruebatecnica/interfaceadapters/views/login/login_screen.dart';
import 'package:pruebatecnica/interfaceadapters/views/login/signup_widget.dart';

//esto no es una vista

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onClickedSignUp: toggle)
    : SignUpWidget(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
