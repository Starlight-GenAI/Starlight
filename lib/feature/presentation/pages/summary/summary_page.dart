import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/feature/presentation/manager/journey_summary/journet_summary_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_summary/journey_summary_state.dart';
import 'package:starlight/feature/presentation/pages/trip/trip_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/icons.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'DdNinknbetM',
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
      hideThumbnail: true,
      forceHD: true,
      disableDragSeek: true,
    ),
  );

  double _opacity = 1;
  bool hideCreator = false;
  var chipIndex = 0;
  var chipList = ["Locations"];
  var chipIcon = [locationIcon, restaurantIcon, hotelIcon];
  var selectCard = -1;

  String secondsToMmSs(double seconds) {
    int totalSeconds = seconds.ceil();
    int minutes = totalSeconds ~/ 60;
    int remainingSeconds = totalSeconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              _controller.pause();
              Get.to(() => TripPage());
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      EvaIcons.mapOutline,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    Text(
                      "Trip Generator",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundMain,
      body: SafeArea(
        top: false,
        child: BlocBuilder<JourneySummaryBloc, JourneySummaryState>(
          builder: (_, state) {
            if (state is VideoSummaryLoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is VideoSummaryLoadedState) {
              return  Stack(
                children: [
                  Column(
                    children: [
                      // _buildYoutubePlayer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              EvaIcons.filmOutline,
                              size: 22.sp,
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Expanded(
                                child: Text(
                                  'This is SINGAPORE!? - Our Top LOCAL Things to Do, See & Eat! 😍 The Ultimate Guide',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: 'inter',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF15104F)),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        height: 4.h,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: chipList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    chipIndex = index;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 1.w, left: index == 0 ? 2.5.h : 0),
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: chipIndex == index
                                              ? Color(0xFF4D32F8)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(24),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color(0xFFC7CEDF)
                                                    .withOpacity(0.45),
                                                offset: Offset(3, 1),
                                                blurRadius: 40)
                                          ]),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 1.h),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            SvgPicture.asset(
                                              chipIcon[index],
                                              color: chipIndex == index
                                                  ? Colors.white
                                                  : Color(0xFF5776C8),
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Text(
                                              chipList[index],
                                              style: TextStyle(
                                                  fontFamily: 'inter',
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: chipIndex == index
                                                      ? Colors.white
                                                      : Color(0xFF5776C8)),
                                            ),
                                            CircleAvatar(
                                              backgroundColor: chipIndex == index
                                                  ? Colors.white
                                                  : Color(0xFFEAEDFF),
                                              child: Text(state.list?.content.length.toString() ?? "",
                                                  style: TextStyle(
                                                      color: chipIndex == index
                                                          ? Color(0xFF4D32F8)
                                                          : Color(0xFF5776C8),
                                                      fontFamily: 'inter',
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w600)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Expanded(child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: state.list?.content.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: 2.h, right: 2.h, bottom: 2.h),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectCard =
                                    selectCard == index ? -1 : index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: selectCard == index
                                          ? Border.all(
                                          color: Color(0xFF647AFF),
                                          width: 3)
                                          : Border.all(
                                          color: Colors.transparent)),
                                  child: Stack(
                                    alignment: selectCard == index
                                        ? Alignment.topCenter
                                        : Alignment.topCenter,
                                    children: [
                                      Column(
                                        children: [
                                          AnimatedContainer(
                                            duration:
                                            Duration(milliseconds: 200),
                                            height: selectCard == index
                                                ? 20.h
                                                : 25.h,
                                            decoration: BoxDecoration(
                                                borderRadius: selectCard ==
                                                    index
                                                    ? BorderRadius.only(
                                                    topLeft:
                                                    Radius.circular(12),
                                                    topRight:
                                                    Radius.circular(12))
                                                    : BorderRadius.circular(12),
                                                image: const DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                        "https://img-ha.mthcdn.com/jKQjrId3X0-ENg0iu8ykpFajUj0=/travel.mthai.com/app/uploads/2019/03/phuket-cover.jpg"),
                                                    fit: BoxFit.fitWidth)),
                                          ),
                                          selectCard == index
                                              ? Padding(
                                            padding: EdgeInsets.all(2.h),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  state.list!.content[index].locationName ?? "",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w700,
                                                      fontSize: 16.sp,
                                                      color: Color(
                                                          0xFF162AA3)),
                                                ),
                                                SizedBox(
                                                  height: 1.5.h,
                                                ),
                                                Text(
                                                    state.list!.content[index].summary ?? "")
                                              ],
                                            ),
                                          )
                                              : Container()
                                        ],
                                      ),
                                      selectCard == index
                                          ? Container()
                                          : Container(
                                          height: 25.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.transparent,
                                                Colors.black
                                                    .withOpacity(0.8),
                                              ],
                                            ),
                                          )),
                                      selectCard == index
                                          ? Container()
                                          : Padding(
                                        padding: EdgeInsets.only(
                                            top: 20.h,
                                            left: 2.h,
                                            right: 2.h),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              state.list!.content[index].locationName ?? "",
                                              style: TextStyle(
                                                  fontFamily: 'inter',
                                                  fontWeight:
                                                  FontWeight.w700,
                                                  color: Colors.white,
                                                  fontSize: 16.sp),
                                            ),
                                            Spacer(),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12)),
                                              child: Padding(
                                                padding:
                                                EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 8),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      EvaIcons
                                                          .clockOutline,
                                                      size: 14.sp,
                                                      color: Color(
                                                          0xFF15104F),
                                                    ),
                                                    SizedBox(
                                                      width: 1.w,
                                                    ),
                                                    Text(
                                                      secondsToMmSs(state.list!.content[index].startTime ?? 0),
                                                      style: TextStyle(
                                                          fontFamily:
                                                          'inter',
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                          color: Color(
                                                              0xFF15104F),
                                                          fontSize:
                                                          13.sp),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })),
                    ],
                  ),
                  hideCreator
                      ? SizedBox()
                      : AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    child: Container(
                        height: 20.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(_opacity * 0.6),
                              Colors.transparent,
                            ],
                          ),
                        )),
                  ),
                ],
              );
            }
            if (state is VideoSummaryErrorState){
              return CircularProgressIndicator();
            }
            return const SizedBox();

          },
        ),
      ),
    );
  }

  _buildYoutubePlayer() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          child: YoutubePlayer(
            aspectRatio: 16 / 9,
            controller: _controller,
            progressIndicatorColor: Color(0xFF647AFF),
            bottomActions: [
              const SizedBox(width: 8.0),
              CurrentPosition(),
              const SizedBox(width: 8.0),
              ProgressBar(
                controller: _controller,
                isExpanded: true,
                colors: const ProgressBarColors(
                  playedColor: Color(0xFF647AFF),
                  handleColor: Colors.white,
                ),
              ),
              const SizedBox(width: 8.0),
            ],
            onReady: () {
              Future.delayed(Duration(milliseconds: 1500)).then((value) {
                setState(() {
                  _opacity = 0;
                });
                Future.delayed(Duration(milliseconds: 500)).then((value) {
                  setState(() {
                    hideCreator = true;
                  });
                });
              });
              // _controller.addListener(() {
              //   if(!_controller.value.isPlaying){
              //     setState(() {
              //       _opacity = 1;
              //       hideCreator = false;
              //     });
              //   }
              // });
            },
          ),
        ),
        hideCreator
            ? Container()
            : AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(milliseconds: 500),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                  child: GestureDetector(
                    onTap: () {
                      // setState(() {
                      //   _opacity = 0;
                      //   hideCreator = true;
                      // });
                      // _controller.play();
                    },
                    child: Container(
                      height: 8.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(48),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: shadowColor.withOpacity(0.3),
                              offset: Offset(0, 4),
                              blurRadius: 12,
                            )
                          ]),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 1.w,
                          ),
                          Expanded(
                            child: CircleAvatar(
                              radius: 20.sp,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "The Endless Adventure",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'inter'),
                                ),
                                SizedBox(
                                  height: .2.h,
                                ),
                                Text(
                                    "This is SINGAPORE!? - Our Top LOC..asdasdas.",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color:
                                            Color(0xFF201E38).withOpacity(0.6),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'inter')),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Icon(
                            EvaIcons.checkmark,
                            size: 24.sp,
                            color: Color(0xFF009421),
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: IconButton(
                icon: Icon(
                  EvaIcons.arrowIosBackOutline,
                  size: 24.sp,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ))
      ],
    );
  }
}
