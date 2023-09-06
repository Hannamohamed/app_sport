import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fiers/Data/Cubits/cubits/countries_cubit.dart';
import 'package:flutter_fiers/Data/Cubits/GetPlayers/cubit/get_players_cubit.dart';
import 'package:flutter_fiers/Data/Cubits/cubits/cubit/pass_cubit.dart';
import 'package:flutter_fiers/Data/Cubits/cubits/leagues_cubit.dart';
import 'package:flutter_fiers/Data/Cubits/teams_status_cubit/teams_scores_cubit.dart';
import 'package:flutter_fiers/Screens/splashscreen.dart';
import 'package:flutter_fiers/Services/fcm.dart';
import 'package:flutter_fiers/firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@pragma('vm entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  NotificationServices().showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((value) {
      NotificationServices().registerNotification();
      NotificationServices().configLocalNotification();
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetPlayersCubit>(
          create: (BuildContext context) => GetPlayersCubit(),
        ),
        BlocProvider<CountriesCubit>(
          create: (BuildContext context) => CountriesCubit(),
        ),
        BlocProvider<LeaguesCubit>(
          create: (BuildContext context) => LeaguesCubit(),
        ),
        BlocProvider<TeamsScoresCubit>(
          create: (BuildContext context) => TeamsScoresCubit(),
        ),
        BlocProvider<PassCubit>(
          create: (BuildContext context) => PassCubit(),
        ),
      ],
      child: ScreenUtilInit(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(101, 158, 199, 1)),
            useMaterial3: true,
          ),
          home: splashscreen(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
