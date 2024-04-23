import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/constants/colors.dart';
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
  var isBottom = false;
  late AnimationController pageController;
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();
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

  @override
  void initState() {
    super.initState();
    // _controller.addListener(_onChanged);
    pageController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DraggableBottomSheet(
      duration: Duration(milliseconds: 50),
      minExtent: 40.h,
      useSafeArea: false,
      maxExtent: 90.h,
      previewWidget: _previewWidget(pageController),
      backgroundWidget: _backgroundWidget(),
      expandedWidget: _expandedWidget(),
      expansionExtent: 1,
      onDragging: (res) {},
      controller: pageController,
    ));
  }

  Widget _previewWidget(AnimationController controller) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0.0, 1.5),
      ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticIn)),
      child: SafeArea(
        top: false,
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
                  itemCount: 4,
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
                                          image: NetworkImage(
                                              'https://s359.kapook.com/pagebuilder/6eac97c9-58a7-40f2-8def-44077ba5248b.jpg'),
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
                                          'Wat Arun dsasaassasasas',
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'inter'),
                                        ),
                                        Spacer(),
                                        Text(
                                          lorem,
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
          ],
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      myLocationButtonEnabled: false,
    );
  }

  _buildDrag() {
    DraggableScrollableSheet(
      key: _sheet,
      initialChildSize: 0.25,
      maxChildSize: 0.92,
      minChildSize: 0,
      expand: true,
      snap: true,
      snapSizes: [
        50 / 100.h,
        0.25,
      ],
      controller: _controller,
      builder: (BuildContext context, ScrollController scrollController) {
        return DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xFFF9FBFE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  // Set to true to keep the header pinned at the top
                  delegate: _SliverAppBarDelegate(
                      minHeight: 1.h, // Set the minimum height of the header
                      maxHeight: 20.h, // Set the maximum height of the header
                      child: CarouselSlider.builder(
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) {
                            return _controller.size < 0.02
                                ? Container(
                                    height: 20.h,
                                    color: Colors.red,
                                  )
                                : Container();
                          },
                          options: CarouselOptions(
                              scrollPhysics: BouncingScrollPhysics(),
                              enableInfiniteScroll: false,
                              autoPlay: false,
                              viewportFraction: 0.80,
                              initialPage: 0,
                              height: 20.h,
                              disableCenter: true,
                              pageSnapping:
                                  false) // Your widget that stays on top
                          )),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(3.h),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Summary plan : Bangkok",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'poppins'),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Text(
                                lorem,
                                style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'inter',
                                    fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: 1,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 3.h, right: 3.h, bottom: 1.h),
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
                                  SizedBox(
                                    width: 2.h,
                                  ),
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
                                            ]),
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
                                                            topRight: Radius
                                                                .circular(24),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    24))),
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
                                )),
                          ],
                        ),
                      );
                    },
                    childCount: 5,
                  ),
                ),
              ],
            ));
      },
    );
  }

  Widget _expandedWidget() {
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
                    padding: EdgeInsets.only(left:3.h,right: 3.h),
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
                      minHeight: 80.h,
                      maxHeight: double.infinity
                    ),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 3.h, right: 3.h, bottom: 1.h),
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
                                                child: Container(
                                                  width: 1.w,
                                                  decoration: BoxDecoration(
                                                    color: colorList[index % colorList.length],
                                                    borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(24),
                                                      bottomRight: Radius.circular(24),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(2.h),
                                                  child: Text(lorem * (index + 2)),
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
              decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(48)),
            ),
          )
        ],
      ),
    );

  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
