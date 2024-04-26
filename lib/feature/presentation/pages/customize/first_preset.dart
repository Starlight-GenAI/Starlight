import 'package:flutter/cupertino.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FirstPreset extends StatefulWidget {
  const FirstPreset({super.key});

  @override
  State<FirstPreset> createState() => _FirstPresetState();
}

class _FirstPresetState extends State<FirstPreset> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("12", style: TextStyle(fontSize: 40.sp,fontWeight: FontWeight.w700,fontFamily: 'inter', letterSpacing: 20),),
    );
  }
}
