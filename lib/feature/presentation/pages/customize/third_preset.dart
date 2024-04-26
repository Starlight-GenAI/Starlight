import 'package:flutter/cupertino.dart';
import 'package:starlight/core/constants/images.dart';

class ThirdPreset extends StatefulWidget {
  const ThirdPreset({super.key});

  @override
  State<ThirdPreset> createState() => _ThirdPresetState();
}

class _ThirdPresetState extends State<ThirdPreset> {
  @override
  Widget build(BuildContext context) {
    return Image.asset(thirdWidget);
  }
}
