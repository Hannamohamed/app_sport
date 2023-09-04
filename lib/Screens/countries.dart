import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_fiers/Data/Cubits/cubits/countries_cubit.dart';
import 'package:flutter_fiers/Data/Widgets/drawer.dart';
import 'package:flutter_fiers/Screens/league.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class CountriesScreen extends StatelessWidget {
  CountriesScreen({super.key});

  TextEditingController locationController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  void jumpToIndex(int index, BuildContext context,
      {ScrollDirection direction = ScrollDirection.forward}) {
    locationController.addListener(() {
      double itemHeight = getResponsiveHeight(0.5, context);
      double offset = index * itemHeight;
      Duration(milliseconds: 500);
      Curves.easeInOut;
      direction;
      _scrollController.jumpTo(offset);
    });
  }

  int k = 0;
  String searchText = '';
  List<dynamic> pOO = [];
  _checkTextAndScroll(pOO, BuildContext context) {
    // Replace this logic with your own condition to check if the text matches an item in the GridView
    locationController.addListener(() {
      int itemIndex = 0;
      for (int i = 0; i < pOO.length; i++) {
        if ('Item $i' == searchText) {
          itemIndex = i;
          k = itemIndex;
          print(itemIndex);
          break;
        }
      }
      // jumpToIndex(itemIndex, context);
      String text = searchText;
      int index = int.tryParse(text) ?? 10;
      {
        jumpToIndex(index, context, direction: ScrollDirection.forward);
      }
    });
  }

  // Future jumpToIndex(int index) async {
  //   _scrollController.animateTo(
  //     index * 70, // replace itemHeight with the height of your list item
  //     duration: Duration(milliseconds: 500),
  //     curve: Curves.easeInOut,
  //   );
  //}
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission; // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show an error message or request the user to enable it.
      return Future.error('Location services are disabled.');
    } // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // The user has permanently denied permission to access the location.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.denied) {
      // The user denied permission, request it
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // The user denied permission again, show an error message or request the user to grant permission from the settings
        return Future.error('Location permissions are denied.');
      }
    } // Get the user's current position
    Position position = await Geolocator
        .getCurrentPosition(); // Reverse geocoding to get the address from coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      String address = placemark.country ?? '';
      searchText = address;
      address += "," + (placemark.locality ?? '');
      address += "," + (placemark.administrativeArea ?? '');
      address += "," + (placemark.street ?? '');
      locationController.text = address;
    } else {
      locationController.text = 'Address not found';
    }
  }

  double getResponsiveHeight(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.height * percentage;
  }

  double getResponsiveWidth(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.width * percentage;
  }

  @override
  Widget build(BuildContext context) {
    context.read<CountriesCubit>().getCountries();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextAndScroll(searchText, context);
      Duration(seconds: 5);
    });
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
                  decoration: BoxDecoration(
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
                            icon: Icon(Icons.menu),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        },
                      ),
                      Center(
                        child: Text(
                          "Select your favorite sport",
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
                      _checkTextAndScroll(pOO, context);
                    },
                    decoration: InputDecoration(
                      hintText: 'Current Location',
                      prefixIcon: GestureDetector(
                        onTap: () {
                          getCurrentLocation();
                          //   String text =searchText;
                          //  int index = int.tryParse(text) ?? -1;
                          //   {

                          //      jumpToIndex(index, context,
                          //         direction: ScrollDirection.forward);
                          // }
                          _checkTextAndScroll(pOO, context);
                        },
                        child: Icon(
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
                BlocBuilder<CountriesCubit, CountriesState>(
                    builder: (context, state) {
                  if (state is CountriesLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is CountriesSuccess) {
                    return Expanded(
                      child: OrientationBuilder(
                        builder: (context, orientation) {
                          return GridView.builder(
                            controller: _scrollController,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  (orientation == Orientation.portrait) ? 2 : 4,
                            ),
                            itemCount: state.response.result.length,
                            itemBuilder: (context, index) {
                              // _scrollController;
                              return InkWell(
                                onTap: () {
                                  // searchText =
                                  //     state.response.result[index].countryName;
                                  _checkTextAndScroll(
                                      state.response.result.length, context);
                                  //jumpToIndex(index);
                                  //  InkWell(
                                  //   onTap: () {
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
                                    color: state.response.result[index]
                                                .countryName ==
                                            searchText
                                        ? Colors.blue
                                        : Colors.white,
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
                                                            Orientation
                                                                .portrait)
                                                        ? 15
                                                        : 15,
                                                    color: Color(0xff41627E),
                                                    fontWeight: FontWeight.w600,
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
                    return Center(
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
