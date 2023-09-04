import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fiers/Screens/oTPLogin.dart';
import 'package:flutter_fiers/Services/auth_ser.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Data/Cubits/cubits/cubit/pass_cubit.dart';

class LoginAuth extends StatefulWidget {
  final Function()? ontap;
  LoginAuth({super.key, required this.ontap});

  @override
  State<LoginAuth> createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth> with TickerProviderStateMixin {
  late AnimationController _fadelogocontroller;
  @override
  void initState() {
    super.initState();
    _fadelogocontroller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _fadelogocontroller.forward();
  }

  final emailnameController = TextEditingController();
  final passwordController = TextEditingController();
  // final mobilenumberController = TextEditingController();

  double getResponsiveHeight(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.height * percentage;
  }

  double getResponsiveWidth(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.width * percentage;
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert',
                style: GoogleFonts.robotoSlab(
                    color: const Color.fromRGBO(65, 98, 126, 1),
                    fontWeight: FontWeight.w600)),
            content: Text(message,
                style: GoogleFonts.robotoSlab(
                    color: const Color.fromRGBO(65, 98, 126, 1),
                    fontWeight: FontWeight.w600)),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok',
                    style: GoogleFonts.robotoSlab(
                        color: const Color.fromRGBO(65, 98, 126, 1),
                        fontWeight: FontWeight.w600)),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white,
                  Color.fromRGBO(101, 158, 199, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(getResponsiveWidth(0.025, context)),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _fadelogocontroller,
                      child: Image.asset(
                        "lib/Assets/Images/Remove background project (6).png",
                        height: getResponsiveHeight(0.2, context),
                      ),
                    ),
                    SizedBox(
                      height: getResponsiveHeight(0.05, context),
                    ),
                    Text(
                      "Welcome back you've been missed!",
                      style: GoogleFonts.nunito(
                          color: Colors.grey[700],
                          fontSize: getResponsiveHeight(0.02, context)),
                    ),
                    SizedBox(
                      height: getResponsiveHeight(0.03, context),
                    ),
                    TextFormField(
                      controller: emailnameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color.fromRGBO(101, 158, 199, 1),
                        ),
                        suffixIcon: const Icon(
                          Icons.check,
                          color: Color.fromRGBO(101, 158, 199, 1),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getResponsiveHeight(0.01, context),
                    ),
                    BlocBuilder<PassCubit, PassState>(
                      builder: (context, state) {
                        final isVisible = state is PasswordHidden;
                        return TextFormField(
                          controller: passwordController,
                          obscureText: isVisible,
                          decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color.fromRGBO(101, 158, 199, 1),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Color.fromRGBO(101, 158, 199, 1),
                                ),
                                onPressed: () {
                                  context.read<PassCubit>().toggleVisibility();
                                },
                              )),
                        );
                      },
                    ),
                    SizedBox(
                      height: getResponsiveHeight(0.02, context),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        width: 140,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(101, 158, 199, 1),
                            ),
                          ),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: emailnameController.text,
                                      password: passwordController.text);
                              Navigator.pop(context);
                            } on FirebaseAuthException catch (error) {
                              Navigator.pop(context);
                              showErrorMessage(error.code);
                            }
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )),
                    SizedBox(
                      height: getResponsiveHeight(0.01, context),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[500],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getResponsiveHeight(0.03, context),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => AuthService().signInWithGoogle(),
                          child: CircleAvatar(
                            radius: getResponsiveWidth(0.08, context),
                            backgroundImage: const AssetImage(
                                'lib/Assets/Images/download.png'),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    OTPLoginPage(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: getResponsiveWidth(0.08, context),
                            backgroundImage:
                                const AssetImage('lib/Assets/Images/mob.png'),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: getResponsiveHeight(0.1, context),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member?',
                          style:
                              GoogleFonts.robotoSlab(color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.ontap,
                          child: Text(
                            'Register now',
                            style:
                                GoogleFonts.robotoSlab(color: Colors.blue[800]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
