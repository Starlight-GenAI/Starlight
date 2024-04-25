import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/core/constants/images.dart';
import 'package:starlight/core/constants/colors.dart';
import 'package:starlight/feature/presentation/pages/home/home_page.dart';
import 'package:starlight/feature/presentation/pages/navigation_page.dart';

import '../../../../core/constants/constants.dart';
import '../../manager/google-auth/google-auth.dart';
import '../../manager/navigation_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FBFE),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(loginGradient),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 5.h,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(logo, width: 2.25.h,),
                      SizedBox(width: 1.8.w,),
                      Text(
                        "Starlight",
                        style: TextStyle(
                            color: Color(0xFF4F4C74),
                            fontFamily: 'Poppins',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h,),
                  Container(
                    width: 80.w,
                    child: Column(
                      children: [
                        Text(
                          "Unlock new horizons with AI Trip Planner",
                          style: TextStyle(
                              color: Color(0xFF15104F),
                              fontFamily: 'Poppins',
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                              height: 1.35
                          ),
                        ),
                        SizedBox(height: 2.h,),
                        Text(
                          "Let Starlight AI transform your videos into personalized trip itineraries seamlessly.",
                          style: TextStyle(
                              color: Color(0xFF4F4C74).withOpacity(0.76),
                              fontFamily: 'Inter',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.17,
                              height: 1.5
                          ),
                        ),
                        SizedBox(height: 3.h,),
                      ],
                    ),
                  ),
                  _loginButton()

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _loginButton() {
    return GestureDetector(
      onTap: () async {
        try {
          var auth = await signInWithGoogle();
          final user = auth.user;
          if (user != null) {
            Get.find<NavigationController>().uid.value = user.uid;
            Get.find<NavigationController>().name.value = user.displayName ?? "User";
            Get.find<NavigationController>().profile.value =
                user.photoURL ?? "";
          }
          Future.delayed(Duration(milliseconds: 300), () {
            Get.offAll(() => NavigationPage(), transition: Transition.rightToLeft);
          });

        } catch (e) {
          // Handle sign-in errors here
          print('Error signing in with Google: $e');
        }
        // Get.to(
        //     transition: Transition.fade,
        //         () => NavigationPage())
      },
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
            color: Color(0xFF4D32F8),
            borderRadius: BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(
              color: Color(0xFF8F98D4).withOpacity(0.19),
                offset: Offset(4,4),
                blurRadius: 20
            )
      ],
        ),
        child: Padding(
          padding:  EdgeInsets.only(top: 4.5.w,bottom: 4.5.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.google, size: 18.sp, color: Colors.white),
              SizedBox(width: 3.w,),
              Text(
                "Login with Google",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.17
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
