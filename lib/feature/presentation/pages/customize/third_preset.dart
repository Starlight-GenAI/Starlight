import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/core/constants/images.dart';

import '../../../../core/constants/colors.dart';
import '../../manager/preset_controller.dart';

class ThirdPreset extends StatefulWidget {
  const ThirdPreset({super.key});

  @override
  State<ThirdPreset> createState() => _ThirdPresetState();
}

class _ThirdPresetState extends State<ThirdPreset> {
  List<Map<String, dynamic>> activitiesList = [
    {'image': emojiNatural, 'text': 'Nature'},
    {'image': emojiLuxury, 'text': 'Luxury'},
    {'image': emojiCity, 'text': 'City'},
    {'image': emojiSurf, 'text': 'Surf'},
    {'image': emojiDrinking, 'text': 'Drinking'},
    {'image': emojiHiking, 'text': 'Hiking'},
    {'image': emojiEating, 'text': 'Eating'},
    {'image': emojiArt, 'text': 'Art'},
    {'image': emojiCultural, 'text': 'Cultural'},
  ];
  List<String> selectData = Get.find<PresetController>().activities.value.split(',');
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.w,
        crossAxisCount: 3,
        children: activitiesList.map((data) => GestureDetector(
          onTap: () => {
            setState(() {
              if(selectData.firstWhere((element) => element == data['text'], orElse: () => '') != '') {
                selectData.remove(data['text']);
              } else {
                selectData.add(data['text']);
              }
              Get.find<PresetController>().activities.value = selectData.join(',');
              // print(selectData);
            })
          },
          child: ListActivities(data: data, selectData: selectData))).toList(),
      ),
    );
  }
}

class ListActivities extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<String>  selectData;

  const ListActivities({super.key, required this.data, required this.selectData});

  @override
  Widget build(BuildContext context) {
    final isSelect = selectData.firstWhere((element) => element == data['text'], orElse: () => '');
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: 16.5.w,
          height: 16.5.w,
          decoration: BoxDecoration(
            color: isSelect != '' ? Color(0xFFC8D0FF): Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: shadowColor.withOpacity(0.4),
                  offset: Offset(3,1),
                  blurRadius: 40
              )
            ],
          ),
          child: Center(
            child: Image.asset(data['image'], width: 8.w,),
          ),
        ),
        SizedBox(height: 2.w),
        Text(data['text'], style: TextStyle(fontSize: 14.5.sp,fontWeight: FontWeight.w600,fontFamily: 'poppins',
            color: Color(0xFF676771)))
      ],
    );
  }
}
