import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fiers/Services/auth_ser.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  final Function()? ontap;
  RegisterPage({super.key, required this.ontap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
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
  final confirmPasswordController = TextEditingController();
  // final mobilenumberController = TextEditingController();

  double getResponsiveHeight(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.height * percentage;
  }

  double getResponsiveWidth(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.width * percentage;
  }

  void showErrorMessages(String message) {
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
                      "Let's create an acount for you!",
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
                          borderRadius: BorderRadius.circular(25.0),
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
                    TextFormField(
                      controller: passwordController,
                      // validator: ,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color.fromRGBO(101, 158, 199, 1),
                        ),
                        suffixIcon: const Icon(
                          Icons.visibility_off,
                          color: Color.fromRGBO(101, 158, 199, 1),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getResponsiveHeight(0.01, context),
                    ),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_open,
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
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        width: 140,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(101, 158, 199, 1),
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
                              if (passwordController.text ==
                                  confirmPasswordController.text) {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: emailnameController.text,
                                        password: passwordController.text);
                              } else {
                                showErrorMessages("Passwords don't match!");
                              }
                              Navigator.pop(context);
                            } on FirebaseAuthException catch (error) {
                              Navigator.pop(context);
                              showErrorMessages(error.code);
                            }
                          },
                          child: const Text(
                            "Sign up",
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
                            padding: EdgeInsets.all(8.0),
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
                            backgroundImage:
                                AssetImage('lib/Assets/Images/download.png'),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: getResponsiveHeight(0.06, context),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style:
                              GoogleFonts.robotoSlab(color: Colors.grey[700]),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.ontap,
                          child: Text(
                            'Login now',
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
