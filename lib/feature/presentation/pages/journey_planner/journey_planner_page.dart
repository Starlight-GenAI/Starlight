import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_planner/journey_planner_event.dart';
import 'package:starlight/feature/presentation/manager/navigation_controller.dart';
import 'package:starlight/feature/presentation/pages/error_alert/error_alert_page.dart';
import 'package:starlight/feature/presentation/pages/journey_planner/journey_planner_add_link_page.dart';
import 'package:starlight/feature/presentation/pages/journey_planner/journey_planner_progress_page.dart';
import 'package:starlight/feature/presentation/pages/journey_planner/journey_planner_summary_page.dart';

import '../../../../injection_container.dart';
import '../../../data/data_sources/upload_video/upload_video_request.dart';
import '../../manager/journey_planner/journey_planner_state.dart';
import '../navigation_page.dart';


class JourneyPlannerPage extends StatefulWidget {
  const JourneyPlannerPage({super.key});

  @override
  State<JourneyPlannerPage> createState() => _JourneyPlannerPageState();
}

class _JourneyPlannerPageState extends State<JourneyPlannerPage> {
  final double _paddingContent = 24;
  int _currentIndex = 0;
  CarouselController buttonCarouselController = CarouselController();
  JourneyPlannerBloc? _bloc;
  String imageUrl = "";

  var urlFromClipBoard = "";

  @override
  void initState() {
    super.initState();

    Clipboard.getData(Clipboard.kTextPlain).then((value) {
      var clipboard = value?.text ?? "";
      urlFromClipBoard = clipboard;
      print(clipboard);
      if (clipboard.isNotEmpty && (clipboard.contains("youtube") || clipboard.contains('youtu.be'))) {
        _handleTap(context);
      }
    }
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Save a reference to the JourneyPlannerBloc using dependOnInheritedWidgetOfExactType
    _bloc ??= bloc.BlocProvider.of<JourneyPlannerBloc>(context);
  }

  @override
  void dispose() {
    print("leo dispose");
    _bloc?.add(ResetBlocEvent());
    super.dispose();

  }

  void onGetImageUrl(String data) {
    setState(() {
      imageUrl = data; // Update data from child
    });
  }


  @override
  Widget build(BuildContext context) {
    final bool hasSafeAreaBottom = MediaQuery
        .of(context)
        .padding
        .bottom > 0;

    return bloc.BlocListener<JourneyPlannerBloc, JourneyPlannerState>(
      listener: (context, state) {
        print('/////////////ui state//////////////');
        print(state);
        if (state is UploadVideoLoadedState || state is VideoDetailLoadedState) {
          if(state is VideoDetailLoadedState) {
            imageUrl = state.listDetail!.thumbnails;
          }
          buttonCarouselController.nextPage(
            duration: const Duration(milliseconds: 200),
            curve: Curves.linear,
          );
        } else if (state is VideoDetailErrorState) {
          Get.to(transition: Transition.downToUp,
                  () => ErrorAlertPage());
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF15104F),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20,
                    left: _paddingContent,
                    right: _paddingContent,
                    bottom: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Get.back(),
                      child: Padding(
                          padding: EdgeInsets.only(right: 3.w),
                          child: FaIcon(FontAwesomeIcons.angleLeft, size: 20.sp,
                              color: Colors.white)
                      ),
                    ),
                    Text(
                      "Video Journey Planner",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: 100.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9FBFE),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        IgnorePointer(
                          child: CarouselSlider(
                            carouselController: buttonCarouselController,
                            options: CarouselOptions(
                                height: 60.h,
                                enableInfiniteScroll: false,
                                viewportFraction: 1.0,
                                onPageChanged: (index, page) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                }
                            ),
                            items: [1, 2, 3].map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return i == 1 ? JourneyPlannerAddLinkPage(paddingContent: _paddingContent,) :
                                  i == 2 ? JourneyPlannerSummaryPage(paddingContent: _paddingContent) :
                                  JourneyPlannerProgressPage(imageUrl: imageUrl, paddingContent: _paddingContent);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(child: Container()),
                        Column(
                          children: [
                            Container(
                              width: 80.w,
                              child: Text(
                                _currentIndex == 0
                                    ? "Copy video link from social media or Shared from other apps."
                                    :
                                _currentIndex == 1
                                    ? "It might take a minute after submitting a video to plan a journey list."
                                    :
                                "Now you can waiting for a result at a My Journey menu",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                              child: AnimatedSmoothIndicator(count: 3,
                                activeIndex: _currentIndex,
                                effect: ExpandingDotsEffect(
                                    expansionFactor: 2.5,
                                    dotWidth: 1.h,
                                    dotHeight: 1.h,
                                    spacing: 1.w,
                                    activeDotColor: Color(0xFF4D32F8),
                                    dotColor: Color(0xFFC5C5C5)),),
                            ),
                            // ElevatedButton(
                            //   onPressed: () => buttonCarouselController.nextPage(
                            //       duration: Duration(milliseconds: 200), curve: Curves.linear),
                            //   child: Text('Next'),
                            // ),
                            _button(
                                _currentIndex == 0 ? 'Paste Link' : _currentIndex == 1
                                    ? "Submit"
                                    : "Done"),
                            SizedBox(height: !hasSafeAreaBottom ? 3.h : 0,),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _button(text) {
    return bloc.BlocProvider<JourneyPlannerBloc>(
      create: (context) => sl(),
      child: GestureDetector(
        onTap: () => _handleTap(context),
        child: Padding(
          padding: EdgeInsets.only(left: _paddingContent, right: _paddingContent),
          child: Container(
            width: 100.w,
            decoration: const BoxDecoration(
                color: Color(0xFF4D32F8),
                borderRadius: BorderRadius.all(Radius.circular(100))
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 4.5.w,bottom: 4.5.w),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    if (_currentIndex == 0) {
      print('try add event');
      Clipboard.getData(Clipboard.kTextPlain).then((value) {
        var clipboard = value?.text ?? "";
        setState(() {
          urlFromClipBoard = clipboard;
        });
        bloc.BlocProvider.of<JourneyPlannerBloc>(context).add(VideoDetail(videoUrl: urlFromClipBoard));

      });
    } else if (_currentIndex == 1) {
      bloc.BlocProvider.of<JourneyPlannerBloc>(context).add(UploadVideo(videoUrl: urlFromClipBoard, isUseSubtitle: true, userId: Get.find<NavigationController>().uid.value));
    } else {
      Get.back();
    }
  }

}



