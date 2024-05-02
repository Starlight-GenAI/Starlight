import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/core/constants/images.dart';

import '../../../../core/constants/colors.dart';
import '../../manager/navigation_controller.dart';
import '../profile/profile_page.dart';

class PresetSummaryResult extends StatefulWidget {
  const PresetSummaryResult({super.key});

  @override
  State<PresetSummaryResult> createState() => _PresetSummaryResultState();
}

class _PresetSummaryResultState extends State<PresetSummaryResult> {
  List<Map<String, dynamic>> details = [
    {'title': 'Days', 'value': Get.find<NavigationController>().name.value, 'icon': FaIcon(FontAwesomeIcons.calendar, size: 16.sp, color: const Color(0xFF646C9C))},
    {'title': 'Coming with', 'value': Get.find<NavigationController>().name.value, 'icon': FaIcon(FontAwesomeIcons.userGroup, size: 15.sp, color: const Color(0xFF646C9C))},
    {'title': "Activities", 'value': 'ffff', 'icon': FaIcon(FontAwesomeIcons.drum, size: 16.sp, color: const Color(0xFF646C9C))},
    {'title': "Location", 'value': 'Thailand 🇹🇭', 'icon': FaIcon(FontAwesomeIcons.locationDot, size: 16.sp, color: const Color(0xFF646C9C))}
  ];
  String selectData = '';
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
                child: Column(
                  children: details.map((data) => InformationRow(data: data)).toList(),
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
