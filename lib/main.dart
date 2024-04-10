import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/feature/presentation/manager/home/home_bloc.dart';
import 'package:starlight/injection_container.dart';
import 'feature/presentation/manager/home/home_event.dart';
import 'feature/presentation/pages/navigation_page.dart';

Future<void> main() async{
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType){
        return BlocProvider<HomeBloc>(
          create: (context) => sl()
          ..add(YoutubeSearch(word: 'travel')),
          child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              home: NavigationPage()),
        );
      }
    );
  }
}