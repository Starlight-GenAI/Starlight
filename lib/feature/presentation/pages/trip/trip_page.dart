import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:starlight/feature/presentation/manager/trip_planner/trip_planner_bloc.dart';
import 'package:starlight/feature/presentation/manager/trip_planner/trip_planner_state.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/icons.dart';
import '../../widget/draggable_bottom_sheet.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> with TickerProviderStateMixin {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  late AnimationController pageController;
  final indicatorController =
  PageController(viewportFraction: 0.8, keepPage: true);
  var selectedIndex = 0;
  CarouselController carouselController = CarouselController();
  final colorList = [
    Color(0xFF4D32F8),
    Color(0xFF13C125),
    Colors.red,
    Colors.deepPurpleAccent,
    Colors.orange
  ];
  final lorem =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. ";
  String getImage(String refLink) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=700&photo_reference=" +
        refLink +
        "&key="+placeAPIKey+"&maxheight=400";
  }

  @override
  void initState() {
    super.initState();
    pageController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripPlannerBloc, TripPlannerState>(
      builder: (_, state){
        if (state is TripPlannerLoadedState){
          return Scaffold(
              body: DraggableBottomSheet(
                duration: Duration(milliseconds: 50),
                minExtent: 50.h,
                useSafeArea: false,
                maxExtent: 90.h,
                previewWidget: _previewWidget(pageController,state),
                backgroundWidget: _backgroundWidget(state),
                expandedWidget: _expandedWidget(state),
                expansionExtent: 1,
                onDragging: (res) {},
                controller: pageController,
              ));
        }
        return Container();
      }
    );
  }

  Widget _previewWidget(AnimationController controller, TripPlannerState state) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0.0, 1.5),
      ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticIn)),
      child: Column(
        children: [
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                EvaIcons.arrowCircleUp,
                color: Color(0xFF5F5F61).withOpacity(0.8),
              ),
              SizedBox(
                width: .3.h,
              ),
              Text(
                'Swipe up to see more',
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'inter',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5F5F61)),
              ),
            ],
          ),
          Expanded(
            child: CarouselSlider.builder(
                carouselController: carouselController,
                itemCount: state.list?.content?[selectedIndex].locationWithSummary?.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  return Padding(
                    padding: EdgeInsets.only(right: 1.h, top: 1.h),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 5.h,
                        // width: 30.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 4,
                                  spreadRadius: 4)
                            ]),
                        child: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: Row(
                            children: [
                              Container(
                                width: 16.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            getImage(
                                              state.list?.content?[selectedIndex].locationWithSummary?[itemIndex].photo ?? "",

                                            )),
                                        fit: BoxFit.fill)),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: .5.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.list?.content?[selectedIndex].locationWithSummary?[itemIndex].locationName ?? "",
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'inter'),
                                      ),
                                      Spacer(),
                                      Text(
                                        state.list?.content?[selectedIndex].locationWithSummary?[itemIndex].summary ?? "",

                                        maxLines: 3,
                                        style: TextStyle(
                                            color: Color(0xFF686868),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'inter'),
                                      ),
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
                },
                options: CarouselOptions(
                    scrollPhysics: BouncingScrollPhysics(),
                    enableInfiniteScroll: false,
                    autoPlay: false,
                    viewportFraction: 0.85,
                    initialPage: 0,
                    height: 16.h,
                    disableCenter: true,
                    pageSnapping: true)),
          ),
          SizedBox(
            height: 2.h,
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.h),
              child: Container(
                height: 5.h,
                decoration: BoxDecoration(
                    color: Color(0xFF4D32F8),
                    borderRadius: BorderRadius.circular(48)),
                child: Padding(
                  padding: EdgeInsets.only(left: 2.h, right: 2.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 25.w,
                          child: Text(
                            "Day "+ (selectedIndex + 1).toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp),
                          )),
                      Spacer(),
                      AnimatedSmoothIndicator(
                        count: state.list?.content?.length ?? 3,
                        activeIndex: selectedIndex,
                        effect: ExpandingDotsEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            expansionFactor: 2,
                            activeDotColor: Colors.white,
                            dotColor: Colors.white.withOpacity(0.50)),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                if (selectedIndex>0){
                                  setState(() {
                                    selectedIndex = selectedIndex - 1;
                                  });
                                  carouselController.animateToPage(0,duration: Duration(milliseconds: 400));


                                }

                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 18.sp,
                                color: (selectedIndex>0) ? Colors.white : Colors.white.withOpacity(0.2)
                              )),
                          IconButton(
                              onPressed: () {
                                if(selectedIndex < ((state.list?.content?.length ) ?? 0)-1)
                                setState(() {
                                  selectedIndex = selectedIndex + 1;
                                });

                                carouselController.animateToPage(0,duration: Duration(milliseconds: 400));
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 18.sp,
                                  color: (selectedIndex < ((state.list?.content?.length ) ?? 0)-1) ? Colors.white : Colors.white.withOpacity(0.2)

                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backgroundWidget(TripPlannerState state) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      myLocationButtonEnabled: false,
    );
  }

  Widget _expandedWidget(TripPlannerState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 3.h, right: 3.h),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Summary plan : Bangkok",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'poppins',
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            lorem,
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'inter',
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: 80.h, maxHeight: double.infinity),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: 3.h, right: 3.h, bottom: 1.h),
                          child: Stack(
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VerticalDivider(
                                      color: Color(0xFFC7CEDF),
                                      thickness: 2,
                                      width: 2.h,
                                      indent: 2.5.h,
                                    ),
                                    SizedBox(width: 2.h),
                                    Expanded(
                                      flex: 6,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 2.h),
                                        child: Container(
                                          width: 10.w,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            boxShadow: [
                                              BoxShadow(
                                                color: shadowColor
                                                    .withOpacity(0.3),
                                                offset: Offset(0, 4),
                                                blurRadius: 12,
                                              )
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.5.h),
                                                child: Container(
                                                  width: 1.w,
                                                  decoration: BoxDecoration(
                                                    color: colorList[index %
                                                        colorList.length],
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(24),
                                                      bottomRight:
                                                          Radius.circular(24),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(2.h),
                                                  child:
                                                      Text(lorem * (index + 2)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 2.h,
                                child: SvgPicture.asset(
                                  index == 0 ? iconPinStart : iconPinEnd,
                                  width: index == 0 ? 2.h : 1.5.h,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(1.h),
            child: Container(
              height: .6.h,
              width: 20.w,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(48)),
            ),
          )
        ],
      ),
    );
  }
}

