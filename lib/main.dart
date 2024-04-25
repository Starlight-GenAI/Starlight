import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight/feature/presentation/manager/home/home_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_summary/journey_summary_bloc.dart';
import 'package:starlight/feature/presentation/manager/list_history/list_history_bloc.dart';
import 'package:starlight/feature/presentation/manager/trip_planner/trip_planner_bloc.dart';
import 'package:starlight/feature/presentation/pages/login/login_page.dart';
import 'package:starlight/injection_container.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'core/constants/constants.dart';
import 'feature/presentation/manager/home/home_event.dart';
import 'feature/presentation/manager/journey_highlight/journey_highlight_bloc.dart';
import 'feature/presentation/manager/list_history/list_history_event.dart';
import 'feature/presentation/manager/navigation_controller.dart';
import 'feature/presentation/pages/journey_planner/journey_planner_page.dart';
import 'feature/presentation/pages/navigation_page.dart';
import 'firebase_options.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as page;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDependencies();
  Get.put(NavigationController(), permanent: true);

  runApp(const StarlightApp());
}

class StarlightApp extends StatefulWidget {
  const StarlightApp({super.key});

  @override
  State<StarlightApp> createState() => _StarlightAppState();
}

class _StarlightAppState extends State<StarlightApp> {
  late StreamSubscription _intentSub;
  List<SharedMediaFile>_sharedFiles = [];

  Future<void> _storeUserData(User? user) async {
    if (user != null) {
      Get.find<NavigationController>().uid.value = user.uid;
      Get.find<NavigationController>().name.value = user.displayName ?? "User";
      Get.find<NavigationController>().profile.value =
          user.photoURL ?? "";
    }
  }


  @override
  void initState() {
    super.initState();
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) async {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
      });
      var token = await GoogleSignIn().isSignedIn();
      if ((_sharedFiles.first.type == SharedMediaType.text || _sharedFiles.first.type == SharedMediaType.url) && (_sharedFiles.first.path.contains('youtube') || _sharedFiles.first.path.contains("youtu.be")) && token ){
        Get.offAll(
            () => NavigationPage(),
          duration: Duration(milliseconds: 0)
        );
        Get.to(
            transition: page.Transition.rightToLeft,
            arguments: YoutubePlayer.convertUrlToId(_sharedFiles.first.path),
                () => JourneyPlannerPage());
      }
    }, onError: (err) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (context) =>
                sl<HomeBloc>()..add(YoutubeSearch(word: 'travel Thailand')),
          ),
          BlocProvider<ListHistoryBloc>(
              create: (context) => sl<ListHistoryBloc>()
                ..add(GetListHistory(
                    userId: Get.find<NavigationController>().uid.value))),
          BlocProvider<JourneyPlannerBloc>(
              create: (context) => sl<JourneyPlannerBloc>()),
          BlocProvider<JourneySummaryBloc>(
              create: (context) => sl<JourneySummaryBloc>()),
          BlocProvider<JourneyHighlightBloc>(
              create: (context) => sl<JourneyHighlightBloc>()),
          BlocProvider<TripPlannerBloc>(
              create: (context) => sl<TripPlannerBloc>())
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                if (snapshot.hasData) {
                  final user = snapshot.data;
                  _storeUserData(user);
                  return NavigationPage();
                } else {
                  return LoginPage();
                }
              }
            },
          ),
        ),
      );
    });
  }
}
