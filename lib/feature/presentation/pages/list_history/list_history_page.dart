import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
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
                                        } else {}
                                      },
                                      child: Container(
                                        height: 20.h,
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
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
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
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    state.list?.items[index]
                                                            .title ??
                                                        "",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'inter'),
                                                  ),
                                                  SizedBox(
                                                    height: .2.h,
                                                  ),
                                                  Text(
                                                      state.list?.items[index]
                                                              .description ??
                                                          "",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: Color(
                                                                  0xFF201E38)
                                                              .withOpacity(0.6),
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: 'inter')),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                                child: Icon(
                                              state.list?.items[index].status ==
                                                      "pending"
                                                  ? EvaIcons.downloadOutline
                                                  : state.list?.items[index]
                                                              .status ==
                                                          "failed"
                                                      ? EvaIcons.close
                                                      : state.list?.items[index]
                                                                  .status ==
                                                              "is_not_travel_video"
                                                          ? EvaIcons.minus
                                                          : EvaIcons.checkmark,
                                              size: 24.sp,
                                              color: state.list?.items[index]
                                                          .status ==
                                                      "pending"
                                                  ? Colors.blue
                                                  : state.list?.items[index]
                                                              .status ==
                                                          "failed"
                                                      ? Colors.red
                                                      : state.list?.items[index]
                                                                  .status ==
                                                              "is_not_travel_video"
                                                          ? Colors.yellow
                                                          : Color(0xFF009421),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
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
