import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/images.dart';
import '../../manager/preset_controller.dart';

class SecondPreset extends StatefulWidget {
  const SecondPreset({super.key});

  @override
  State<SecondPreset> createState() => _SecondPresetState();
}

class _SecondPresetState extends State<SecondPreset> {
  List<Map<String, dynamic>> comingWithList = [
    {'image': emojiSolo, 'text': 'Going Solo'},
    {'image': emojiFriend, 'text': 'Friend'},
    {'image': emojiFamily, 'text': 'Family'},
    {'image': emojiPartner, 'text': 'Partner'}
  ];
  String selectIndex = Get.find<PresetController>().comingWith.value;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: comingWithList.map((data) => GestureDetector(
            onTap: () => {
              setState(() {
                selectIndex = data['text'];
                Get.find<PresetController>().comingWith.value = data['text'];
              })
            },
            child: ListComingWith(data: data, selectData: selectIndex))).toList(),
        ),
      ),
    );
  }
}

class ListComingWith extends StatelessWidget {
  final Map<String, dynamic> data;
  final String selectData;

  const ListComingWith({super.key, required this.data, required this.selectData});

  @override
  Widget build(BuildContext context) {
    final bool isSelect = data['text'] == selectData;
    return Column(
      children: [
        SizedBox(height: data['text'] == 'Going Solo' ? 5 : 2.5.w,),
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          // width: 10.w,
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          height: 18.w,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isSelect ? Color(0xFF647AFF) : Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                    color: shadowColor.withOpacity(0.4),
                    offset: Offset(3,1),
                    blurRadius: 40
                )
              ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(data['image'], width: 6.w,),
              SizedBox(width: 3.w,),
              Text(data['text'], style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w600,fontFamily: 'poppins',
              color: isSelect ? Color(0xFF647AFF) : Color(0xFF686868))),
            ],
          ),
        ),
        SizedBox(height: data['text'] == 'Partner' ? 5 :2.5.w,),
      ],
    );
  }
}
