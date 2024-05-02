import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/core/constants/images.dart';
import 'package:get/get.dart';
import '../../../../core/constants/colors.dart';
import '../../../../injection_container.dart';
import '../../manager/journey_planner/journey_planner_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;

import '../../manager/journey_planner/journey_planner_event.dart';
import '../../manager/navigation_controller.dart';


class JourneyPlannerModalSubmit extends StatefulWidget {
  final String videoUrl;
  final String videoId;
  const JourneyPlannerModalSubmit({super.key, required this.videoUrl, required this.videoId});

  @override
  _JourneyPlannerModalSubmitState createState() => _JourneyPlannerModalSubmitState();
}

class _JourneyPlannerModalSubmitState extends State<JourneyPlannerModalSubmit> {
  String isSelectTitle = '';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 60.h,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buttonBanner('Only Subtitles', '4 - 5', btnGradient2),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buttonBanner('Using Video with Subtitle', '8', btnGradient1),
                        SizedBox(height: 1.h,),
                        Text(
                          'When using both video and subtitles, the result will integrate information based on the relevance of the video content to the subtitles.',
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
                  SizedBox(height: 5.w,),
                  _button('Submit')
                ],
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
    Color baseColor = title == 'Only Subtitles' ? Color(0xFF4D32F8) : Color(0xFF5A47A4);
    bool isSelected = title == isSelectTitle;
    return GestureDetector(
      onTap: () => setState(() {
        isSelectTitle = title;
      }),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        height: 20.w,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(pathImage),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(14)),
            border: isSelected ? Border.all(color: baseColor, width: 3) : Border.all(color: Colors.transparent, width: 3),
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
                      color: baseColor
                  ),
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
      ),
    );
  }

  _button(text) {
    final bool isUseSubtitle = isSelectTitle == 'Only Subtitles' ? true : false;
    return bloc.BlocProvider<JourneyPlannerBloc>(
      create: (context) => sl(),
      child: GestureDetector(
        onTap: () => {
          isSelectTitle != '' ?
          widget.videoId != '' ? bloc.BlocProvider.of<JourneyPlannerBloc>(context).add(UploadVideo(
              videoId: widget.videoId,
              videoUrl: '',
              isUseSubtitle: isUseSubtitle,
              userId: Get.find<NavigationController>().uid.value)):
          bloc.BlocProvider.of<JourneyPlannerBloc>(context).add(UploadVideo(videoUrl: widget.videoUrl, videoId: '',isUseSubtitle: isUseSubtitle, userId: Get.find<NavigationController>().uid.value)) : null,
          Get.back()
        },
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 100.w,
            height: 15.w,
            decoration: BoxDecoration(
                color: isSelectTitle != '' ? Color(0xFF4D32F8) : Color(0xFFCAC9D2),
                borderRadius: BorderRadius.all(Radius.circular(100))
            ),
            child: Center(
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
        ),
      ),
    );
  }
}
