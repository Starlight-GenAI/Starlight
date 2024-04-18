import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight/feature/presentation/manager/home/home_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_summary/journey_summary_bloc.dart';
import 'package:starlight/feature/presentation/manager/list_history/list_history_bloc.dart';
import 'package:starlight/feature/presentation/pages/login/login_page.dart';
import 'package:starlight/injection_container.dart';
import 'core/constants/constants.dart';
import 'feature/presentation/manager/home/home_event.dart';
import 'feature/presentation/manager/list_history/list_history_event.dart';
import 'feature/presentation/manager/navigation_controller.dart';
import 'feature/presentation/pages/navigation_page.dart';
import 'firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDependencies();
  Get.put(NavigationController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> _storeUserData(User? user) async {
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', user.uid);
      await prefs.setString('name', user.displayName ?? "User");
      await prefs.setString('profile', user.photoURL ?? userProfileDefault);

      Get.find<NavigationController>().uid.value = user.uid;
      Get.find<NavigationController>().name.value = user.displayName ?? "User";
      Get.find<NavigationController>().profile.value = user.photoURL ?? userProfileDefault;

    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType){
        return MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>(
              create: (context) =>
              sl<HomeBloc>()..add(YoutubeSearch(word: 'travel Thailand')),
            ),
            BlocProvider<ListHistoryBloc>(
                create: (context) =>
                    sl<ListHistoryBloc>()..add(GetListHistory(userId: Get.find<NavigationController>().uid.value))
            ),
            BlocProvider<JourneyPlannerBloc>(
              create: (context) =>
                  sl<JourneyPlannerBloc>()
            ),
            BlocProvider<JourneySummaryBloc>(create: (context)
                => sl<JourneySummaryBloc>()
            )
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
      }
    );
  }
}