import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            child: Text(
              'Drawer Header',
              style: GoogleFonts.robotoSlab(
                color: Colors.white,
                fontSize: getResponsiveHeight(0.03, context),
                fontWeight: FontWeight.bold,
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
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Loged in as:   ' + user.email!,
                      style: GoogleFonts.robotoSlab(
                        color: Colors.grey[700],
                        fontSize: getResponsiveHeight(0.02, context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getResponsiveHeight(0.01, context),
                ),
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
          ),
        ],
      ),
    );
  }
}
