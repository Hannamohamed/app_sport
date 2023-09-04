import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fiers/Screens/home.dart';
import 'package:flutter_fiers/Services/auth_ser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPLoginPage extends StatefulWidget {
  @override
  _OTPLoginPageState createState() => _OTPLoginPageState();
}

class _OTPLoginPageState extends State<OTPLoginPage>
    with TickerProviderStateMixin {
  late AnimationController _fadelogocontroller;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _loading = false;
  String generatedOTP = '';
  String generateOTP() {
    final Random random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  @override
  void initState() {
    // Fluttertoast.showToast(msg: "App started");
    super.initState();
    _fadelogocontroller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadelogocontroller.forward();
  }

  double getResponsiveHeight(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.height * percentage;
  }

  double getResponsiveWidth(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.width * percentage;
  }

  void generateAndShowOTP(BuildContext context) {
    generatedOTP = generateOTP();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Generated OTP',
              style: GoogleFonts.robotoSlab(
                  color: const Color.fromRGBO(65, 98, 126, 1),
                  fontWeight: FontWeight.w600)),
          content: Text('Your OTP is: $generatedOTP',
              style: GoogleFonts.robotoSlab(
                  color: const Color.fromRGBO(65, 98, 126, 1),
                  fontWeight: FontWeight.w600)),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _otpController.text = generatedOTP;
              },
            ),
          ],
        );
      },
    );
  }

  void verifyOTP() async {
    print('Verify OTP button pressed');
    final String phoneNumber = _phoneNumberController.text.trim();
    final String enteredOTP = _otpController.text.trim();

    if (phoneNumber.length != 11) {
      Fluttertoast.showToast(msg: 'Please enter a valid 11-digit number.');
      return;
    }

    if (enteredOTP.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter the OTP.');
      return;
    }

    // Set loading state to true.
    setState(() {
      _loading = true;
    });

    // Simulate OTP validation.
    await Future.delayed(
        const Duration(seconds: 3)); // Simulate loading for 3 seconds.

    if (enteredOTP == generatedOTP) {
      // OTP validation successful, navigate to HomeScreen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(), // Navigate to HomeScreen
        ),
      );
    } else {
      // OTP validation failed.
      Fluttertoast.showToast(
        msg: 'OTP validation failed. Please check your OTP.',
      );

      // Reset loading state to false whether validation succeeds or fails.
      setState(() {
        _loading = false;
      });
    }
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
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Mobile number',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.phone,
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
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'OTP',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.code,
                          color: Color.fromRGBO(101, 158, 199, 1),
                        ),
                        suffixIcon: const Icon(
                          Icons.check,
                          color: Color.fromRGBO(101, 158, 199, 1),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getResponsiveHeight(0.015, context),
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
                        onPressed: _loading
                            ? null
                            : () {
                                // Generate and show OTP when the button is pressed.
                                generateAndShowOTP(context);
                              },
                        child: _loading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Generate OTP',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: getResponsiveHeight(0.002, context),
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
                        onPressed: _loading
                            ? null
                            : () {
                                // Verify OTP when the button is pressed.
                                verifyOTP();
                              },
                        child: _loading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Verify OTP',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadelogocontroller.dispose(); // Dispose the animation controller
    super.dispose();
  }
}
