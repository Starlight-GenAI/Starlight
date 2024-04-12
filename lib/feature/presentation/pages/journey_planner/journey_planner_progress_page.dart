import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/colors.dart';

class JourneyPlannerProgressPage extends StatefulWidget {
  const JourneyPlannerProgressPage({super.key});

  @override
  State<JourneyPlannerProgressPage> createState() => _JourneyPlannerProgressPageState();
}

class _JourneyPlannerProgressPageState extends State<JourneyPlannerProgressPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 25.h,
              width: 100.w,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: "https://res.klook.com/image/upload/fl_lossy.progressive,q_85/c_fill,w_680/v1677221922/blog/dmqjomlet9ohlws6lhoy.jpg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              height: 25.h,
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
        )
      ],
    );
  }
}
