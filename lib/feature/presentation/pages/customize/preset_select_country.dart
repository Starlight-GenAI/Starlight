import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/core/constants/images.dart';

import '../../../../core/constants/colors.dart';
import '../../manager/preset_controller.dart';

class PresetSelectCountry extends StatefulWidget {
  const PresetSelectCountry({super.key});

  @override
  State<PresetSelectCountry> createState() => _PresetSelectCountryState();
}

class _PresetSelectCountryState extends State<PresetSelectCountry> {
  List<Map<String, dynamic>> countryList = [
    {'image': 'https://www.civitatis.com/blog/wp-content/uploads/2023/07/shutterstock_557625622-scaled.jpg', 'text': 'Madrid'},
    {'image': 'https://www.thomascook.com/.imaging/mte/thomascook-theme/og-image/dam/uk/holidays/city-breaks/paris-dekstop.jpg/jcr:content/paris-dekstop.jpg', 'text': 'Paris'},
    {'image': 'https://www.fodors.com/wp-content/uploads/2018/10/HERO_UltimateRome_Hero_shutterstock789412159.jpg', 'text': 'Rome'},
    {'image': 'https://a.cdn-hotels.com/gdcs/production172/d459/3af9262b-3d8b-40c6-b61d-e37ae1aa90aa.jpg', 'text': 'Bangkok'},
    {'image': 'https://www.civitatis.com/blog/wp-content/uploads/2023/07/shutterstock_557625622-scaled.jpg', 'text': 'Madrid'},
    {'image': 'https://www.thomascook.com/.imaging/mte/thomascook-theme/og-image/dam/uk/holidays/city-breaks/paris-dekstop.jpg/jcr:content/paris-dekstop.jpg', 'text': 'Paris'},
    {'image': 'https://www.fodors.com/wp-content/uploads/2018/10/HERO_UltimateRome_Hero_shutterstock789412159.jpg', 'text': 'Rome'},
    {'image': 'https://a.cdn-hotels.com/gdcs/production172/d459/3af9262b-3d8b-40c6-b61d-e37ae1aa90aa.jpg', 'text': 'Bangkok'},
  ];
  String selectData = '';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        primary: false,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6.w),
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.w,
        crossAxisCount: 2,
        children: countryList.map((data) => GestureDetector(
            onTap: () => {
              setState(() {
                selectData = data['text'];
                Get.find<PresetController>().location.value = data['text'];
              })
            },
            child: ListCountry(data: data, selectData: selectData))).toList(),
      ),
    );
  }
}

class ListCountry extends StatelessWidget {
  final Map<String, dynamic> data;
  final String  selectData;

  const ListCountry({super.key, required this.data, required this.selectData});

  @override
  Widget build(BuildContext context) {
    final bool isSelect = data['text'] == selectData;
    final double _borderRadius = 14;
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      height: 18.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius + 4),
        border: Border.all(width: 3.5, color: isSelect ? Color(0xFF4D32F8) : Colors.transparent)
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(_borderRadius),
            child: CachedNetworkImage(
              height: 100.w,
              imageUrl:  data['image'],
              fit: BoxFit.cover,
            ),
          ),
          Opacity(
            opacity: 0.55,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_borderRadius),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    Colors.black
                  ],
                  tileMode: TileMode.mirror,
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Text(data['text'], style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w600,fontFamily: 'inter',
                    color: Colors.white)),
              )
          )
        ],
      ),
    );
  }
}
