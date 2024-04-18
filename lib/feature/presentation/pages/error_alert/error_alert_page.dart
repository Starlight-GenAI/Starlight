import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/core/constants/images.dart';
import 'package:starlight/feature/presentation/pages/journey_planner/journey_planner_page.dart';
import 'package:starlight/feature/presentation/pages/navigation_page.dart';

class ErrorAlertPage extends StatefulWidget {
  const ErrorAlertPage({super.key});

  @override
  State<ErrorAlertPage> createState() => _ErrorAlertPageState();
}

class _ErrorAlertPageState extends State<ErrorAlertPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFE),
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(warning, width: 40.w,),
                      SizedBox(height: 2.h,),
                      Text(
                        'Invalid or Unrelated Video link',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.17
                        ),
                      ),
                      SizedBox(height: 1.5.h,),
                      Text(
                        'The video link you provided does not appear to be\nrelated to tourism, or the link is not functional.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF8E8E8E),
                            fontFamily: 'Inter',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.17,
                            height: 1.5
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 3.h,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        _button('Try Again'),
                        GestureDetector(
                          onTap: (){
                            Get.offAll(
                              transition: Transition.leftToRight,
                                () => NavigationPage());
                          },
                          child: Padding(
                            padding: EdgeInsets.all(2.h),
                            child: Text(
                              'Go to home page',
                              style: TextStyle(
                                  color: const Color(0xFF8E8E8E),
                                  fontFamily: 'Inter',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.17
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                )
              ],
            ),
          )
      ),
    );
  }
  _button(text) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        width: 100.w,
        decoration: const BoxDecoration(
            color: Color(0xFF4D32F8),
            borderRadius: BorderRadius.all(Radius.circular(100))
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 4.5.w,bottom: 4.5.w),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 17.sp,
                fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
