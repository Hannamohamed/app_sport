import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_fiers/Data/Widgets/drawer.dart';
import 'package:flutter_fiers/Screens/teams.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../Data/Cubits/cubits/leagues_cubit.dart';

class LeagueScreen extends StatelessWidget {
  final int idleague;
  final String phoneNumber;
  const LeagueScreen(
      {super.key, required this.idleague, required this.phoneNumber});
  double getResponsiveHeight(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.height * percentage;
  }

  double getResponsiveWidth(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.width * percentage;
  }

  @override
  Widget build(BuildContext context) {
    context.read<LeaguesCubit>().leagues(idleague);
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return buildPortraitLayout(context);
        } else {
          return buildLandscapeLayout(context);
        }
      },
    );
  }

  Widget buildPortraitLayout(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        phoneNumber: phoneNumber,
      ),
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
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: getResponsiveHeight(
                        0.1, context), // Responsive app bar height
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(15)),
                      color: Color.fromRGBO(101, 158, 199, 1),
                    ),
                    child: Row(
                      children: [
                        Builder(
                          builder: (BuildContext context) {
                            return IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            );
                          },
                        ),
                        Center(
                          child: Text("Select League",
                              style: GoogleFonts.robotoSlab(
                                  fontSize: getResponsiveHeight(
                                      0.03, context), // Responsive font size
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: getResponsiveHeight(
                          0.02, context)), // Responsive spacing
                  BlocBuilder<LeaguesCubit, LeaguesState>(
                    builder: (context, state) {
                      if (state is Loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is Success) {
                        return Column(
                          children: [
                            for (int i = 0;
                                i < state.response.result.length;
                                i++)
                              Padding(
                                padding: EdgeInsets.all(getResponsiveWidth(
                                    0.025, context)), // Responsive padding
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              Duration(milliseconds: 500),
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              FadeTransition(
                                            opacity: animation,
                                            child: TeamsScoresScreen(
                                              phoneNumber: phoneNumber,
                                              id: state
                                                  .response.result[i].leagueKey,
                                              name: state.response.result[i]
                                                  .leagueName,
                                            ),
                                          ),
                                        ));
                                  },
                                  child: Container(
                                    width: getResponsiveWidth(
                                        0.9, context), // Responsive width
                                    height: getResponsiveHeight(
                                        0.14, context), // Responsive height
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          getResponsiveWidth(0.3,
                                              context)), // Responsive radius
                                      color: const Color.fromRGBO(
                                          229, 236, 242, 0.70),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          getResponsiveWidth(0.025,
                                              context)), // Responsive padding
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: getResponsiveWidth(0.1,
                                                context), // Responsive radius
                                            backgroundImage: NetworkImage(
                                              state.response.result[i]
                                                      .leagueLogo ??
                                                  "https://i.pinimg.com/564x/cd/d1/51/cdd151f85578f3d054c37e20baa2dfae.jpg",
                                            ),
                                          ),
                                          SizedBox(
                                            width: getResponsiveWidth(0.02,
                                                context), // Responsive spacing
                                          ),
                                          Text(
                                            state.response.result[i]
                                                    .leagueName ??
                                                "Unknown",
                                            style: GoogleFonts.robotoSlab(
                                                fontSize: getResponsiveHeight(
                                                    0.022,
                                                    context), // Responsive font size
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff41627E)),
                                            softWrap: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Lottie.asset(
                                'lib/Assets/Images/animation_llw7fh94.json',
                                width: getResponsiveWidth(
                                    0.4, context), // Responsive width
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'An error has occurred',
                                style: GoogleFonts.robotoSlab(
                                    color: const Color.fromRGBO(65, 98, 126, 1),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLandscapeLayout(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        phoneNumber: phoneNumber,
      ),
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
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: getResponsiveHeight(
                        0.2, context), // Responsive app bar height
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(15)),
                      color: Color.fromRGBO(101, 158, 199, 1),
                    ),
                    child: Row(
                      children: [
                        Builder(
                          builder: (BuildContext context) {
                            return IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            );
                          },
                        ),
                        Center(
                          child: Text("Select League",
                              style: GoogleFonts.robotoSlab(
                                  fontSize: getResponsiveHeight(
                                      0.05, context), // Responsive font size
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: getResponsiveHeight(
                          0.04, context)), // Responsive spacing
                  BlocBuilder<LeaguesCubit, LeaguesState>(
                    builder: (context, state) {
                      if (state is Loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is Success) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: getResponsiveWidth(0.8, context) /
                                getResponsiveHeight(0.35, context),
                          ),
                          itemCount: state.response.result.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(getResponsiveWidth(
                                  0.025, context)), // Responsive padding
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          TeamsScoresScreen(
                                        phoneNumber: phoneNumber,
                                        id: state
                                            .response.result[index].leagueKey,
                                        name: state
                                            .response.result[index].leagueName,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: getResponsiveWidth(
                                      0.9, context), // Responsive width
                                  height: getResponsiveHeight(
                                      0.3, context), // Responsive height
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        getResponsiveWidth(
                                            0.5, context)), // Responsive radius
                                    color: const Color.fromRGBO(
                                        229, 236, 242, 0.70),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(getResponsiveWidth(
                                        0.025, context)), // Responsive padding
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 50, // Responsive radius
                                          backgroundImage: NetworkImage(
                                            state.response.result[index]
                                                    .leagueLogo ??
                                                "https://i.pinimg.com/564x/cd/d1/51/cdd151f85578f3d054c37e20baa2dfae.jpg",
                                          ),
                                        ),
                                        SizedBox(
                                          width: getResponsiveWidth(0.005,
                                              context), // Responsive spacing
                                        ),
                                        Text(
                                          state.response.result[index]
                                                  .leagueName ??
                                              "Unknown",
                                          style: GoogleFonts.robotoSlab(
                                              fontSize: getResponsiveHeight(
                                                  0.05,
                                                  context), // Responsive font size
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff41627E)),
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Lottie.asset(
                                'lib/Assets/Images/animation_llw7fh94.json',
                                width: getResponsiveWidth(
                                    0.4, context), // Responsive width
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'An error has occurred',
                                style: GoogleFonts.robotoSlab(
                                    color: const Color.fromRGBO(65, 98, 126, 1),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
