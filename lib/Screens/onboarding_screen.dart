import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fiers/Screens/auth_screen.dart';
import 'package:flutter_fiers/Screens/contaniers_onboarding.dart';

import 'package:flutter_fiers/Screens/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageSwapperWidget extends StatefulWidget {
  @override
  _PageSwapperWidgetState createState() => _PageSwapperWidgetState();
}

class _PageSwapperWidgetState extends State<PageSwapperWidget> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final _totalPages = 4;
  List<Widget> _pages = [
    const PageContent(
      imagePath: "lib/Assets/Images/Vector 1.png",
      title: 'Discover Leagues and Teams',
      description:
          'Explore various football leagues and Teams from around the globe. Get fixtures, standings, and match results.',
    ),
    const PageContent(
      imagePath: "lib/Assets/Images/Vector 2.png",
      title: 'Explore Teams and Players',
      description:
          'Learn about basketball teams and players. Get detailed profiles, player stats, transfer news, and match performances',
    ),
    const PageContent(
      imagePath: "lib/Assets/Images/Vector 3.png",
      title: 'Live Match Updates',
      description:
          'Follow  tennis live matches with real-time updates. Get live scores, match highlights, and in-depth analysis during the game',
    ),
    const PageContent(
      imagePath: "lib/Assets/Images/Vector 4.png",
      title: 'Join the Sport Community',
      description:
          'Connect with fellow sport fans. Share your opinions, predictions, and engage in discussions with a passionate community',
    ),
  ];
  @override
  void initState() {
    super.initState();
    hasSeenOnboarding().then((bool hasSeen) {
      if (hasSeen) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Auth()),
        );
      } else {
        // Auto-play pages every 3 seconds
        Timer.periodic(const Duration(seconds: 3), (Timer timer) {
          if (_currentPage < _totalPages - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }
          _pageController.jumpToPage(_currentPage);
        });
      }
    });
    // Auto-play pages every 3 seconds
    //  Timer.periodic(Duration(seconds: 3), (Timer timer) {
    //    if (_currentPage < _totalPages - 1) {
    //      _currentPage++;
    //    } else {
    //      _currentPage = 0;
    //    }
    //    _pageController.jumpToPage(_currentPage);
    // }
    // );
  }

  Future<bool> hasSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  }

  Future<void> markOnboardingAsSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              children: _pages,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
            if (_currentPage != 3)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.93,
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      child: Text(
                        'Skip',
                        style: GoogleFonts.robotoSlab(
                            color: const Color(0xff659EC7)),
                      ),
                      onPressed: () {
                        setState(() {
                          markOnboardingAsSeen();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Auth()),
                          );
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 100),
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.89,
                      alignment: Alignment.bottomCenter,
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: _totalPages,
                        effect: const SlideEffect(
                          activeDotColor: Color(0xff659EC7),
                          dotColor: Colors.grey,
                          dotWidth: 35,
                          dotHeight: 12,
                        ),
                        onDotClicked: (index) {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            if (_currentPage == 3)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.92,
                    alignment: Alignment.bottomCenter,
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: _totalPages,
                      effect: const SlideEffect(
                        activeDotColor: Color(0xff659EC7),
                        dotColor: Colors.grey,
                        dotWidth: 35,
                        dotHeight: 12,
                      ),
                      onDotClicked: (index) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 100),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.93,
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          markOnboardingAsSeen();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Auth()),
                          );
                        });
                      },
                      child: Text('Done',
                          style: GoogleFonts.robotoSlab(
                              color: const Color(0xff659EC7))),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
