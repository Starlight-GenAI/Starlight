import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
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
  bool showButton = false;
  bool showText = true;
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

  final colorList = [
    {'majorColor': Color(0xFF4D32F8), 'mainColor': Color(0xFF647AFF), 'lightColor': Color(0xFFE1E9FF)},
    {'majorColor': Color(0xFF774198), 'mainColor': Color(0xFF6F63B0), 'lightColor': Color(0xFFE3DEFE)},
    {'majorColor': Color(0xFF13C18D), 'mainColor': Color(0xFF355939), 'lightColor': Color(0xFFA3F3AB)},
    {'majorColor': Color(0xFFE41F4F), 'mainColor': Color(0xFF973B51), 'lightColor': Color(0xFFFFD3D8)},
    {'majorColor': Color(0xFFFF7A00), 'mainColor': Color(0xFF905824), 'lightColor': Color(0xFFFFEBD3)}
  ];

  String secondsToMmSs(double seconds) {
    int totalSeconds = seconds.ceil();
    int minutes = totalSeconds ~/ 60;
    int remainingSeconds = totalSeconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String getImage(String refLink) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=700&photo_reference=" +
        refLink +
        "&key=" +
        placeAPIKey +
        "&maxheight=400";
  }

  _formatText(text) {
    if(text.contains('##')) {
      const start = "## ";
      final checkColon = text.contains(':') && !hasNewlineBeforeColon(text);
      // final hasNewlineBeforeColon = !text.substring(0, text.contains(':')).contains('\n');
      final end = checkColon ? ":" : '\n';
      final startIndex = text.indexOf(start);
      int endIndex = text.indexOf(end, startIndex + start.length);
      final title = text.substring(startIndex + start.length, endIndex + 1);

      int indexToRemove = checkColon ? text.indexOf(":") : text.indexOf("\n");
      String textRemoveTitle = text.substring(indexToRemove + 1);
      final splitText = textRemoveTitle.contains('**') ? textRemoveTitle.split("**") : [textRemoveTitle];

      return [title,...splitText];
    } else if (text.contains('**')) {
      return text.split("**");
    } else {
      return text;
    }
  }

  bool hasNewlineBeforeColon(String text) {
    final index = text.indexOf(':');
    return index != -1 && text.substring(0, index).contains('\n');
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
    Timer(Duration(seconds: 1),(){
      setState(() {
        showButton = true;
      });
    });
    Timer(Duration(seconds: 4), () {
      setState(() {
        showText = false;
      });
    });
    // startCountChip();
  }

  _buildNewTextFormat(textList) {
    return TextSpan(
      children: [
        TextSpan(text: textList[0], style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, fontFamily: 'inter',color: Colors.black)),
        for(int i = 1; i < textList.length; i++)
          !(i % 2 == 0) ? TextSpan(text: textList[i], style: TextStyle(fontSize: 15.sp, fontFamily: 'inter',color: Color(0xFF666666))) :
          TextSpan(text: textList[i], style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, fontFamily: 'inter',color: Color(0xFF666666))),


      ],
    );
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
      floatingActionButton: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: showButton ? Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: showText
                          ? Text(
                              'Trip Generator',
                              key: ValueKey<bool>(
                                  showText), // Ensure proper animation
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontFamily: 'inter',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : null),
                  SizedBox(width: 3.w,),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), // Shadow color
                          spreadRadius: 2,
                          blurRadius: 20,
                          offset: Offset(0, 2), // Shadow position
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Material(
                        color: Colors.white, // Button color
                        child: InkWell(
                          splashColor: Colors.grey,
                          onLongPress: (){
                            setState(() {
                              showText = true;
                            });
                            Timer(Duration(seconds: 5), () {
                              setState(() {
                                showText = false;
                              });
                            });
                          },
                          onTapCancel:(){
                            setState(() {
                              showText = false;
                            });
                          } ,
                          onTap: () {
                            _controller.pause();
                            bloc.BlocProvider.of<TripPlannerBloc>(context)
                                .add(GetTripPlanner(Id: _listHistoryItemResponse.queueId));
                            Get.dialog(
                              Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.h),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              barrierDismissible: true,
                            );
                            Get.to(
                                  () => TripPage(),
                              transition: Transition.rightToLeft,
                            )?.then((_) {
                              Get.back();
                            });
                          },
                          child: Center(child: Icon(EvaIcons.map)),
                        ),
                      ),
                    ),
                  )


                ],
              ),
            ),
          ],
        ) : Container(),
      ),
      backgroundColor: backgroundMain,
      body: SafeArea(
        top: false,
        bottom: false,
        child: bloc.BlocBuilder<JourneySummaryBloc, JourneySummaryState>(
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
                              padding: EdgeInsets.only(top: 3.w),
                              itemCount: state.list?.content.length,
                              itemBuilder: (context, index) {
                                // print(state.list?.content[index].photo);
                                final textList = _formatText(state
                                    .list!
                                    .content[
                                index]
                                    .summary);


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
                                                                          .photos?[0] ??
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
                                                                // leosum
                                                                state
                                                                    .list!
                                                                    .content[
                                                                index]
                                                                    .summary!.contains('##')? RichText(
                                                                  maxLines: 5,
                                                                  text: _buildNewTextFormat(textList),
                                                                ):Text(state
                                                                        .list!
                                                                        .content[
                                                                            index]
                                                                        .summary ??
                                                                    "", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, fontFamily: 'inter',color: Colors.black))
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
                                        ? bloc.BlocBuilder<JourneyHighlightBloc,
                                                JourneyHighlightState>(
                                            builder: (_, state) {
                                              print(state);
                                            if (state is JourneyHighlightLoadedState) {
                                              // return Expanded(
                                              //   child: SingleChildScrollView(
                                              //     child: ListView.builder(
                                              //       itemCount: state.list!.content.length,
                                              //       itemBuilder: (BuildContext context, int index) {
                                              //         return Container(
                                              //           width: 100,
                                              //           height: 100,
                                              //         );
                                              //       },
                                              //     ),
                                              //   ),
                                              // );
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                      left: 2.h, right: 2.h, bottom: 2.h),
                                                child: _buildHighlightBox(
                                                    state.list?.content[index].highlightName ?? 'hi',
                                                    state.list?.content[index].highlightDetail ?? 'hi',
                                                    index,
                                                  state.list?.contentSummary ?? "",

                                                ),
                                              );
                                              return Text(
                                                state.list?.content[0]
                                                        .highlightName ??
                                                    "hiu",
                                                style: TextStyle(fontSize: 12),
                                              );
                                            }

                                            if (state
                                                is JourneyHighlightErrorState) {
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
    return Container(
      color: Colors.black,
      child: SafeArea(
        bottom: false,
        child: Stack(
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
        ),
      ),
    );
  }
  _buildNewTextHeaderFormat(textList) {
    return TextSpan(
      children: [
        TextSpan(text: textList[0], style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, fontFamily: 'inter',color: Colors.black)),
        for(int i = 1; i < textList.length; i++)
          !(i % 2 == 0) ? TextSpan(text: textList[i], style: TextStyle(fontSize: 15.sp, fontFamily: 'inter',color: Color(0xFF666666))) :
          TextSpan(text: textList[i], style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, fontFamily: 'inter',color: Color(0xFF666666))),


      ],
    );
  }
  _buildHighlightBox(String? name,String? detail,int index,String summary) {
    final textList = _formatText(summary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        index ==0 && summary.contains('##')? RichText(
          maxLines: 5,
          text: _buildNewTextHeaderFormat(textList),
        ) : Text(summary, style: TextStyle(fontSize: 14.sp, fontFamily: 'inter',color: Color(0xFF666666))),
        SizedBox(height: 1.h,),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.3),
                offset: Offset(0, 4),
                blurRadius: 12,
              )
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.5.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: double.infinity,
                    minHeight: 10.h,
                  ),
                  child: Container(
                    width: 1.w,
                    decoration: BoxDecoration(
                      color: colorList[index % colorList.length]['majorColor'],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(6.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.w,
                                child: CircleAvatar(
                                  backgroundColor: colorList[index % colorList.length]['lightColor'],
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                        fontFamily: 'inter',
                                        fontWeight: FontWeight.w700,
                                        color: colorList[index % colorList.length]['majorColor'],
                                        fontSize:16.sp
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w,),
                              Text(
                                name!,
                                style: TextStyle(
                                fontFamily: 'inter',
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize:16.sp
                              )),
                            ],
                          ),
                          // Spacer(),
                          // FaIcon(FontAwesomeIcons.angleRight, size: 20.sp,
                          //     color: Colors.black),
                        ],
                      ),
                      SizedBox(height: 3.w,),
                      Text(
                          detail!,
                          style: TextStyle(
                              fontFamily: 'inter',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF616161),
                              fontSize:14.sp
                          ))
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      ],
    );
  }
}
