import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/core/constants/images.dart';

import '../../../../core/constants/colors.dart';

class JourneyPlannerModalSubmit extends StatefulWidget {
  @override
  _JourneyPlannerModalSubmitState createState() => _JourneyPlannerModalSubmitState();
}

class _JourneyPlannerModalSubmitState extends State<JourneyPlannerModalSubmit> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // height: 70.h,
          decoration: const BoxDecoration(
            color: Color(0xFFF9FBFE),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            )
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Select Mode for Generate Trip",
                      style: TextStyle(
                          color: Color(0xFF15104F),
                          fontFamily: 'Poppins',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.17
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.w),
                      child: Column(
                        children: [
                          _buttonBanner('Only Subtitles', '2', btnGradient2),
                          SizedBox(height: 1.h,),
                          Text(
                            'The result when using subtitles will depend on the amount of information obtained from the voice in the video.',
                            style: TextStyle(
                                color: const Color(0xFF646C9C),
                                fontFamily: 'Inter',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.17
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6.w),
                      child: Column(
                        children: [
                          _buttonBanner('Using Video with Subtitle', '8', btnGradient1),
                          SizedBox(height: 1.h,),
                          Text(
                            'When using both video and subtitles, the result will depend on whether the video contains important information related to the subtitles or not.',
                            style: TextStyle(
                                color: const Color(0xFF646C9C),
                                fontFamily: 'Inter',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.17
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 40.w,
          right: 40.w,
          child: Container(
            height: 5.0,
            decoration: BoxDecoration(
              color: Color(0xFF646C9C),
              borderRadius: BorderRadius.circular(100000)
            ),
            // width: 5.w,
          ),
        ),
      ],
    );
  }

  _buttonBanner(String title,String time,String pathImage) {
    return Container(
      height: 20.w,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(pathImage),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(14)),
          boxShadow: [BoxShadow(
              color: shadowColor.withOpacity(0.5),
              blurRadius: 26.9,
              offset: Offset(3, 3),
              spreadRadius: 0
          )]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10000000),
                  boxShadow: [BoxShadow(
                      color: Color(0xFFC7CEDF).withOpacity(0.5),
                      blurRadius: 45,
                      offset: Offset(3, 1),
                      spreadRadius: 0
                  )]
              ) ,
              child: Center(
                child: FaIcon(FontAwesomeIcons.play, size: 16.sp,
                    color: title == 'Using Video with Subtitle' ? const Color(0xFF513E9A) : const Color(0xFF5E50F8)),
              ),
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.17
                  ),
                ),
                Row(
                  children: [
                    FaIcon(FontAwesomeIcons.clock, size: 14.sp,
                        color: Colors.white.withOpacity(0.9)),
                    SizedBox(width: 1.5.w,),
                    Text(
                      'Estimate Time : ~ ${time} min.',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.17
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
