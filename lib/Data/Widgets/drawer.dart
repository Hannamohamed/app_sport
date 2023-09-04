import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fiers/Screens/auth_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser;

  double getResponsiveHeight(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.height * percentage;
  }

  double getResponsiveWidth(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.width * percentage;
  }

  void handleLogout(BuildContext context) async {
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      // If the user is not logged in, navigate to another screen (e.g., login screen).
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Auth(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(101, 158, 199, 1),
            ),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Your Account',
                        style: GoogleFonts.robotoSlab(
                          color: Colors.white,
                          fontSize: getResponsiveHeight(0.03, context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getResponsiveHeight(0.01, context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(user?.photoURL ??
                            "https://i.pinimg.com/564x/43/1a/16/431a164eced527298fea7765edb661c1.jpg"),
                      ),
                      SizedBox(
                        width: getResponsiveHeight(0.01, context),
                      ),
                      Text(
                        user?.displayName ?? "User",
                        style: GoogleFonts.robotoSlab(
                          color: Colors.grey[800],
                          fontSize: getResponsiveHeight(0.02, context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(getResponsiveWidth(0.03, context)),
            child: Column(
              children: [
                SizedBox(
                  height: getResponsiveHeight(0.05, context),
                ),
                Row(
                  children: [
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: 'Logged in as:\n',
                          style: GoogleFonts.robotoSlab(
                            color: Colors.grey[600],
                            fontSize: getResponsiveHeight(0.02, context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: user?.email ?? "Mobile",
                          style: GoogleFonts.robotoSlab(
                            color: Colors.grey[600],
                            fontSize: getResponsiveHeight(0.02, context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
                SizedBox(
                  height: getResponsiveHeight(0.5, context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(101, 158, 199, 1),
                        ),
                      ),
                      onPressed: () {
                        handleLogout(context);
                      },
                      child: const Text(
                        "LogOut",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
