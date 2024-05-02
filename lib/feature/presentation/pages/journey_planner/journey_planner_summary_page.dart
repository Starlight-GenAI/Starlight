import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_state.dart';

import '../../../../core/constants/colors.dart';

class JourneyPlannerSummaryPage extends StatefulWidget {
  final double paddingContent;
  const JourneyPlannerSummaryPage({super.key, required this.paddingContent});

  @override
  State<JourneyPlannerSummaryPage> createState() => _JourneyPlannerSummaryPageState();
}

class _JourneyPlannerSummaryPageState extends State<JourneyPlannerSummaryPage> {


  String changeFormatTime(String time) {
    print(time);
    print(time.substring(0,10));
    DateTime timestamp = DateTime.parse(time);
    DateTime now = DateTime.now();

    Duration difference = now.difference(timestamp);

    if (difference.inDays < 1) {
      return 'Today';
    } else if (difference.inDays < 2) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} Days ago';
    } else if (difference.inDays < 30) {
      int weeks = (difference.inDays / 7).floor();
      return '$weeks Weeks ago';
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return '$months Months ago';
    } else {
      int years = (difference.inDays / 365).floor();
      return '$years Years ago';
    }
  }

  String formatDuration(String durationString) {
    Duration duration = _parseDuration(durationString);

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return '${_formatNumber(hours)}.${_formatNumber(minutes)}.${_formatNumber(seconds)} Hours';
  }

  String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  Duration _parseDuration(String durationString) {
    RegExp regex = RegExp(
        r'^PT((\d+)H)?((\d+)M)?((\d+)S)?$');
    Match match = regex.firstMatch(durationString) as Match;

    int hours = int.tryParse(match.group(2) ?? '0') ?? 0;
    int minutes = int.tryParse(match.group(4) ?? '0') ?? 0;
    int seconds = int.tryParse(match.group(6) ?? '0') ?? 0;

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return bloc.BlocBuilder<JourneyPlannerBloc, JourneyPlannerState>(builder: (_, state) {
      if (state is VideoDetailLoadingState) {
        return Text('loading');
      }
      if (state is VideoDetailLoadedState) {
        List<Map<String, dynamic>> _videoData =  [
          {'title':'Duration', 'value': formatDuration(state.listDetail!.duration), 'icon': FaIcon(FontAwesomeIcons.clock, size: 22.sp, color: const Color(0xFF0034A0))},
          {'title':"Upload Date", 'value': changeFormatTime(state.listDetail!.publishAt), 'icon': FaIcon(FontAwesomeIcons.calendar, size: 22.sp, color: const Color(0xFF0034A0))}
        ];
        return Padding(
          padding: EdgeInsets.only(left:  widget.paddingContent,
              right:  widget.paddingContent,
              top:  widget.paddingContent),
          child: Column(
            children: [
              Container(
                height: (100.w - 60) * (720 / 1280),
                width: 100.w,
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                        color: shadowColor.withOpacity(0.45),
                        blurRadius: 26.9,
                        offset: Offset(3, 4),
                        spreadRadius: 0
                    )
                    ]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl:  state.listDetail!.thumbnails,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 5.w),
                decoration: BoxDecoration(
                  color: Color(0xFFF9FBFE),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor.withOpacity(0.45),
                      blurRadius: 70,
                      offset: Offset(3, 4),
                      spreadRadius: 0
                  )]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.w,
                          child: CircleAvatar(
                            backgroundColor: Color(0xFF9AA6FF),
                            child: Text(
                              state.listDetail!.channelName.substring(0,1),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Inter',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                              ),
                          ),
                        )),
                        SizedBox(width: 3.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.listDetail!.channelName,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.17
                              ),
                            ),
                            SizedBox(height: 0.5.w,),
                            Row(
                              children: [
                                FaIcon(FontAwesomeIcons.heart, size: 14.sp,
                                    color: const Color(0xFF5D5D68)),
                                SizedBox(width: 1.w,),
                                Text(
                                  NumberFormat('#,###').format(state.listDetail!.likeCount),
                                  style: TextStyle(
                                      color: const Color(0xFF5D5D68),
                                      fontFamily: 'Inter',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.17
                                  ),
                                ),
                                SizedBox(width: 2.w,),
                                FaIcon(FontAwesomeIcons.eye, size: 14.sp,
                                    color: const Color(0xFF5D5D68)),
                                SizedBox(width: 1.w,),
                                Text(
                                  NumberFormat('#,###').format(state.listDetail!.viewCount),
                                  style: TextStyle(
                                      color: const Color(0xFF5D5D68),
                                      fontFamily: 'Inter',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.17
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    FaIcon(FontAwesomeIcons.youtube, size: 24.sp,
                        color: const Color(0xFFFF0001)),
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: 2.5.h, bottom: 2.5.h),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         children: [
              //           Container(
              //             width: 12.w,
              //             height: 12.w,
              //             child: CircleAvatar(
              //               backgroundImage: CachedNetworkImageProvider(
              //                   'https://www.georgetown.edu/wp-content/uploads/2022/02/Jkramerheadshot-scaled-e1645036825432-1050x1050-c-default.jpg'),
              //             ),
              //           ),
              //           SizedBox(width: 3.w),
              //           Text(
              //             'Pisit Jaiton Pa travel',
              //             style: TextStyle(
              //                 color: Colors.black,
              //                 fontFamily: 'Inter',
              //                 fontSize: 16.sp,
              //                 fontWeight: FontWeight.w700,
              //                 letterSpacing: -0.17
              //             ),
              //           ),
              //         ],
              //       ),
              //       FaIcon(FontAwesomeIcons.youtube, size: 24.sp,
              //           color: const Color(0xFFFF0001)),
              //     ],
              //   ),
              // ),
              SizedBox(height: 2.5.h,),
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
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: const Color(0xFF25233A),
                          fontFamily: 'Inter',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.17
                      ),
                    ),
                  )
                ],
              ),
              _listVideoData(_videoData)
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }

  _listVideoData(_videoData) {
    return Expanded(
      child: GridView.builder(
          itemCount: _videoData.length, //${_videoData[index]}
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 2.h),
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
                                fontSize: 13.25.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.17
                            ),
                          ),
                          SizedBox(height: 0.25.h,),
                          Text(
                            _videoData[index]['value'],
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
