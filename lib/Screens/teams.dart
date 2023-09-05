import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fiers/Data/Cubits/teams_status_cubit/teams_scores_cubit.dart';
import 'package:flutter_fiers/Data/Widgets/drawer.dart';
import 'package:flutter_fiers/Screens/Players.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

final TextEditingController search = TextEditingController();

class TeamsScoresScreen extends StatefulWidget {
  final int id;
  final String? name;
  const TeamsScoresScreen({super.key, required this.id, required this.name});

  @override
  State<TeamsScoresScreen> createState() => _TeamsScoresScreen();
}

class _TeamsScoresScreen extends State<TeamsScoresScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  double getResponsiveHeight(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.height * percentage;
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
    super.initState();
    context.read<TeamsScoresCubit>().getTeam(widget.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    search.clear();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.index == 0) {
      // Handle home tab press action
    } else if (_tabController.index == 1) {
      // Perform action for the second tab
      search.text = "";
      context.read<TeamsScoresCubit>().getTopScorers(widget.id);
    }
  }

  void _searchTeam() {
    final searchTerm = search.text;
    context.read<TeamsScoresCubit>().searchTeams(searchTerm, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamsScoresCubit, TeamsScoresState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            drawer: CustomDrawer(
              phoneNumber: "",
            ),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color.fromRGBO(101, 158, 199, 1),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Container(
                  color: const Color.fromRGBO(101, 158, 199, 1),
                  child: TabBar(
                    indicatorColor: Colors.white,
                    dividerColor: const Color.fromRGBO(101, 158, 199, 1),
                    indicatorSize: TabBarIndicatorSize.label,
                    controller: _tabController,
                    tabs: [
                      Tab(
                        child: Text(
                          "Teams",
                          style: GoogleFonts.robotoSlab(
                            color: (state is TeamsScoresTeams)
                                ? Colors.white
                                : const Color.fromARGB(255, 240, 240, 240),
                            fontSize: 20.sp,
                            fontWeight: (state is TeamsScoresTeams)
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Top Scorer",
                          style: GoogleFonts.robotoSlab(
                            color: (state is TeamsScoresTopScorers)
                                ? Colors.white
                                : const Color.fromARGB(255, 240, 240, 240),
                            fontSize: 18.sp,
                            fontWeight: (state is TeamsScoresTopScorers)
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                    onTap: (index) {
                      if (index == 0) {
                        context.read<TeamsScoresCubit>().getTeam(widget.id);
                      } else if (index == 1) {
                        search.text = "";
                        context
                            .read<TeamsScoresCubit>()
                            .getTopScorers(widget.id);
                      }
                    },
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(15),
                  ),
                  child: Container(
                    height: 15,
                    color: const Color.fromRGBO(101, 158, 199, 1),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 15,
                              ),
                              height: ScreenUtil().screenHeight * 0.8,
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
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  FadeTransition(
                                    opacity: _animation,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: getResponsiveHeight(
                                                0.008, context),
                                            bottom: getResponsiveHeight(
                                                0.01, context),
                                          ),
                                          child: TextFormField(
                                            controller: search,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.all(
                                                  getResponsiveHeight(
                                                      0.015, context)),
                                              hintText: 'Search team name...',
                                              suffixIcon: IconButton(
                                                icon: const Icon(
                                                  Icons.search,
                                                  color: Color.fromRGBO(
                                                      101, 158, 199, 1),
                                                ),
                                                onPressed: _searchTeam,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        if (state is TeamsScoresTeams &&
                                            state.ourresponse.result != null)
                                          Expanded(
                                            child: GridView.count(
                                              crossAxisCount: ScreenUtil()
                                                              .screenWidth >
                                                          600 &&
                                                      ScreenUtil()
                                                              .orientation ==
                                                          Orientation.landscape
                                                  ? 4
                                                  : 2,
                                              crossAxisSpacing:
                                                  ScreenUtil().screenWidth *
                                                      0.04,
                                              mainAxisSpacing:
                                                  ScreenUtil().screenWidth *
                                                      0.04,
                                              children: List.generate(
                                                state
                                                    .ourresponse.result!.length,
                                                (index) {
                                                  if (state
                                                              .ourresponse
                                                              .result![index]
                                                              .teamName !=
                                                          null &&
                                                      state
                                                              .ourresponse
                                                              .result![index]
                                                              .teamLogo !=
                                                          null) {
                                                    return Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.04),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                PageRouteBuilder(
                                                                  transitionDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              500),
                                                                  pageBuilder: (context,
                                                                          animation,
                                                                          secondaryAnimation) =>
                                                                      FadeTransition(
                                                                    opacity:
                                                                        animation,
                                                                    child:
                                                                        Players(
                                                                      id: state
                                                                          .ourresponse
                                                                          .result![
                                                                              index]
                                                                          .teamKey!,
                                                                    ),
                                                                  ),
                                                                ));
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          55.0),
                                                              color: const Color
                                                                  .fromRGBO(
                                                                  229,
                                                                  236,
                                                                  242,
                                                                  0.70),
                                                            ),
                                                            child: Center(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      top: 30,
                                                                      right: 20,
                                                                      left: 20,
                                                                      bottom:
                                                                          10,
                                                                    ),
                                                                    child:
                                                                        CircleAvatar(
                                                                      radius: (getResponsiveHeight(
                                                                          0.045,
                                                                          context)),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        imageUrl: state
                                                                            .ourresponse
                                                                            .result![index]
                                                                            .teamLogo!,
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            const Icon(
                                                                          Icons
                                                                              .person,
                                                                          size:
                                                                              85,
                                                                          color: Color.fromRGBO(
                                                                              65,
                                                                              98,
                                                                              126,
                                                                              1),
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    state
                                                                        .ourresponse
                                                                        .result![
                                                                            index]
                                                                        .teamName!,
                                                                    style: GoogleFonts
                                                                        .robotoSlab(
                                                                      color: const Color(
                                                                          0xff41627E),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize: getResponsiveHeight(
                                                                          0.019,
                                                                          context),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return const Text('');
                                                  }
                                                },
                                              ),
                                            ),
                                          )
                                        else if (search.text != '')
                                          Column(
                                            children: [
                                              Lottie.asset(
                                                'lib/Assets/Images/not_found_animation.json',
                                                width: 200.w,
                                                height: 100.h,
                                              ),
                                              Text(
                                                'Team not found',
                                                style: GoogleFonts.quicksand(
                                                  fontSize: 16.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          )
                                        else
                                          const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                      ],
                                    ),
                                  ),
                                  if (state is TeamsScoresTopScorers)
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          for (int i = 0;
                                              i < state.response.result.length;
                                              i++)
                                            if (state.response.result[i]
                                                        .playerName !=
                                                    null &&
                                                state.response.result[i]
                                                        .teamName !=
                                                    null &&
                                                state.response.result[i]
                                                        .goals !=
                                                    null)
                                              FadeTransition(
                                                opacity: _animation,
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 15),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 10,
                                                    horizontal: 15,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                    color: Colors.white60,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            const Color
                                                                .fromRGBO(101,
                                                                158, 199, 1),
                                                        radius: ScreenUtil()
                                                                    .orientation ==
                                                                Orientation
                                                                    .landscape
                                                            ? ScreenUtil()
                                                                    .screenWidth *
                                                                0.05
                                                            : ScreenUtil()
                                                                    .screenHeight *
                                                                0.03,
                                                        child: Text(
                                                          '${i + 1}',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .robotoSlab(
                                                            fontSize: 17.sp,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 20.w),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              state
                                                                  .response
                                                                  .result[i]
                                                                  .playerName!,
                                                              style: GoogleFonts
                                                                  .robotoSlab(
                                                                fontSize: 18.sp,
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    101,
                                                                    158,
                                                                    199,
                                                                    1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 10.h),
                                                            SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Team Name: ",
                                                                    style: GoogleFonts
                                                                        .robotoSlab(
                                                                      fontSize:
                                                                          14.sp,
                                                                      color: const Color
                                                                          .fromRGBO(
                                                                          101,
                                                                          158,
                                                                          199,
                                                                          1),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    state
                                                                        .response
                                                                        .result[
                                                                            i]
                                                                        .teamName!,
                                                                    style: GoogleFonts
                                                                        .robotoSlab(
                                                                      fontSize:
                                                                          14.sp,
                                                                      color: const Color
                                                                          .fromRGBO(
                                                                          101,
                                                                          158,
                                                                          199,
                                                                          1),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Goals: ",
                                                                  style: GoogleFonts
                                                                      .robotoSlab(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: const Color
                                                                        .fromRGBO(
                                                                        101,
                                                                        158,
                                                                        199,
                                                                        1),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${state.response.result[i].goals!}",
                                                                  style: GoogleFonts
                                                                      .robotoSlab(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: const Color
                                                                        .fromRGBO(
                                                                        101,
                                                                        158,
                                                                        199,
                                                                        1),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            else
                                              const Text(
                                                  "Something went wrong"),
                                        ],
                                      ),
                                    )
                                  else
                                    const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
