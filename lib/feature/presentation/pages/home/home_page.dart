import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starlight/core/constants/colors.dart';
import 'package:starlight/feature/presentation/manager/home/home_event.dart';
import 'package:starlight/feature/presentation/manager/navigation_controller.dart';
import 'package:starlight/feature/presentation/pages/journey_planner/journey_planner_page.dart';
import 'package:starlight/feature/presentation/manager/home/home_bloc.dart';
import 'package:starlight/feature/presentation/manager/home/home_state.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/constants/images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  final ScrollController _scrollController = ScrollController();
  double _opacity = 1;
  bool _appbar = false;
  var chipList = ["Travel", "Beach", "Food", "Mountain", "Palace"];
  var chipIndex = 0;

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
        Opacity(opacity: 1, child: Image.asset(homeGradient)),
        _buildDailyJourney(),
        _buildHomeMenu()
      ],
    );
  }

  _buildDailyJourney() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(top: 7.h),
        child: Container(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(height: 16.h),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 80.h,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 3.h, left: 2.5.h,right: 2.5.h,bottom: 2.h),
                          child: Text(
                            "Daily Journey",
                            style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          height: 4.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                              itemBuilder: (context,index){
                            return GestureDetector(
                              onTap: (){
                                 setState(() {
                                   chipIndex = index;
                                 });
                                bloc.BlocProvider.of<HomeBloc>(context).add(YoutubeSearch( word: chipList[chipIndex] + " Thailand"));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 1.w, left: index == 0 ? 2.5.h : 0 ),
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: chipIndex == index ?Color(0xFF4D32F8) : Colors.white,
                                      border: Border.all(color: chipIndex == index ?Color(0xFF4D32F8) : Color(0x03009C) .withOpacity(0.2)),
                                      borderRadius: BorderRadius.circular(24)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 1.w,),
                                          Text(chipList[index],style: TextStyle(fontWeight: FontWeight.w600,color: chipIndex == index? Colors.white : Colors.black),),
                                          SizedBox(width: 1.w,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        _buildBlocJourney()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildHomeMenu() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 2.5.h, right: 2.5.h),
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _appbar
                  ? GestureDetector(
                onTap: (){
                  _scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                },
                    child: Padding(
                      padding: EdgeInsets.only(top: .6.h),
                      child: Container(
                          width: 100.w,
                          child: Text(
                            "Daily Journey",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                    ),
                  )
                  : Obx(
                () => Row(
                        children: [
                          Text(
                            Get.find<NavigationController>().name.value,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                Get.find<NavigationController>().profile.value ?? ""),
                          )
                        ],
                      ),
                  ),
            ),
            SizedBox(
              height: 3.h * _opacity,
            ),
            _opacity == 0
                ? Container()
                : AnimatedOpacity(
                    opacity: _opacity,
                    duration: Duration(milliseconds: 100),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(
                                  transition: Transition.rightToLeft,
                                  () => JourneyPlannerPage());
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 650),
                              height: 10.h,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.16),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              tripGenIcon,
                                              scale: 2.5,
                                            ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Text(
                                              "Trip Generator",
                                              style: TextStyle(
                                                  color: homeTitle,
                                                  fontFamily: 'poppins',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.sp),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 0.5.h,
                                        ),
                                        Text(
                                          "Provide a youtube link \nthen get the trip powered by Gemini",
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.6),
                                              fontFamily: 'inter',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Icon(
                                      EvaIcons.arrowIosForward,
                                      color: Colors.white,
                                      size: 24.sp,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  _buildBlocJourney() {
    return bloc.BlocBuilder<HomeBloc, HomeState>(builder: (_, state) {
      if (state is HomeLoadingState) {
        return Container(
          height: 50.h,
          child: const Center(
            child: CupertinoActivityIndicator(),
          ),
        );
      }
      if (state is HomeErrorState) {
        return Container(
          height: 50.h,
          child: Center(
            child: IconButton(icon: Icon(Icons.refresh), onPressed: () {
              
            },),
          ),
        );
      }
      if (state is HomeLoadedState) {
        return Padding(
          padding: EdgeInsets.only(left: 2.5.h,right: 2.5.h,bottom: 1.h),
          child: MasonryGridView.builder(
              padding: EdgeInsets.only(top: 2.h),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: state.list!.items?.length,
              crossAxisSpacing: 1.5.h,
              mainAxisSpacing: 1.5.h,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => {
                    Get.to(
                      transition: Transition.rightToLeft,
                      arguments: state.list!.items![index].id?.videoId,
                      () => JourneyPlannerPage())
                },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor.withOpacity(0.3),
                            offset: Offset(0,2),
                            blurRadius: 25
                          )
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Wrap(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12)),
                          child: CachedNetworkImage(
                            imageUrl: state.list!.items![index].snippet!.thumbnails
                                    ?.medium?.url ??
                                "",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            child: Text(
                              state.list!.items![index].snippet!.title ?? "",
                              style: TextStyle(
                                  fontFamily: 'inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp),
                              maxLines: index % 3 == 0
                                  ? 3
                                  : index % 3 == 1
                                      ? 2
                                      : 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.w, right: 2.5.w, top: 1.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFFDBE4FD),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: .5.h),
                                  child: Row(
                                    children: [
                                      FaIcon(FontAwesomeIcons.youtube, size: 15.sp,
                                          color: const Color(0xFF0034A0)),
                                      SizedBox(
                                        width: 1.w,
                                      ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: 25.w
                                        ),
                                        child: Text(
                                          state.list!.items![index].snippet!
                                              .channelTitle!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Color(0xFF0034A0),
                                              fontFamily: 'inter',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        );
      }

      return const SizedBox();
    });
  }
}
