import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class JourneyPlannerAddLinkPage extends StatefulWidget {
  final double paddingContent;
  const JourneyPlannerAddLinkPage({super.key, required this.paddingContent});

  @override
  State<JourneyPlannerAddLinkPage> createState() => _JourneyPlannerAddLinkPageState();
}

class _JourneyPlannerAddLinkPageState extends State<JourneyPlannerAddLinkPage> {
  final Color bgColor = const Color(0xFFF2F4FA);
  final SizedBox _sbBetween = SizedBox(height: 2.5.h);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: widget.paddingContent,
          right: widget.paddingContent,
          top: widget.paddingContent),
      child: Column(
        children: [
          Container(
            height: 23.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: bgColor
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "When you provide a link, the video\nsample will appear",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF8E8E8E),
                    fontFamily: 'Inter',
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.17
                ),
              ),
            ),
          ),
          _sbBetween,
          Row(
            children: [
              Container(width: 14.w, height: 14.w, child: CircleAvatar(backgroundColor: bgColor)),
              SizedBox(width: 3.w,),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(height: 1.5.h, color: bgColor),
                    SizedBox(height: 1.2.h),
                    Container(height: 1.5.h, color: bgColor)
                  ],
                ),
              )
            ],
          ),
          _sbBetween,
          Column(
            children: [
              Container(height: 1.5.h, color: bgColor),
              SizedBox(height: 1.2.h),
              Container(height: 1.5.h, color: bgColor)
            ],
          ),
          _sbBetween,
          Row(
            children: [
              Expanded(child: Container(height: 5.h, color: bgColor,)),
              SizedBox(width: 4.w),
              Expanded(child: Container(height: 5.h, color: bgColor,))
            ],
          ),
          _sbBetween,
          Column(
            children: [
              Container(height: 1.5.h, color: bgColor),
              SizedBox(height: 1.2.h),
              Container(height: 1.5.h, color: bgColor)
            ],
          ),
        ],
      ),
    );
  }
}
