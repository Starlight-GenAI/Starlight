import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_state.dart';

import '../../../../core/constants/colors.dart';

class JourneyPlannerSummaryPage extends StatefulWidget {
  const JourneyPlannerSummaryPage({super.key});

  @override
  State<JourneyPlannerSummaryPage> createState() => _JourneyPlannerSummaryPageState();
}

class _JourneyPlannerSummaryPageState extends State<JourneyPlannerSummaryPage> {
  List<Map<String, dynamic>> _videoData =  [
    {'title':'Duration', 'value': '00.22.52', 'icon': FaIcon(FontAwesomeIcons.clock, size: 22.sp, color: const Color(0xFF0034A0))},
    {'title':'Date', 'value': '2', 'icon': FaIcon(FontAwesomeIcons.calendar, size: 22.sp, color: const Color(0xFF0034A0))}
  ];

  @override
  Widget build(BuildContext context) {
    return bloc.BlocBuilder<JourneyPlannerBloc, JourneyPlannerState>(builder: (_, state) {
      if (state is VideoDetailLoadingState) {
        return Text('loading');
      }
      if (state is VideoDetailLoadedState) {
        return Column(
          children: [
            Container(
              height: 25.h,
              width: 100.w,
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(
                      color: shadowColor.withOpacity(0.4),
                      blurRadius: 26.9,
                      offset: Offset(3, 4),
                      spreadRadius: 0
                  )
                  ]
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl:  state.listDetail!.thumbnails,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.5.h, bottom: 2.5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              'https://www.georgetown.edu/wp-content/uploads/2022/02/Jkramerheadshot-scaled-e1645036825432-1050x1050-c-default.jpg'),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Pisit Jaiton Pa travel',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.17
                        ),
                      ),
                    ],
                  ),
                  FaIcon(FontAwesomeIcons.youtube, size: 24.sp,
                      color: const Color(0xFFFF0001)),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(FontAwesomeIcons.film, size: 18.sp,
                        color: const Color(0xFF15104F)),
                    SizedBox(width: 1.5.w),
                    Text(
                      "Title",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Inter',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.17
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    state.listDetail!.title,
                    style: TextStyle(
                        color: const Color(0xFF25233A).withOpacity(0.58),
                        fontFamily: 'Inter',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.17
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 2.5.h),
            _listVideoData()
          ],
        );
      }
      return const SizedBox();
    });
  }

  _listVideoData() {
    return Expanded(
      child: GridView.builder(
          itemCount: _videoData.length, //${_videoData[index]}
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            childAspectRatio: 0.55.w
          ),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF648FFF).withOpacity(0.21),
                borderRadius: BorderRadius.all(Radius.circular(4.w))
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 1.h, bottom: 1.h, left: 3.5.w, right: 3.5.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _videoData[index]['icon'],
                    SizedBox(width: 2.w,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _videoData[index]['title'],
                            style: TextStyle(
                                color: const Color(0xFF0034A0),
                                fontFamily: 'Inter',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.17
                            ),
                          ),
                          SizedBox(height: 0.3.h,),
                          Text(
                            _videoData[index]['value'] + " " + "Hours",
                            style: TextStyle(
                                color: const Color(0xFF0034A0),
                                fontFamily: 'Inter',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.17
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
      ),
    );
  }
}
