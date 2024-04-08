import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/core/constants/colors.dart';

import '../../../../core/constants/images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
            opacity: 0.8,
            child: Image.asset(gradient)),
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 24,left: 24,right: 24),
            height: 28.h,
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Alexander P.",style: TextStyle(color: Colors.white,fontFamily: 'Poppins',fontSize: 20.sp, fontWeight: FontWeight.bold),),
                    Spacer(),
                    CircleAvatar(radius: 20.sp,backgroundImage: CachedNetworkImageProvider('https://www.georgetown.edu/wp-content/uploads/2022/02/Jkramerheadshot-scaled-e1645036825432-1050x1050-c-default.jpg') ,)
                  ],
                ),
                SizedBox(height: 38,),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 14.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.h,),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 100.h
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(48),topRight: Radius.circular(48))
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
