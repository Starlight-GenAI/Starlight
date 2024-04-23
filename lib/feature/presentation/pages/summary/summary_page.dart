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
import 'package:starlight/core/constants/constants.dart';
import 'package:starlight/feature/presentation/manager/journey_highlight/journey_highlight_state.dart';
import 'package:starlight/feature/presentation/manager/journey_summary/journey_summary_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_summary/journey_summary_state.dart';
import 'package:starlight/feature/presentation/manager/trip_planner/trip_planner_bloc.dart';
import 'package:starlight/feature/presentation/manager/trip_planner/trip_planner_event.dart';
import 'package:starlight/feature/presentation/pages/trip/trip_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/icons.dart';
import '../../../data/models/list_history/list_history.dart';
import '../../manager/journey_highlight/journey_highlight_bloc.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  ListHistoryItemResponse _listHistoryItemResponse = Get.arguments;
  late YoutubePlayerController _controller;

  var chipIndex = 0;

  // var chipList = ["Locations"];
  var chipIcon = [
    locationIcon,
    restaurantIcon,
    hotelIcon,
    locationIcon,
    restaurantIcon,
    hotelIcon,
    locationIcon,
  ];
  var selectCard = -1;

  var countCate = [0, 0, 0, 0, 0, 0, 0];
  var countExistCate = 0;
  var chipList = [
    "Highlight",
    "Attractions",
    "Dining",
    "Accommodation",
    "Entertainment",
    "Outdoor Activities",
    "ETC"
  ];
  var isFirstInit = false;

  String secondsToMmSs(double seconds) {
    int totalSeconds = seconds.ceil();
    int minutes = totalSeconds ~/ 60;
    int remainingSeconds = totalSeconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String getImage(String refLink) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=700&photo_reference=" +
        refLink +
        "&key="+youtubeAPIKey+"&maxheight=400";
  }

  void startCountCate(VideoSummaryLoadedState state) {
    state.list?.content.forEach((element) {
      print(element.category);
      for (int i = 0; i < chipList.length; i++) {
        if (element.category == chipList[i].toLowerCase()) {
          countCate[i]++;
          break;
        }
      }
    });
    isFirstInit = true;
    // startCountChip();
  }

  void startCountChip() {
    for (int count in countCate) {
      if (count > 0) {
        countExistCate++;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _listHistoryItemResponse.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideThumbnail: true,
        forceHD: true,
        disableDragSeek: true,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
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
              BlocProvider.of<
                  TripPlannerBloc>(context)
                  .add(GetTripPlanner(
                  Id: _listHistoryItemResponse.queueId));
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
              if (isFirstInit == false) {
                startCountCate(state);
              }
              return Stack(
                children: [
                  Column(
                    children: [
                      _buildYoutubePlayer(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 2.h, left: 24, right: 24, bottom: 1.h),
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
                              _listHistoryItemResponse.title,
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
                      Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: chipList.length,
                            itemBuilder: (context, index) {
                              return countCate[index] > 0
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          chipIndex = index;
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 1.w,
                                            left: index == 0 ? 2.5.h : 0),
                                        child: Center(
                                          child: Container(
                                            height: 4.h,
                                            decoration: BoxDecoration(
                                                color: chipIndex == index
                                                    ? Color(0xFF4D32F8)
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color(0xFFC7CEDF)
                                                          .withOpacity(0.45),
                                                      offset: Offset(3, 1),
                                                      blurRadius: 15)
                                                ]),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1.h),
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: chipIndex ==
                                                                index
                                                            ? Colors.white
                                                            : Color(
                                                                0xFF5776C8)),
                                                  ),
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        chipIndex == index
                                                            ? Colors.white
                                                            : Color(0xFFEAEDFF),
                                                    child: Text(
                                                        countCate[index]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: chipIndex ==
                                                                    index
                                                                ? Color(
                                                                    0xFF4D32F8)
                                                                : Color(
                                                                    0xFF5776C8),
                                                            fontFamily: 'inter',
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : index == 0
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              chipIndex = index;
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 1.w,
                                                left: index == 0 ? 2.5.h : 0),
                                            child: Center(
                                              child: Container(
                                                height: 4.h,
                                                decoration: BoxDecoration(
                                                    color: chipIndex == index
                                                        ? Color(0xFF4D32F8)
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color:
                                                              Color(0xFFC7CEDF)
                                                                  .withOpacity(
                                                                      0.45),
                                                          offset: Offset(3, 1),
                                                          blurRadius: 15)
                                                    ]),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 1.h),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 3.w,
                                                      ),
                                                      SvgPicture.asset(
                                                        chipIcon[index],
                                                        color: chipIndex ==
                                                                index
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
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: chipIndex ==
                                                                    index
                                                                ? Colors.white
                                                                : Color(
                                                                    0xFF5776C8)),
                                                      ),
                                                      SizedBox(
                                                        width: 4.w,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container();
                            }),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Expanded(
                          flex: 10,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: state.list?.content.length,
                              itemBuilder: (context, index) {
                                print(state.list?.content[index].photo);
                                return state.list?.content[index].category ==
                                        chipList[chipIndex].toLowerCase()
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: 2.h, right: 2.h, bottom: 2.h),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (selectCard != index) {
                                              _controller.seekTo(Duration(
                                                  seconds: state.list!
                                                      .content[index].startTime!
                                                      .floor()));
                                              _controller.play();
                                            }
                                            setState(() {
                                              selectCard = selectCard == index
                                                  ? -1
                                                  : index;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 200),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: selectCard == index
                                                    ? Border.all(
                                                        color:
                                                            Color(0xFF647AFF),
                                                        width: 3)
                                                    : Border.all(
                                                        color: Colors
                                                            .transparent)),
                                            child: Stack(
                                              alignment: selectCard == index
                                                  ? Alignment.topCenter
                                                  : Alignment.topCenter,
                                              children: [
                                                Column(
                                                  children: [
                                                    AnimatedContainer(
                                                      duration: Duration(
                                                          milliseconds: 200),
                                                      height:
                                                          selectCard == index
                                                              ? 20.h
                                                              : 25.h,
                                                      decoration: BoxDecoration(
                                                          borderRadius: selectCard ==
                                                                  index
                                                              ? BorderRadius.only(
                                                                  topLeft: Radius.circular(
                                                                      8),
                                                                  topRight:
                                                                      Radius.circular(
                                                                          8))
                                                              : BorderRadius
                                                                  .circular(12),
                                                          image: DecorationImage(
                                                              image: CachedNetworkImageProvider(
                                                                  getImage(state
                                                                          .list
                                                                          ?.content[index]
                                                                          .photo ??
                                                                      "")),
                                                              fit: BoxFit.cover)),
                                                    ),
                                                    selectCard == index
                                                        ? Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2.h),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  state
                                                                          .list!
                                                                          .content[
                                                                              index]
                                                                          .locationName ??
                                                                      "",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16.sp,
                                                                      color: Color(
                                                                          0xFF162AA3)),
                                                                ),
                                                                SizedBox(
                                                                  height: 1.5.h,
                                                                ),
                                                                Text(state
                                                                        .list!
                                                                        .content[
                                                                            index]
                                                                        .summary ??
                                                                    "")
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                            colors: [
                                                              Colors
                                                                  .transparent,
                                                              Colors
                                                                  .transparent,
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.8),
                                                            ],
                                                          ),
                                                        )),
                                                selectCard == index
                                                    ? Container()
                                                    : Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 20.h,
                                                                left: 2.h,
                                                                right: 2.h),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                state
                                                                        .list!
                                                                        .content[
                                                                            index]
                                                                        .locationName ??
                                                                    "",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16.sp),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 1.w,
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.8),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12)),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            4,
                                                                        horizontal:
                                                                            8),
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      EvaIcons
                                                                          .clockOutline,
                                                                      size:
                                                                          14.sp,
                                                                      color: Color(
                                                                          0xFF15104F),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          1.w,
                                                                    ),
                                                                    Text(
                                                                      secondsToMmSs(state
                                                                              .list!
                                                                              .content[index]
                                                                              .startTime ??
                                                                          0),
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'inter',
                                                                          fontWeight: FontWeight
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
                                      )
                                    : (chipIndex == 0 && index == 0)
                                        ? BlocBuilder<JourneyHighlightBloc,
                                                JourneyHighlightState>(
                                            builder: (_, state) {
                                            if (state is JourneyHighlightLoadedState){
                                              return Text(state.list?.content[0].highlightName ?? "hiu",style: TextStyle(fontSize: 12),);
                                            }

                                            if (state is JourneyHighlightErrorState){
                                              return Text("dsadsadssad");
                                            }
                                            return Container();
                                          })
                                        : Container();
                              })),
                    ],
                  ),
                ],
              );
            }
            if (state is VideoSummaryErrorState) {
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
