import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/feature/presentation/pages/customize/customize_prompt_page.dart';

class CustomizeSelectPage extends StatefulWidget {
  const CustomizeSelectPage({super.key});

  @override
  State<CustomizeSelectPage> createState() => _CustomizeSelectPageState();
}

class _CustomizeSelectPageState extends State<CustomizeSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 11.w,
                    height: 11.w,
                  
                    child: Center(
                      child: IconButton(
                        hoverColor: Colors.white,
                        icon: FaIcon(FontAwesomeIcons.close,
                            size: 18.sp, color: Colors.black),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w,),
                  Text("Customize trip",style: TextStyle(fontSize: 18.sp,fontFamily: 'inter',fontWeight: FontWeight.w700),)

                ],
              ),
              SizedBox(height: 5.h,),
              Material(
                color: Colors.red,
                child: InkWell(
                  splashColor: Colors.grey.withOpacity(0.5),

                  onTap: (){
                    Get.off(
                        () => CustomizePromptPage(),
                    );
                  },
                  child: Container(
                    width: 100.w,
                    height: 20.h,
                  ),
                ),
              ),
              SizedBox(height: 3.h,),
              Material(
                color: Colors.red,
                child: InkWell(
                  splashColor: Colors.grey.withOpacity(0.5),

                  onTap: (){
                  },
                  child: Container(
                    width: 100.w,
                    height: 20.h,
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
