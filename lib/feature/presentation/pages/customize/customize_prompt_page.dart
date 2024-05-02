import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/feature/presentation/manager/prompt_controller.dart';
import 'package:starlight/feature/presentation/pages/customize/customize_select_page.dart';
import 'package:starlight/feature/presentation/pages/customize/prompt_textfield.dart';
import 'package:starlight/feature/presentation/pages/journey_planner/journey_planner_add_link_page.dart';
import 'package:starlight/feature/presentation/pages/journey_planner/journey_planner_summary_page.dart';
import 'package:starlight/feature/presentation/pages/trip/trip_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as page;
import '../../../../core/constants/icons.dart';
import '../../manager/journey_planner/journey_planner_bloc.dart';
import '../../manager/journey_planner/journey_planner_event.dart';
import '../../manager/list_history/list_history_bloc.dart';
import '../../manager/list_history/list_history_event.dart';
import '../../manager/navigation_controller.dart';
import '../error_alert/error_alert_page.dart';
import '../journey_planner/journey_planner_modal_submit.dart';

class CustomizePromptPage extends StatefulWidget {
  @override
  State<CustomizePromptPage> createState() => _CustomizePromptPageState();
}

class _CustomizePromptPageState extends State<CustomizePromptPage> {
  var urlFromClipBoard = "";

  var pageHeader = [
    "How many day you\nwant to go?",
    "Copy video link from social media\nor Shared from other apps.",
    "Video detail of youtube media\nyou provided",
    "Now you can waiting for a result\nat a My action menu"
  ];



  var pageTitle = [
    "",
    "",
    "It might take a minute after submitting\na video to plan a journey."

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(PromptController(), permanent: false);

    Get.find<PromptController>().pageController = PageController();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FBFE) ,
      body: Obx(
        ()=> Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                    child: SafeArea(
                      bottom: false,
                      child: Row(
                        children: [
                          Container(
                            width: 11.w,
                            height: 11.w,

                            child: Center(
                              child: IconButton(
                                hoverColor: Colors.white,
                                icon: FaIcon(FontAwesomeIcons.angleLeft,
                                    size: 18.sp, color: Colors.black),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w,),
                          Text("Customize with Prompt",style: TextStyle(fontSize: 18.sp,fontFamily: 'inter',fontWeight: FontWeight.w700),)

                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.h,vertical: 2.h),
                  child: Stack(
                    children: [
                      Container(
                        width: 100.w,
                        height: .8.h,
                        decoration: BoxDecoration(
                            color: Color(0xFFEFF1F4),
                            borderRadius: BorderRadius.circular(24)
                        ),
                      ),
                      AnimatedContainer(
                        width:(Get.find<PromptController>().isSelectYoutube.value? 35.w : 100.w) * (Get.find<PromptController>().indexPage.value ),
                        height: .8.h,
                        duration: Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Color(0xFF4D32F8)
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text('STEP ${(Get.find<PromptController>().indexPage.value+1)}/${Get.find<PromptController>().isSelectYoutube.value? "4": "2"}',style: TextStyle(color: Color(0xFF4D32F8), fontFamily: 'inter', fontWeight: FontWeight.w700,letterSpacing: 1),),
                    SizedBox(height: 1.h,),

                    Text(Get.find<PromptController>().isSelectYoutube.value? pageHeader[Get.find<PromptController>().indexPage.value] : pageHeader[3],style: TextStyle( fontFamily: 'poppins', fontWeight: FontWeight.w700, fontSize: 18.sp,),textAlign: TextAlign.center,),
                    Text(pageTitle[Get.find<PromptController>().indexPage.value],style: TextStyle(color: Color(0xFF8C8C8C), fontFamily: 'inter', fontWeight: FontWeight.w500, fontSize: 15.sp,),textAlign: TextAlign.center,),
                    // Container(
                    //   width: 100.w,
                    //   height: 50.h,
                    //   child: PageView(
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     controller: pageController,
                    //     children: [
                    //       FirstPreset() , SecondPreset(), ThirdPreset()
                    //     ],
                    //
                    //   ),
                    // ),
                    // Spacer(),

                  ],

                ),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: Get.find<PromptController>().pageController,
                    children: [
                      PromptTextField(),Get.find<PromptController>().isSelectYoutube.value ?JourneyPlannerAddLinkPage(paddingContent: 3.h) : Container(),JourneyPlannerSummaryPage(paddingContent: 3.h),JourneyPlannerSummaryPage(paddingContent: 3.h)
                    ],
                  ),
                )



              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child:
               AnimatedSwitcher(
                duration: Duration(milliseconds: 400),
                child: Get.find<PromptController>().indexPage.value == 0 ? Container() :SafeArea(
                  top: false,
                  child: GestureDetector(
                    onTap: () {
                       if (Get.find<PromptController>().indexPage.value == 1 && Get.find<PromptController>().isSelectYoutube.value == false){
                         BlocProvider.of<ListHistoryBloc>(context).add(GetListHistory(userId: Get.find<NavigationController>().uid.value));
                         Get.find<NavigationController>().changePage(1);
                         Get.close(2);
                       }
                      else if (Get.find<PromptController>().indexPage.value == 1){
                        try {
                                Clipboard.getData(Clipboard.kTextPlain)
                                    .then((value) {
                                  var clipboard = value?.text ?? "";
                                  setState(() {
                                    urlFromClipBoard = clipboard;
                                  });
                                  String? videoId = urlFromClipBoard
                                              .contains("youtube") ||
                                          urlFromClipBoard.contains('youtu.be')
                                      ? YoutubePlayer.convertUrlToId(
                                          urlFromClipBoard)
                                      : urlFromClipBoard;
                                  bloc.BlocProvider.of<JourneyPlannerBloc>(
                                          context)
                                      .add(VideoDetail(videoId: videoId!));
                                });
                              } catch (e){
                          Get.to(transition: page.Transition.downToUp,
                                  () => ErrorAlertPage());
                        }
                            }
                      else if (Get.find<PromptController>().indexPage.value == 2){
                        showModalBottomSheet<dynamic>(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => JourneyPlannerModalSubmit(videoUrl: urlFromClipBoard,videoId: ''),
                        );
                      }
                      // if (Get.find<PromptController>().indexPage.value < 2){
                      //   setState(() {
                      //     Get.find<PromptController>().indexPage.value++;
                      //   });
                      //   Get.find<PromptController>().pageController?.animateToPage(Get.find<PromptController>().indexPage.value,
                      //       duration: Duration(milliseconds: 200),
                      //       curve: Curves.linear);
                      // }else{
                      //   Get.back();
                      // }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 3.h),
                      child: Container(
                          width: 100.w,
                          height: 15.w,
                          decoration: const BoxDecoration(
                              color: Color(0xFF4D32F8),
                              borderRadius: BorderRadius.all(Radius.circular(100))
                          ),
                          child: Center(
                              child: Text(
                                 "Next",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w800),
                              )
                
                          )
                      ),
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}