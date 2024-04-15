import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/feature/presentation/manager/home/home_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_bloc.dart';
import 'package:starlight/feature/presentation/pages/login/login_page.dart';
import 'package:starlight/injection_container.dart';
import 'feature/presentation/manager/home/home_event.dart';
import 'feature/presentation/manager/navigation_controller.dart';
import 'feature/presentation/pages/navigation_page.dart';

Future<void> main() async {
  await initializeDependencies();
  Get.put(NavigationController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (context) =>
                sl<HomeBloc>()..add(YoutubeSearch(word: 'travel')),
          ),
          BlocProvider<JourneyPlannerBloc>(
            create: (context) =>
            sl<JourneyPlannerBloc>(),
          ),
        ],
        child: GetMaterialApp(
            debugShowCheckedModeBanner: false, home: LoginPage()),
      );
    });
  }
}
