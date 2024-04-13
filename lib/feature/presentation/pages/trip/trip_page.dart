import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/icons.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

  final colorList = [Color(0xFF4D32F8), Color(0xFF13C125) , Colors.red, Colors.deepPurpleAccent, Colors.orange];

  final lorem = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. ";

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
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
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationButtonEnabled: false,
          ),
          DraggableScrollableSheet(
            key: _sheet,
            initialChildSize: 0.3,
            maxChildSize: 0.92,
            minChildSize: 0,
            expand: true,
            snap: true,
            snapSizes: [
              50 / 100.h,
              0.3,
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
                          maxHeight: 4.h, // Set the maximum height of the header
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 38.w, vertical: 1.6.h),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF171717),
                                  borderRadius: BorderRadius.circular(48)),
                            ),
                          ), // Your widget that stays on top
                        ),
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
                                    Text("Summary plan : Bangkok", style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w700,fontFamily: 'poppins'),),
                                    SizedBox(height: 1.h,),
                                    Text(lorem,style: TextStyle(color: Color(0xFF666666), fontWeight: FontWeight.w500, fontFamily: 'inter',fontSize: 14.sp),),
      
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
                              padding: EdgeInsets.only(left: 3.h,right: 3.h,bottom: 1.h),
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
                                        SizedBox(width: 2.h,),
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
                                                ]
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 4.5.h),
                                                    child: Container(
                                                      width: 1.w,
                                                      decoration: BoxDecoration(
                                                        color: colorList[index%colorList.length],
                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(24),bottomRight: Radius.circular(24))
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
                                      child: SvgPicture.asset(index == 0 ? iconPinStart : iconPinEnd,width: index == 0 ? 2.h:1.5.h,)),
      
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
          ),
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
