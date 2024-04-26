import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/images.dart';

class SecondPreset extends StatefulWidget {
  const SecondPreset({super.key});

  @override
  State<SecondPreset> createState() => _SecondPresetState();
}

class _SecondPresetState extends State<SecondPreset> {
  @override
  Widget build(BuildContext context) {
    return Image.asset(secondWidget);
  }
}
