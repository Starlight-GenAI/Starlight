import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/feature/presentation/pages/customize/customize_select_page.dart';
import 'package:starlight/feature/presentation/pages/trip/trip_page.dart';

import '../../../../core/constants/icons.dart';

class CustomizePromptPage extends StatefulWidget {
  @override
  State<CustomizePromptPage> createState() => _CustomizePromptPageState();
}

class _CustomizePromptPageState extends State<CustomizePromptPage> {
  final TextEditingController _textEditingController = TextEditingController();
  int _characterCount = 0;
  late FocusNode _focusNode;
  bool _maxLengthReached = false;
  bool _isNotEmpty = false;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_updateCharacterCount);

    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
  void _updateCharacterCount() {
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FBFE) ,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
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
                                Get.to(
                                    () => CustomizeSelectPage(),
                                  transition: Transition.rightToLeft
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w,),
                        Text("Customize trip",style: TextStyle(fontSize: 18.sp,fontFamily: 'inter',fontWeight: FontWeight.w700),)

                      ],
                    ),
                  ),
                ),

                Container(
                  width: 100.w,
                  padding: EdgeInsets.all(20.0),
                  color: Color(0xFFF9FBFE),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Container(
                          child: SvgPicture.asset(tripGenBlackIcon),
                        ),
                      ),
                      SizedBox(width: 3.w,),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: .3.h),
                          child: TextField(
                            onChanged: (value){
                              setState(() {
                                _isNotEmpty = value.length > 0;
                                _maxLengthReached = value.length >= 250;
                                _characterCount = value.length;
                              });
                            },
                            focusNode: _focusNode,
                            maxLength: 250,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: TextStyle(fontFamily: 'inter',color: Color(0xFF646C9C),fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              hintText: 'Describe the trip you want',
                              hintStyle: TextStyle(fontFamily: 'inter',color: Color(0xFF646C9C).withOpacity(0.5),fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
                left: 0,
                child: Column(
              children: [
                Container(
                  width: 100.w,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 2.h),
                    child: Row(
                      children: [
                        Text("${_characterCount} / 250",style: TextStyle(color: Color(0xFF647AFF),fontWeight: FontWeight.w600,fontFamily: 'inter'),),
                        Spacer(),
                        IconButton(onPressed: (){}, icon: Icon(EvaIcons.questionMarkCircleOutline,color: Color(0xFF647AFF),)),
                        Container(

                          width: 28.w,
                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 20,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: _isNotEmpty ? Color(0xFF647AFF) : Color(0xFF8F8C9B).withOpacity(0.4),

                            borderRadius: BorderRadius.circular(24),
                            child: ClipOval(
                              child: InkWell(
                                customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)
                                ),
                                onTap: () {
                                  if (_isNotEmpty){
                                    Get.back(result: "true");
                                  }
                                },
                                splashColor: Colors.grey.withOpacity(0.5),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 1.2.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Apply",style: TextStyle(fontFamily: 'poppins',fontWeight: FontWeight.w700,color: Colors.white,fontSize: 15.sp),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                )
              ],
            ))
          ],
        ),

      ),
    );
  }
}