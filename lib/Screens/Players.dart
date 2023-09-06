import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fiers/Data/Cubits/GetPlayers/cubit/get_players_cubit.dart';
import 'package:flutter_fiers/Data/Widgets/drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

class Players extends StatelessWidget {
  final int id;
  Players({super.key, required this.id});
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> players = [];
  List<dynamic> filteredPlayers = [];

  double getResponsiveHeight(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.height * percentage;
  }

  double getResponsiveWidth(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.width * percentage;
  }

  void shareText(String playerName, String teamName) {
    String textToShare = "Name: $playerName\nteam: $teamName";
    Share.share(textToShare);
  }
/*
void shareText() {
    Share.share("islam_hasib");
  }*/

  void filterPlayers(String searchQuery) {
    filteredPlayers = players.where((player) {
      final playerName = player.playerName.toLowerCase();
      final query = searchQuery.toLowerCase();
      return playerName.contains(query);
    }).toList();
  }

  void _showPlayerDetailsDialog(BuildContext context, dynamic player) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    player.playerImage ??
                        "https://st3.depositphotos.com/3581215/18899/v/450/depositphotos_188994514-stock-illustration-vector-illustration-male-silhouette-profile.jpg",
                  ),
                ),
                const SizedBox(height: 5),
                Text(player.playerName ?? " ",
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff41627E))),
                Text("Team: ${player.teamName ?? ""}"),
                Text("Number: ${player.playerNumber ?? ""}"),
                Text("Country: ${player.playerCountry ?? ""}"),
                Text("Position: ${player.playerType ?? ""}"),
                Text("Age: ${player.playerAge ?? ""}"),
                Text("Yellow Cards: ${player.playerYellowCards ?? ""}"),
                Text("Red Cards: ${player.playerRedCards ?? ""}"),
                Text("Goals: ${player.playerGoals ?? ""}"),
                Text("Assists: ${player.playerAssists ?? ""}"),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      shareText(
                          player.playerName ?? " ", player.teamName ?? " ");
                    },
                    icon: const Icon(Icons.share_rounded),
                    label: const Text("Share")),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text("Close"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<GetPlayersCubit>().getPlayers(id);

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
        phoneNumber: "",
      ),
      body: SafeArea(
        child: Stack(
          children: [
            /*    Center(
                child: Container(
              child: IconButton(onPressed: shareText,icon: Icon(Icons.share))
            )),*/
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
                          child: Text("Select Player",
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
                  Padding(
                    padding: EdgeInsets.all(getResponsiveWidth(0.025, context)),
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.all(getResponsiveHeight(0.015, context)),
                        hintText: '  Search player name...',
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Color.fromRGBO(101, 158, 199, 1),
                          ),
                          onPressed: () {
                            filterPlayers(_searchController.text);
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                      height: getResponsiveHeight(
                          0.02, context)), // Responsive spacing
                  BlocBuilder<GetPlayersCubit, GetPlayersState>(
                    builder: (context, state) {
                      if (state is GetPlayersLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is GetPlayersSuccess) {
                        players = state.response.result;
                        final displayedPlayers = _searchController.text.isEmpty
                            ? players
                            : filteredPlayers;
                        return Column(
                          children: [
                            for (int i = 0; i < displayedPlayers.length; i++)
                              GestureDetector(
                                onTap: () {
                                  _showPlayerDetailsDialog(
                                      context, displayedPlayers[i]);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(getResponsiveWidth(
                                      0.025, context)), // Responsive padding
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
                                              displayedPlayers[i].playerImage ??
                                                  "https://st3.depositphotos.com/3581215/18899/v/450/depositphotos_188994514-stock-illustration-vector-illustration-male-silhouette-profile.jpg",
                                            ),
                                          ),
                                          SizedBox(
                                            width: getResponsiveWidth(0.02,
                                                context), // Responsive spacing
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                displayedPlayers[i]
                                                        .playerName ??
                                                    "Unknown",
                                                style: GoogleFonts.robotoSlab(
                                                    fontSize: getResponsiveHeight(
                                                        0.02,
                                                        context), // Responsive font size
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(
                                                        0xff41627E)),
                                                softWrap: true,
                                              ),
                                              Text(
                                                'Position: ${displayedPlayers[i].playerType ?? "Unknown"}',
                                                style: GoogleFonts.robotoSlab(
                                                    fontSize: getResponsiveHeight(
                                                        0.02,
                                                        context), // Responsive font size
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(
                                                        0xff41627E)),
                                                softWrap: true,
                                              ),
                                            ],
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
                            Lottie.asset(
                              'lib/Assets/Images/animation_llw7fh94.json',
                              width: getResponsiveWidth(
                                  0.4, context), // Responsive width
                            ),
                            Text(
                              'An error has occurred',
                              style: GoogleFonts.inter(
                                  color: const Color.fromRGBO(65, 98, 126, 1),
                                  fontWeight: FontWeight.w600),
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
        phoneNumber: "",
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
                          child: Text("Select Player",
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
                    height: getResponsiveHeight(0.02, context),
                  ),
                  Padding(
                    padding: EdgeInsets.all(getResponsiveWidth(0.025, context)),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search player name...',
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Color.fromRGBO(101, 158, 199, 1),
                          ),
                          onPressed: () {
                            filterPlayers(_searchController.text);
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: getResponsiveHeight(0.02, context),
                  ), // Responsive spacing
                  BlocBuilder<GetPlayersCubit, GetPlayersState>(
                    builder: (context, state) {
                      if (state is GetPlayersLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is GetPlayersSuccess) {
                        players = state.response.result;
                        final displayedPlayers = _searchController.text.isEmpty
                            ? players
                            : filteredPlayers;
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: getResponsiveWidth(0.8, context) /
                                getResponsiveHeight(0.35, context),
                          ),
                          itemCount: displayedPlayers.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                _showPlayerDetailsDialog(
                                    context, displayedPlayers[index]);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(getResponsiveWidth(
                                    0.025, context)), // Responsive padding
                                child: Container(
                                  width: getResponsiveWidth(
                                      0.9, context), // Responsive width
                                  height: getResponsiveHeight(
                                      0.15, context), // Responsive height
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
                                          radius: getResponsiveWidth(0.1,
                                              context), // Responsive radius
                                          backgroundImage: NetworkImage(
                                            state.response.result[index]
                                                    .playerImage ??
                                                "https://st3.depositphotos.com/3581215/18899/v/450/depositphotos_188994514-stock-illustration-vector-illustration-male-silhouette-profile.jpg",
                                          ),
                                        ),
                                        // CircleAvatar(
                                        //   child: CachedNetworkImage(
                                        //     imageUrl: state.response.result[index]
                                        //         .playerImage!,
                                        //     errorWidget: (context, url, error) =>
                                        //         Icon(Icons.person,
                                        //             size: getResponsiveWidth(
                                        //               0.1,
                                        //               context,
                                        //             )),
                                        //   ),
                                        // ),
                                        SizedBox(
                                          width: getResponsiveWidth(0.005,
                                              context), // Responsive spacing
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              state.response.result[index]
                                                      .playerName ??
                                                  "Unknown",
                                              style: GoogleFonts.robotoSlab(
                                                  fontSize: getResponsiveHeight(
                                                      0.05,
                                                      context), // Responsive font size
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xff41627E)),
                                              softWrap: true,
                                            ),
                                            Text(
                                              'Position: ${state.response.result[index].playerType ?? "Unknown"}',
                                              style: GoogleFonts.robotoSlab(
                                                  fontSize: getResponsiveHeight(
                                                      0.05,
                                                      context), // Responsive font size
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xff41627E)),
                                              softWrap: true,
                                            ),
                                          ],
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
                                style: GoogleFonts.inter(
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
