import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/core/constants/colors.dart';
import 'package:starlight/feature/presentation/manager/home/home_bloc.dart';
import 'package:starlight/feature/presentation/manager/home/home_event.dart';
import 'package:starlight/feature/presentation/manager/list_history/list_history_bloc.dart';
import 'package:starlight/feature/presentation/pages/home/home_page.dart';
import 'package:starlight/feature/presentation/pages/list_history/list_history_page.dart';
import 'package:starlight/feature/presentation/pages/profile/profile_page.dart';
import 'package:starlight/feature/presentation/pages/trip/trip_page.dart';

import '../../../core/constants/icons.dart';
import '../../../injection_container.dart';
import '../manager/list_history/list_history_event.dart';
import '../manager/navigation_controller.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  var bottomNavActiveItems = [EvaIcons.home , EvaIcons.bulb, EvaIcons.person];
  var bottomNavInActiveItems = [EvaIcons.homeOutline , EvaIcons.bulbOutline, EvaIcons.personOutline];


  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('leo init');
    pageController = PageController();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final navigationController = Get.find<NavigationController>();
      navigationController.startControl(pageController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: homeAppBar,
      body: Container(
        width: 100.w,
        height: 100.h,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            HomePage(),ListHistoryPage(),ProfilePage()
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(
            color: shadowColor.withOpacity(0.65),
            blurRadius: 52,
            offset: Offset(0,2),
            spreadRadius: 0
          )]
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(bottomNavActiveItems.length, (index) => Obx(
              () => GestureDetector(
                onTap: () async{
                  print(index);
                  if (index==0){
                    setState(() {
                      BlocProvider.of<HomeBloc>(context).add(YoutubeSearch(word: 'Trending Travel Vlog'));
                    });
                  }
                  if(index==1){

                  setState(() {
                    BlocProvider.of<ListHistoryBloc>(context).add(GetListHistory(userId: Get.find<NavigationController>().uid.value));
                  });
                  }

                  pageController.jumpToPage(index);
                  Get.find<NavigationController>().changePage(index);

                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer( width: Get.find<NavigationController>().statePage.value == index ? 24.w : 0, height: Get.find<NavigationController>().statePage.value == index ? 5.h : 0 ,decoration: BoxDecoration(
                      color: navBarSelected,
                      borderRadius: BorderRadius.all(Radius.circular(48))
                    ), duration: Duration(milliseconds: 70),),
                    AnimatedContainer(
                            width: 32.w,
                            height: 5.h,
                            child: Icon(Get.find<NavigationController>().statePage.value==index ?bottomNavActiveItems[index] : bottomNavInActiveItems[index],
                            size: 22.sp,
                            color: Get.find<NavigationController>().statePage.value==index ? Colors.white:Colors.black,)
                        , duration: Duration(milliseconds: 70))
                  ]
                ),
              ),
            ))
          ),
        ),
      ),
    );
  }
}
