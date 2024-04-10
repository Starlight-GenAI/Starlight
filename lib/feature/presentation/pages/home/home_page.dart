import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/core/constants/colors.dart';
import 'package:starlight/feature/presentation/pages/journey_planner/journey_planner_page.dart';
import 'package:starlight/feature/presentation/manager/home/home_bloc.dart';
import 'package:starlight/feature/presentation/manager/home/home_state.dart';

import '../../../../core/constants/images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        _buildDailyJourney(),
        _buildHomeMenu()
      ],
    );
  }

  _buildDailyJourney() {
    return Padding(
      padding: EdgeInsets.only(top: 25.w),
      child: Container(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(height: 18.h),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 65.h,
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
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 3.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Daily Journey",
                          style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        _buildBlocJourney()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildHomeMenu() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 24, right: 24),
        height: 30.h,
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _appbar
                  ? Container(
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
                    )
                  : Row(
                      children: [
                        Text(
                          "Alexander P.",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              'https://www.georgetown.edu/wp-content/uploads/2022/02/Jkramerheadshot-scaled-e1645036825432-1050x1050-c-default.jpg'),
                        )
                      ],
                    ),
            ),
            SizedBox(
              height: 2.h * _opacity,
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
                              print('sdsaidjsaodsjaidasojadsiodj');
                            },
                            child: Container(
                              height: 13.h,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.16),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Stack(
                                children: [
                                  Positioned(
                                      bottom: 12,
                                      right: 12,
                                      child: Image.asset(
                                        menuSummarize,
                                        scale: 0.95,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        "Video \nSummary",
                                        style: TextStyle(
                                            color: homeTitle,
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.sp),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              print('sdsaidjsaodsjaidasojadsiodj');
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => JourneyPlannerPage()));
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 650),
                              height: 13.h,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.16),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Stack(
                                children: [
                                  Positioned(
                                      bottom: 12,
                                      right: 12,
                                      child: Image.asset(
                                        menuTripGen,
                                        scale: 0.95,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        "Trip \nGenerator",
                                        style: TextStyle(
                                            color: homeTitle,
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.sp),
                                      ))
                                ],
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
    return BlocBuilder<HomeBloc, HomeState>(builder: (_, state) {
      if (state is HomeLoadingState) {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      }
      if (state is HomeErrorState) {
        return Center(
          child: Icon(Icons.refresh),
        );
      }
      if (state is HomeLoadedState) {
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4.w,
              crossAxisSpacing: 4.w,
              childAspectRatio: 0.75),
          itemCount: state.list!.items?.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        topLeft: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl:
                      state.list!.items![index].snippet!.thumbnails?.high?.url ?? "",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        child: Text(
                          state.list!.items![index].snippet!.title ?? "",
                          style: TextStyle(
                              fontFamily: 'inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      }

      return const SizedBox();
    });
  }
}
