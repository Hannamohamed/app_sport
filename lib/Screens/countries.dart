import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fiers/Data/Cubits/cubits/countries_cubit.dart';
import 'package:flutter_fiers/Data/Widgets/drawer.dart';
import 'package:flutter_fiers/Screens/league.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class CountriesScreen extends StatefulWidget {
  final String phoneNumber;
  const CountriesScreen({Key? key, required this.phoneNumber})
      : super(key: key);
  @override
  CountryState createState() => CountryState();
}

class CountryState extends State<CountriesScreen> {
  TextEditingController locationController = TextEditingController();
  ScrollController scrollController = ScrollController();

  String searchText = '';
  List<dynamic> countries = [];

  @override
  void initState() {
    super.initState();
    // Fetch countries using the CountriesCubit
    context.read<CountriesCubit>().getCountries();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }
    Position position = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      String address = placemark.country ?? '';
      searchText = address;
      address += "," + (placemark.administrativeArea ?? '');
      address += "," + (placemark.locality ?? '');
      address += "," + (placemark.street ?? '');
      locationController.text = address;

      // Scroll to the country of the current location
      _checkTextAndScroll(countries, context);
    } else {
      locationController.text = 'Address not found';
    }
  }

  void _checkTextAndScroll(List<dynamic> countries, BuildContext context) {
    int itemIndex = 0;
    for (int i = 0; i < countries.length; i++) {
      if (countries[i].countryName == searchText) {
        itemIndex = i;
        break;
      }
    }

    // Determine the screen height based on orientation
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate itemHeight proportionally to screen height
    double itemHeight;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      itemHeight = screenHeight * 0.115;
    } else {
      // Use a different proportion for landscape mode, adjust as needed
      itemHeight = screenHeight * 0.136;
    }

    double offset = itemIndex * itemHeight;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  double getResponsiveHeight(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.height * percentage;
  }

  double getResponsiveWidth(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.width * percentage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        phoneNumber: widget.phoneNumber,
      ),
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
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        child: Text(
                          "Select Country",
                          style: GoogleFonts.robotoSlab(
                              fontSize: getResponsiveHeight(
                                  0.03, context), // Responsive font size
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getResponsiveHeight(0.02, context),
                ),
                Padding(
                  padding: EdgeInsets.all(getResponsiveWidth(0.025, context)),
                  child: TextField(
                    controller: locationController,
                    readOnly: true,
                    onChanged: (value) {
                      searchText = value;
                      _checkTextAndScroll(countries, context);
                    },
                    decoration: InputDecoration(
                      hintText: 'Current Location',
                      contentPadding:
                          EdgeInsets.all(getResponsiveHeight(0.015, context)),
                      prefixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            getCurrentLocation();
                          });
                        },
                        child: const Icon(
                          Icons.location_on,
                          color: Color.fromRGBO(101, 158, 199, 1),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getResponsiveHeight(0.02, context),
                ),
                // BlocBuilder to get the list of countries
                BlocBuilder<CountriesCubit, CountriesState>(
                  builder: (context, state) {
                    if (state is CountriesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is CountriesSuccess) {
                      // Update the 'countries' list when data is available
                      countries = state.response.result;
                      return Expanded(
                        child: OrientationBuilder(
                          builder: (context, orientation) {
                            return GridView.builder(
                              controller: scrollController,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    (orientation == Orientation.portrait)
                                        ? 2
                                        : 4,
                              ),
                              itemCount: countries.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    searchText = countries[index].countryName;
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              Duration(milliseconds: 500),
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              FadeTransition(
                                            opacity: animation,
                                            child: LeagueScreen(
                                              phoneNumber: widget.phoneNumber,
                                              idleague:
                                                  countries[index].countryKey,
                                            ),
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
                                    height:
                                        (orientation == Orientation.portrait)
                                            ? getResponsiveHeight(0.3, context)
                                            : getResponsiveHeight(0.5, context),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          getResponsiveWidth(0.15, context)),
                                      color: state.response.result[index]
                                                  .countryName ==
                                              searchText
                                          ? const Color.fromRGBO(
                                              101, 158, 199, 1)
                                          : const Color.fromRGBO(
                                              229, 236, 242, 0.70),
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
                                                              0.208 / 2,
                                                              context)
                                                          : getResponsiveHeight(
                                                              0.1, context)),
                                                  image: DecorationImage(
                                                    image: NetworkImage(state
                                                            .response
                                                            .result[index]
                                                            .countryLogo ??
                                                        ''),
                                                    fit: (orientation ==
                                                            Orientation
                                                                .portrait)
                                                        ? BoxFit.fitHeight
                                                        : BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: getResponsiveHeight(
                                                      0.01, context)),
                                              Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    state.response.result[index]
                                                            .countryName ??
                                                        '',
                                                    style:
                                                        GoogleFonts.robotoSlab(
                                                      fontSize: (orientation ==
                                                              Orientation
                                                                  .portrait)
                                                          ? getResponsiveWidth(
                                                              0.04, context)
                                                          : getResponsiveHeight(
                                                              0.05, context),
                                                      color: state
                                                                  .response
                                                                  .result[index]
                                                                  .countryName ==
                                                              searchText
                                                          ? Colors.white
                                                          : const Color(
                                                              0xff41627E),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )),
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
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
