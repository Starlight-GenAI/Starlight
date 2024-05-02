import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/feature/presentation/pages/customize/first_preset.dart';
import 'package:starlight/feature/presentation/pages/customize/preset_select_country.dart';
import 'package:starlight/feature/presentation/pages/customize/preset_summary_result.dart';
import 'package:starlight/feature/presentation/pages/customize/second_preset.dart';
import 'package:starlight/feature/presentation/pages/customize/third_preset.dart';

import '../../../../core/constants/icons.dart';

class CustomizePresetPage extends StatefulWidget {
  const CustomizePresetPage({super.key});

  @override
  State<CustomizePresetPage> createState() => _CustomizePresetPageState();
}

class _CustomizePresetPageState extends State<CustomizePresetPage> {

  int _indexPage = 0;
  late PageController pageController;

  var pageHeader = [
    "How many day you\nwant to go?",
    "Who coming with you\n on this journey?",
    "What activity you\n interest?",
    "What Country do you\nwant to go?",
    "Now you can waiting for a result\nat a My action menu"

  ];

  var pageTitle = [
    "Tell us to plan a right trip for you.",
    "We will find the right place for you all.",
    "Feel free to select as many options\nas you would like.",
    "...",
    "...."

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FBFE) ,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      children: [
                        Container(
                          width: 11.w,
                          height: 11.w,

                          child: Center(
                            child: IconButton(
                              hoverColor: Colors.white,
                              icon: FaIcon(FontAwesomeIcons.angleLeft,
                                  size: 18.sp, color: Colors.black),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w,),
                        Text("Customize Trip",style: TextStyle(fontSize: 18.sp,fontFamily: 'inter',fontWeight: FontWeight.w700),)

                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 2.h),
                child: Stack(
                  children: [
                    Container(
                      width: 100.w,
                      height: .8.h,
                      decoration: BoxDecoration(
                        color: Color(0xFFEFF1F4),
                        borderRadius: BorderRadius.circular(24)
                      ),
                    ),
                    AnimatedContainer(
                      width: 20.w * (_indexPage + 1),
                      height: .8.h,
                        duration: Duration(milliseconds: 400),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Color(0xFF4D32F8)
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  Text('STEP ${(_indexPage+1)}/5',style: TextStyle(color: Color(0xFF4D32F8), fontFamily: 'inter', fontWeight: FontWeight.w700,letterSpacing: 1),),
                  SizedBox(height: 1.h,),

                  Text(pageHeader[_indexPage],style: TextStyle( fontFamily: 'poppins', fontWeight: FontWeight.w700, fontSize: 18.sp,),textAlign: TextAlign.center,),
                  SizedBox(height: 2.h,),
                  Text(pageTitle[_indexPage],style: TextStyle(color: Color(0xFF8C8C8C), fontFamily: 'inter', fontWeight: FontWeight.w500, fontSize: 15.sp,),textAlign: TextAlign.center,),
                  Container(
                    width: 100.w,
                    height: 55.h,
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: pageController,
                      children: [
                        FirstPreset() , SecondPreset(), ThirdPreset(), PresetSelectCountry(), PresetSummaryResult()
                      ],

                    ),
                  ),
                  // Spacer(),
                ],

              ),


            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child:
          SafeArea(
            top: false,
            child: GestureDetector(
              onTap: () {
                if (_indexPage < 4){
                    setState(() {
                      _indexPage++;
                    });
                    pageController.animateToPage(_indexPage,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.linear);
                  }else{
                  Get.back();
                }
                },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                    width: 100.w,
                    height: 15.w,
                    decoration: const BoxDecoration(
                        color: Color(0xFF4D32F8),
                        borderRadius: BorderRadius.all(Radius.circular(100))
                    ),
                    child: Center(
                        child: Text(
                          _indexPage==2? "Apply": "Next",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w800),
                        )

                    )
                ),
              ),
            ),
          ),
          )
        ],
      ),
    );
  }
}
