import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/feature/presentation/manager/prompt_controller.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/icons.dart';

class PromptOnlyResult extends StatefulWidget {
  const PromptOnlyResult({super.key});

  @override
  State<PromptOnlyResult> createState() => _PromptOnlyResultState();
}

class _PromptOnlyResultState extends State<PromptOnlyResult> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Spacer(),
            Container(
              decoration: BoxDecoration(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: SvgPicture.asset(tripGenBlackIcon),
                    ),
                    SizedBox(width: 2.h,),
                    Expanded(child: Text(Get.find<PromptController>().prompt.value,))
                  ],
                ),
              ),
            ),
            Spacer(flex: 2,),
          ],
        ),
      ),
    );

  }
}
