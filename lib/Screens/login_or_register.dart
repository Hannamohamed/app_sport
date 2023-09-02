import 'package:flutter/material.dart';
import 'package:flutter_fiers/Screens/registerscreen.dart';
import 'package:flutter_fiers/Screens/loginscreen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginAuth(
        ontap: togglePages,
      );
    } else {
      return RegisterPage(
        ontap: togglePages,
      );
    }
  }
}
