import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FirstPreset extends StatefulWidget {
  const FirstPreset({super.key});

  @override
  State<FirstPreset> createState() => _FirstPresetState();
}

class _FirstPresetState extends State<FirstPreset> {
  List<String> index = ['1','2','3','4','5','6','7'];
  String selectIndex = '0';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: index.map((data) => GestureDetector(
            onTap: () => {
              setState(() {
                selectIndex = data;
              })
            },
            child: IndexBox(data: data, selectData: selectIndex))).toList(),
        ),
      ),
    );
  }
}

class IndexBox extends StatelessWidget {
  final String data;
  final String selectData;

  const IndexBox({super.key, required this.data, required this.selectData});

  @override
  Widget build(BuildContext context) {
    final bool isSelect = data == selectData;
    return Container(
      width: 10.w,
      height: 14.w,
      decoration: BoxDecoration(
        color: isSelect ? Color(0xFF647AFF) : Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isSelect ? Color(0xFF647AFF) : Color(0xFFDFDFDF), width: 1.8)
      ),
      child: Center(child: Text(data, style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold,fontFamily: 'inter',
          color: isSelect ? Colors.white : Color(0xFF686868)))),
    );
  }
}
