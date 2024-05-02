import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/icons.dart';
import '../../manager/prompt_controller.dart';

class JourneyPlannerProgressPage extends StatefulWidget {
  final String imageUrl;
  final double paddingContent;
  const JourneyPlannerProgressPage({super.key, required this.imageUrl, required this.paddingContent});

  @override
  State<JourneyPlannerProgressPage> createState() => _JourneyPlannerProgressPageState();
}

class _JourneyPlannerProgressPageState extends State<JourneyPlannerProgressPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: widget.paddingContent,
          right: widget.paddingContent,
          top: widget.paddingContent),
      child: Container(
        decoration: Get.find<PromptController>().prompt.value.isEmpty ? null :BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: shadowColor.withOpacity(0.4),
                offset: Offset(3,1),
                blurRadius: 40
            )
          ],
        ),
        child: Column(
          children: [
            Get.find<PromptController>().prompt.value.isEmpty ? Container() :Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 3.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: SvgPicture.asset(tripGenBlackIcon),
                  ),
                  SizedBox(width: 1.h,),
                  Expanded(child: Text(Get.find<PromptController>().prompt.value,style: TextStyle(color: Color(0xFF646C9C),fontFamily: 'inter'),))
                ],
              ),
            ),

            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 2.h),
              child: Stack(
                children: [
                  Container(
                    height: (100.w - 60) * (720 / 1280),
                    width: 100.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: (100.w - 60) * (720 / 1280),
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.45),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Center(
                      child: LoadingAnimationWidget.discreteCircle(
                          color: Color(0xFF15104F),
                          secondRingColor: Color(0xFF4D32F8),
                          thirdRingColor:  Color(0xFF9AA6FF),
                          size: 10.w
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
