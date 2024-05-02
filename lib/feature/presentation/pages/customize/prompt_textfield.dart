import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/constants/icons.dart';
import '../../manager/journey_planner/journey_planner_bloc.dart';
import '../../manager/journey_planner/journey_planner_event.dart';
import '../../manager/navigation_controller.dart';
import '../../manager/prompt_controller.dart';

class PromptTextField extends StatefulWidget {
  const PromptTextField({super.key});

  @override
  State<PromptTextField> createState() => _PromptTextFieldState();
}

class _PromptTextFieldState extends State<PromptTextField> {
  final TextEditingController _textEditingController = TextEditingController();
  int _characterCount = 0;
  late FocusNode _focusNode;
  bool _maxLengthReached = false;
  bool _isNotEmpty = false;


  var suggestHeader = [
    "Create a solo trip in Thailand.",
    "Design travel itinerary for a week"
  ];

  var suggestDesc = [
    "Suggest a must-visit location for 7 days.",
    "including details and key activities or attractions to experience."
  ];
  ScrollController _scrollController = ScrollController();

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
    return Stack(
      children: [
        Column(
          children: [
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
                  SizedBox(
                    height: 20.h,
                    width: 80.w,
                    child: Scrollbar(
                      controller: _scrollController,
                      child: TextField(

                        textInputAction: TextInputAction.done,
                        onSubmitted: (val){
                          FocusManager.instance.primaryFocus?.unfocus();

                        },
                        scrollController: _scrollController,
                        controller: _textEditingController,
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
            Spacer(),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Column(
            children: [
              AnimatedSwitcher(
                switchOutCurve: Curves.bounceInOut,
                duration: Duration(milliseconds: 250),
                child: !_isNotEmpty ? Container(
                  height: 10.h,
                  width: 100.w,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: suggestHeader.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(left: index == 0? 4.w :2.w,right: 2.w,bottom: 2.w),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFEAECF0).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 4.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(suggestHeader[index],style: TextStyle(fontSize: 15.sp, fontFamily: 'inter',fontWeight: FontWeight.w600),),
                                Spacer(),
                                Text(suggestDesc[index],style: TextStyle(fontSize: 14.sp, fontFamily: 'inter',fontWeight: FontWeight.w400,color: Color(0xFF8C8C8C)),)
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ) : null,
              ),
              Container(
                width: 100.w,
                color: Color(0xFFEEF3FA),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: .5.h,horizontal: 1.h),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        Get.find<PromptController>().isSelectYoutube.value = !Get.find<PromptController>().isSelectYoutube.value;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [

                          Checkbox(value: Get.find<PromptController>().isSelectYoutube.value,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              activeColor: Color(0xFF4E33F8),
                              onChanged: (value){
                                setState(() {
                                  Get.find<PromptController>().isSelectYoutube.value = value!;
                                });
                              }),
                          Text("Generate Trip with Video",style: TextStyle(fontFamily: 'inter',fontWeight: FontWeight.w500),),
                          Spacer(),
                          IconButton(onPressed: (){}, icon: Icon(EvaIcons.questionMarkCircleOutline,color: Color(0xFF647AFF),)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                width: 100.w,
                color: Colors.white,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h,horizontal: 2.h),
                    child: Row(
                      children: [
                        Text("${_characterCount} / 250",style: TextStyle(color: Color(0xFF647AFF),fontWeight: FontWeight.w600,fontFamily: 'inter'),),
                        Spacer(),
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
                            color: _isNotEmpty ? Color(0xFF4E33F8) : Color(0xFF8F8C9B).withOpacity(0.4),

                            borderRadius: BorderRadius.circular(24),
                            child: ClipOval(
                              child: InkWell(
                                customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)
                                ),
                                onTap: () {
                                  if (_isNotEmpty && Get.find<PromptController>().isSelectYoutube.value == true){
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    setState(() {
                                      Get.find<PromptController>().prompt.value = _textEditingController.text;
                                      print("Leo"+Get.find<PromptController>().prompt.value);
                                    });
                                    Get.find<PromptController>().indexPage.value++;
                                    Get.find<PromptController>().pageController?.animateToPage(
                                        Get.find<PromptController>().indexPage.value,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.linear);
                                  } else if (_isNotEmpty && Get.find<PromptController>().isSelectYoutube.value == false){
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    setState(() {
                                      Get.find<PromptController>().prompt.value = _textEditingController.text;
                                      print("Leo"+Get.find<PromptController>().prompt.value);
                                    });
                                    Get.find<PromptController>().indexPage.value++;
                                    Get.find<PromptController>().pageController?.animateToPage(
                                        Get.find<PromptController>().indexPage.value,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.linear);
                                    BlocProvider.of<JourneyPlannerBloc>(context).add(UploadVideo(videoUrl: '', videoId: '',isUseSubtitle: false, userId: Get.find<NavigationController>().uid.value,prompt: Get.find<PromptController>().prompt.value));
                                  }
                                },
                                splashColor: Colors.grey.withOpacity(0.5),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 1.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Next",style: TextStyle(fontFamily: 'poppins',fontWeight: FontWeight.w700,color: Colors.white,fontSize: 15.sp),)
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
                ),
              )
            ],
          ),
        )

      ],
    );
  }
}
