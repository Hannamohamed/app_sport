import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fiers/Screens/login_or_register.dart';
import 'package:flutter_fiers/Screens/countries.dart';

import 'package:flutter_fiers/Screens/loginscreen.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //User is Logged in
          if (snapshot.hasData) {
            return CountriesScreen();
          }

          //User is not Logged in
          else {
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}
