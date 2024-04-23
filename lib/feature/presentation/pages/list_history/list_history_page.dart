import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight/feature/presentation/manager/journey_highlight/journey_highlight_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_highlight/journey_highlight_event.dart';
import 'package:starlight/feature/presentation/manager/journey_summary/journey_summary_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_summary/journey_summary_event.dart';
import 'package:starlight/feature/presentation/manager/list_history/list_history_bloc.dart';
import 'package:starlight/feature/presentation/manager/list_history/list_history_state.dart';
import 'package:starlight/feature/presentation/pages/summary/summary_page.dart';
import 'package:starlight/feature/presentation/pages/trip/trip_page.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/constants/images.dart';
import '../../../../injection_container.dart';
import '../../manager/list_history/list_history_event.dart';
import '../../manager/navigation_controller.dart';

class ListHistoryPage extends StatefulWidget {
  const ListHistoryPage({super.key});

  @override
  State<ListHistoryPage> createState() => _ListHistoryPageState();
}

class _ListHistoryPageState extends State<ListHistoryPage> {
  final ScrollController _scrollController = ScrollController();
  double _opacity = 1;
  bool _appbar = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      print(_scrollController.offset);
      if (_scrollController.offset < 0) {
        setState(() {
          _opacity = 1;
        });
      } else if (_scrollController.offset < 5.h) {
        setState(() {
          _opacity = 1 - (_scrollController.offset / 5.h).abs();
          _appbar = false;
        });
      } else {
        setState(() {
          _opacity = 0;
        });
      }

      if (_scrollController.offset > 25.h) {
        setState(() {
          _appbar = true;
        });
      } else {
        setState(() {
          _appbar = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(opacity: 0.8, child: Image.asset(homeGradient)),
        _buildListHistory(),
        _buildHomeMenu()
      ],
    );
  }

  _buildListHistory() {
    return Padding(
      padding: EdgeInsets.only(top: 25.w),
      child: Container(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 4.h),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 80.h,
                  minWidth: 100.w,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FBFE),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      bloc.BlocBuilder<ListHistoryBloc, ListHistoryState>(
                          builder: (_, state) {
                        if (state is ListHistoryLoadingState) {
                          return Container(
                              height: 50.h,
                              child:
                                  Center(child: CircularProgressIndicator()));
                        }
                        if (state is ListHistoryLoadedState) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: .5.h, bottom: 2.h),
                              child: ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.h, horizontal: 2.h),
                                  shrinkWrap: true,
                                  itemCount: state.list?.items.length,
                                  itemBuilder: (context, index) {
                                    print("index " +
                                        state.list!.items[index].status
                                            .toString());
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 1.5.h),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (state.list!.items[index].status
                                                  .toString() ==
                                              "success") {
                                            bloc.BlocProvider.of<
                                                    JourneySummaryBloc>(context)
                                                .add(GetSummaryVideo(
                                                    id: state.list?.items[index]
                                                            .queueId ??
                                                        ""));
                                            bloc.BlocProvider.of<
                                                    JourneyHighlightBloc>(context)
                                                .add(GetHighlight(
                                                    Id: state.list?.items[index]
                                                            .queueId ??
                                                        ""));

                                            Get.to(
                                                transition:
                                                    Transition.rightToLeft,
                                                arguments:
                                                    state.list?.items[index],
                                                () => SummaryPage());
                                          }
                                        },
                                        child: Container(
                                          height: 18.h,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(16),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: shadowColor
                                                      .withOpacity(0.3),
                                                  offset: Offset(0, 4),
                                                  blurRadius: 12,
                                                )
                                              ]),
                                          child: Row(
                                            children: [

                                              Padding(
                                                padding: EdgeInsets.all(1.5.h),
                                                child: Container(
                                                  width: 18.h,
                                                  height: 15.h,

                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    child: CachedNetworkImage(
                                                        imageUrl: state
                                                                .list
                                                                ?.items[index]
                                                                .thumbnails ??
                                                            "",fit: BoxFit.cover,),
                                                  ),
                                                ),
                                              ),
                                              Expanded(

                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 2.h,bottom: 2.h, right: 2.h),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [

                                                      Row(children: [
                                                        SvgPicture.asset(youtubeLogo,width: 5.w,),
                                                        SizedBox(width: 1.w,),
                                                        Text(state.list?.items[index].channelName ?? "", style: TextStyle(color: Color(0xFF646C9C),fontSize: 14.sp,fontWeight: FontWeight.w600,fontFamily: 'inter'),)
                                                      ],),
                                                      SizedBox(height: 1.h,),
                                                      Text(
                                                        state.list?.items[index]
                                                                .title ??
                                                            "",
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontFamily: 'inter'),
                                                      ),
                                                      SizedBox(
                                                        height: .5.h,
                                                      ),
                                                      Spacer(),
                                                      Row(children: [
                                                        Text(state.list!.items[index].isUseSubtitle ? "Normal Mode": "Advance Mode",style: TextStyle(fontFamily: 'inter',fontWeight: FontWeight.w600, fontSize: 12.sp,color: Color(0xFF201E38).withOpacity(0.6)),),
                                                        Spacer(),
                                                        state.list!.items[index].status == "success"? Container(
                                                          decoration: BoxDecoration(
                                                            color: Color(0xFF52C883),
                                                            borderRadius: BorderRadius.circular(48)
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.only(right: 1.h,left: .5.h,top: .2.h, bottom: .2.h),
                                                            child: Row(
                                                              children: [
                                                                Icon(EvaIcons.checkmark,color: Colors.white,size: 18.sp,),
                                                                SizedBox(width: .5.w,),
                                                                Text('Success',style: TextStyle(color: Colors.white,fontSize: 14.sp,fontWeight: FontWeight.w700,fontFamily: 'inter'),)
                                                              ],
                                                            ),
                                                          ),
                                                        ): state.list!.items[index].status == "pending"? Container(
                                                          decoration: BoxDecoration(
                                                              color: Color(0xFFFFA800),
                                                              borderRadius: BorderRadius.circular(48)
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.only(right: 1.h,left: .5.h,top: .2.h, bottom: .2.h),
                                                            child: Row(
                                                              children: [
                                                                Icon(EvaIcons.loaderOutline,color: Colors.white,size: 18.sp,),
                                                                SizedBox(width: .5.w,),
                                                                Text('Pending',style: TextStyle(color: Colors.white,fontSize: 14.sp,fontWeight: FontWeight.w700,fontFamily: 'inter'),)
                                                              ],
                                                            ),
                                                          ),
                                                        ): Container(
                                                          decoration: BoxDecoration(
                                                              color: Color(0xFFFF522D),
                                                              borderRadius: BorderRadius.circular(48)
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.only(right: 1.h,left: .5.h,top: .2.h, bottom: .2.h),
                                                            child: Row(
                                                              children: [
                                                                Icon(EvaIcons.close,color: Colors.white,size: 18.sp,),
                                                                SizedBox(width: .5.w,),
                                                                Text('Failed',style: TextStyle(color: Colors.white,fontSize: 14.sp,fontWeight: FontWeight.w700,fontFamily: 'inter'),)
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }

  _buildHomeMenu() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 2.5.h, right: 2.5.h),
        child: GestureDetector(
          onTap: () {
            sl<ListHistoryBloc>()
              ..add(GetListHistory(
                  userId: Get.find<NavigationController>().uid.value));
          },
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "My Journey",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Obx(
                    () => CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          Get.find<NavigationController>().profile.value ?? ""),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
