import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/core/constants/colors.dart';
import 'package:starlight/feature/presentation/pages/home/home_page.dart';
import 'package:starlight/feature/presentation/pages/home/home_page2.dart';

import '../../../core/constants/icons.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  var bottomNavActiveItems = [userIcon,userIcon,userIcon];
  var bottomNavInActiveItems = [EvaIcons.homeOutline , EvaIcons.bulbOutline, EvaIcons.personOutline];

  var _selected = 0;

  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
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
          controller: pageController,
          children: [
            HomePage(),HomePage2(),HomePage()
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          height: 9.h,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(
              color: navBarShadow.withOpacity(0.65),
              blurRadius: 52,
              offset: Offset(0,2),
              spreadRadius: 0
            )]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(bottomNavActiveItems.length, (index) => GestureDetector(
              onTap: (){
                print(index);
                setState(() {
                  _selected = index;
                  pageController.jumpToPage(_selected);
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer( width: _selected == index ? 26.w : 0, height: _selected == index ? 7.h : 0 ,decoration: BoxDecoration(
                    color: navBarSelected,
                    borderRadius: BorderRadius.all(Radius.circular(48))
                  ), duration: Duration(milliseconds: 70),),
                  Container(
                          width: 32.w,
                          height: 8.h,
                          child: Icon(bottomNavInActiveItems[index],
                          size: 24.sp,
                          color: _selected==index ? Colors.white:Colors.black,))
                ]
              ),
            ))
          ),
        ),
      ),
    );
  }
}
