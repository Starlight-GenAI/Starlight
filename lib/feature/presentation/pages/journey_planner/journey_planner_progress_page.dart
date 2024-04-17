import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/colors.dart';

class JourneyPlannerProgressPage extends StatefulWidget {
  final String imageUrl;
  final double paddingContent;
  const JourneyPlannerProgressPage({super.key, required this.imageUrl, required this.paddingContent});

  @override
  State<JourneyPlannerProgressPage> createState() => _JourneyPlannerProgressPageState();
}

class _JourneyPlannerProgressPageState extends State<JourneyPlannerProgressPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: widget.paddingContent,
          right: widget.paddingContent,
          top: widget.paddingContent),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: (100.w - 60) * (720 / 1280),
                width: 100.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: (100.w - 60) * (720 / 1280),
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
      ),
    );
  }
}
