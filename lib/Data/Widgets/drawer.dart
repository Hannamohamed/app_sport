import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fiers/Services/auth_ser.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});
  final user = FirebaseAuth.instance.currentUser!;
  double getResponsiveHeight(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.height * percentage;
  }

  double getResponsiveWidth(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.width * percentage;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
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
                        backgroundImage: NetworkImage(user.photoURL ??
                            "https://i.pinimg.com/564x/43/1a/16/431a164eced527298fea7765edb661c1.jpg"),
                      ),
                      SizedBox(
                        width: getResponsiveHeight(0.01, context),
                      ),
                      Text(
                        user.displayName ?? "User",
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
          // ListTile(
          //   title: Text(
          //     'Item 1',
          //     style: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   onTap: () {
          //     // Handle drawer item 1 tap
          //   },
          // ),
          // ListTile(
          //   title: Text(
          //     'Item 2',
          //     style: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   onTap: () {
          //     // Handle drawer item 2 tap
          //   },
          // ),

          Padding(
            padding: EdgeInsets.all(getResponsiveWidth(0.03, context)),
            child: Column(
              children: [
                SizedBox(
                  height: getResponsiveHeight(0.05, context),
                ),
                Row(
                  children: [
                    Text(
                      'Logged in as:\n' + user.email!,
                      style: GoogleFonts.robotoSlab(
                        color: Colors.grey[600],
                        fontSize: getResponsiveHeight(0.02, context),
                        fontWeight: FontWeight.bold,
                      ),
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
                          Color.fromRGBO(101, 158, 199, 1),
                        ),
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
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
