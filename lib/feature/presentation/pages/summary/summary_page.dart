import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/constants/colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 24.h,
                  child: YoutubePlayer(
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
                      Future.delayed(Duration(milliseconds: 3000))
                          .then((value) {
                        setState(() {
                          _opacity = 0;
                        });
                        Future.delayed(Duration(milliseconds: 500))
                            .then((value) {
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
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 100),
                  child: hideCreator
                      ? SizedBox()
                      : Container(
                          height: 24.h,
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
                hideCreator
                    ? Container()
                    : AnimatedOpacity(
                        opacity: _opacity,
                        duration: Duration(milliseconds: 500),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 4.w),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                color: Color(0xFF201E38)
                                                    .withOpacity(0.6),
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
                          size: 26.sp,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(EvaIcons.filmOutline,size: 22.sp,),
                  SizedBox(width: 3.w,),
                  Expanded(child: Text('This is SINGAPORE!? - Our Top LOCAL Things to Do, See & Eat! 😍 The Ultimate Guide',maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16.sp, fontFamily: 'inter', fontWeight: FontWeight.w600,color: Color(0xFF15104F)),)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
