import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fiers/Data/Cubits/cubit/countries_cubit.dart';
import 'package:flutter_fiers/Data/Widgets/drawer.dart';
import 'package:flutter_fiers/Screens/league.dart';
import 'package:google_fonts/google_fonts.dart';

class CountriesScreen extends StatelessWidget {
  const CountriesScreen({super.key});

  double getResponsiveHeight(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.height * percentage;
  }

  double getResponsiveWidth(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.width * percentage;
  }

  @override
  Widget build(BuildContext context) {
    context.read<CountriesCubit>().getCountries();
    return Scaffold(
      drawer: CustomDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
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
            Column(
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
                            icon: Icon(Icons.menu),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        },
                      ),
                      Center(
                        child: Text("Select Country",
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
                  height: getResponsiveHeight(0.02, context),
                ),
                BlocBuilder<CountriesCubit, CountriesState>(
                    builder: (context, state) {
                  if (state is CountriesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is CountriesSuccess) {
                    return Expanded(
                      child: OrientationBuilder(
                        builder: (context, orientation) {
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  (orientation == Orientation.portrait) ? 2 : 4,
                            ),
                            itemCount: state.response.result.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            LeagueScreen(
                                          idleague: state.response.result[index]
                                              .countryKey,
                                        ),
                                      ));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(
                                      getResponsiveWidth(0.02, context)),
                                  width: (orientation == Orientation.portrait)
                                      ? getResponsiveWidth(0.3, context)
                                      : getResponsiveWidth(0.16, context),
                                  height: (orientation == Orientation.portrait)
                                      ? getResponsiveHeight(0.3, context)
                                      : getResponsiveHeight(0.5, context),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        getResponsiveWidth(0.15, context)),
                                    color: const Color(0xffe5ecf2),
                                  ),
                                  child: Stack(children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                                height: (orientation ==
                                                        Orientation.portrait)
                                                    ? getResponsiveHeight(
                                                        0.05, context)
                                                    : getResponsiveHeight(
                                                        0.05, context)),
                                            Container(
                                              width: (orientation ==
                                                      Orientation.portrait)
                                                  ? getResponsiveWidth(
                                                      0.208, context)
                                                  : getResponsiveWidth(
                                                      0.1, context),
                                              height: (orientation ==
                                                      Orientation.portrait)
                                                  ? getResponsiveHeight(
                                                      0.09375, context)
                                                  : getResponsiveHeight(
                                                      0.19, context),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular((orientation ==
                                                            Orientation
                                                                .portrait)
                                                        ? getResponsiveWidth(
                                                            0.208 / 2, context)
                                                        : getResponsiveHeight(
                                                            0.1, context)),
                                                image: DecorationImage(
                                                  image: NetworkImage(state
                                                          .response
                                                          .result[index]
                                                          .countryLogo ??
                                                      ''),
                                                  fit: (orientation ==
                                                          Orientation.portrait)
                                                      ? BoxFit.fitHeight
                                                      : BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: getResponsiveHeight(
                                                    0.015, context)),
                                            Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                state.response.result[index]
                                                        .countryName ??
                                                    '',
                                                style: GoogleFonts.robotoSlab(
                                                  fontSize: (orientation ==
                                                          Orientation.portrait)
                                                      ? 20
                                                      : 18,
                                                  color:
                                                      const Color(0xff41627E),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  }
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}
