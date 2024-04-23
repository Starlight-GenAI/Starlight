import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:starlight/feature/presentation/manager/trip_planner/trip_planner_bloc.dart';
import 'package:starlight/feature/presentation/manager/trip_planner/trip_planner_state.dart';
import 'dart:ui' as ui;

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/icons.dart';
import '../../manager/navigation_controller.dart';
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
  var selectedExpanded = -1;
  CarouselController carouselController = CarouselController();
  final colorList = [
    Color(0xFF4D32F8),
    Color(0xFF13C125),
    Colors.red,
    Colors.deepPurpleAccent,
    Colors.orange
  ];

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  late BitmapDescriptor pinBlue;
  final lorem =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. ";
  String getImage(String refLink) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=700&photo_reference=" +
        refLink +
        "&key="+placeAPIKey+"&maxheight=400";
  }

  _addPin(TripPlannerState state){
    Get.find<NavigationController>().allMarkers.value.clear();
    state.list!.content?[selectedIndex].locationWithSummary?.forEach((element) {
      setState(() {
        Get.find<NavigationController>().allMarkers.value.add(Marker(markerId: MarkerId(element.placeId!),icon:pinBlue,position: LatLng(element.lat!,element.lng!)));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    pageController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripPlannerBloc, TripPlannerState>(
      builder: (_, state){
        if (state is TripPlannerLoadedState){
          return Scaffold(
              backgroundColor: backgroundMain,
              body: Stack(
                children: [
                  DraggableBottomSheet(
                    duration: Duration(milliseconds: 50),
                    minExtent: 45.h,
                    useSafeArea: false,
                    maxExtent: 90.h,
                    previewWidget: _previewWidget(pageController,state),
                    backgroundWidget: _backgroundWidget(state),
                    expandedWidget: _expandedWidget(state),
                    expansionExtent: 1,
                    onDragging: (res) {},
                    controller: pageController,
                  ),
                  Positioned(
                      top: 0,
                      left: 0,
                      child: SafeArea(
                        child: IconButton(
                          hoverColor: Colors.white,
                          icon: Icon(
                            EvaIcons.arrowIosBackOutline,
                            size: 24.sp,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ))
                ],
              ));
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));

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
                    pageSnapping: true,
                onPageChanged: (index, _) async {
                      print(index);
                      final GoogleMapController controller = await _mapController.future;
                      await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(state.list?.content?[selectedIndex].locationWithSummary?[index].lat ?? 0 ,state.list?.content?[selectedIndex].locationWithSummary?[index].lng ?? 0),zoom: 17)));
                })),
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
                              onPressed: () async {
                                if (selectedIndex>0){
                                  setState(() {
                                    selectedIndex = selectedIndex - 1;
                                  });
                                  _addPin(state);
                                  carouselController.animateToPage(0,duration: Duration(milliseconds: 400));
                                  final GoogleMapController controller = await _mapController.future;
                                  await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(state.list?.content?[selectedIndex].locationWithSummary?[0].lat ?? 0 ,state.list?.content?[selectedIndex].locationWithSummary?[0].lng ?? 0),zoom: 14.48)));
                                }

                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 18.sp,
                                color: (selectedIndex>0) ? Colors.white : Colors.white.withOpacity(0.2)
                              )),
                          IconButton(
                              onPressed: () async {
                                if(selectedIndex < ((state.list?.content?.length ) ?? 0)-1){
                                  setState(() {
                                    selectedIndex = selectedIndex + 1;
                                  });
                                  _addPin(state);

                                  carouselController.animateToPage(0,duration: Duration(milliseconds: 400));
                                  final GoogleMapController controller = await _mapController.future;
                                  await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(state.list?.content?[selectedIndex].locationWithSummary?[0].lat ?? 0 ,state.list?.content?[selectedIndex].locationWithSummary?[0].lng ?? 0),zoom: 14.48)));
                                }

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
    return Obx(
      () => GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) async {
          _mapController.complete(controller);
          pinBlue = await getBitmapDescriptorFromAssetBytes("assets/images/pin_blue.png", 60);

          _addPin(state);
          await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(state.list?.content?[selectedIndex].locationWithSummary?[0].lat ?? 0 ,state.list?.content?[selectedIndex].locationWithSummary?[0].lng ?? 0),zoom: 14.48)));

        },
        markers: Set<Marker>.of(Get.find<NavigationController>().allMarkers.value),
      ),
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
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 3.h,right: .5.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          child: Text(
                            "Day "+ (selectedIndex + 1).toString() + " of "+(state.list?.content?.length ?? 0).toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 18.sp),
                          )),
                      Spacer(),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                if (selectedIndex>0){
                                  setState(() {
                                    selectedIndex = selectedIndex - 1;
                                  });
                                  _addPin(state);
                                  carouselController.animateToPage(0,duration: Duration(milliseconds: 400));
                                  final GoogleMapController controller = await _mapController.future;
                                  await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(state.list?.content?[selectedIndex].locationWithSummary?[0].lat ?? 0 ,state.list?.content?[selectedIndex].locationWithSummary?[0].lng ?? 0),zoom: 14.48)));
                                }

                              },
                              icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 20.sp,
                                  color: (selectedIndex>0) ? Colors.black : Colors.black.withOpacity(0.2)
                              )),
                          IconButton(
                              onPressed: () async {
                                if(selectedIndex < ((state.list?.content?.length ) ?? 0)-1){
                                  setState(() {
                                    selectedIndex = selectedIndex + 1;
                                  });
                                  _addPin(state);

                                  carouselController.animateToPage(0,duration: Duration(milliseconds: 400));
                                  final GoogleMapController controller = await _mapController.future;
                                  await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(state.list?.content?[selectedIndex].locationWithSummary?[0].lat ?? 0 ,state.list?.content?[selectedIndex].locationWithSummary?[0].lng ?? 0),zoom: 14.48)));
                                }

                              },
                              icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 20.sp,
                                  color: (selectedIndex < ((state.list?.content?.length ) ?? 0)-1) ? Colors.black : Colors.black.withOpacity(0.2)

                              ))
                        ],
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: 80.h, maxHeight: double.infinity),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.list!.content?[selectedIndex].locationWithSummary?.length,
                        itemBuilder: (context, index) {
                          print("leo" +state.list!.content![selectedIndex].countDining.toString() );
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
                                      state.list!.content?[selectedIndex].locationWithSummary?[index].category == "dining"? Expanded(
                                        flex: 6,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 2.h),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minHeight: 10.h,
                                              maxHeight: double.infinity,
                                            ),
                                            child: Container(
                                              width: 10.w,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFE1E9FF),
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
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(2.h),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  state.list!.content![selectedIndex]
                                                                      .locationWithSummary?[index]
                                                                      .locationName ??
                                                                      "",
                                                                  style: TextStyle(
                                                                    color: Color(0xFF666666),
                                                                    fontFamily: 'inter',
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 14.sp,
                                                                  ),
                                                                  maxLines: 2,
                                                                ),
                                                                Spacer(),
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: colorList[index % colorList.length],
                                                                        borderRadius: BorderRadius.circular(48),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical: .5.h, horizontal: 1.h),
                                                                        child: Row(
                                                                          children: [
                                                                            Icon(
                                                                              EvaIcons.star,
                                                                              color: Color(0xFFFFBF1B),
                                                                              size: 15.sp,
                                                                            ),
                                                                            SizedBox(width: 1.w),
                                                                            Text((state.list!.content![selectedIndex]
                                                                                .locationWithSummary?[index].rating.toString() ?? "" )+ " Rating",
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontFamily: 'inter',
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 14.sp,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 2.h),
                                                      
                                                          Container(
                                                            height: 8.h,
                                                            width: 8.h,
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(100),
                                                              child: CachedNetworkImage(
                                                                imageUrl: getImage(state.list!
                                                                    .content![selectedIndex]
                                                                    .locationWithSummary?[index]
                                                                    .photo ??
                                                                    ""),
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
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
                                      )
                                          :Expanded(
                                        flex: 6,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 2.h),
                                          child: GestureDetector(
                                            onTap: (){
                                              if(selectedExpanded == index){
                                                setState(() {
                                                  selectedExpanded = -1;
                                                });
                                              }else{
                                                setState(() {
                                                  selectedExpanded = index;
                                                });
                                              }

                                            },
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxHeight: selectedExpanded == index ? double.infinity : 20.h,
                                              ),
                                              child: AnimatedContainer(
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
                                                duration: Duration(milliseconds: 200),
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
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    color: colorList[index % colorList.length],
                                                                    borderRadius: BorderRadius.circular(48),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical: .5.h, horizontal: 1.h),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          EvaIcons.pin,
                                                                          color: Colors.white,
                                                                          size: 15.sp,
                                                                        ),
                                                                        SizedBox(width: 1.w),
                                                                        Text(
                                                                          state.list!.content![selectedIndex]
                                                                              .locationWithSummary?[index]
                                                                              .locationName ??
                                                                              "",
                                                                          style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontFamily: 'inter',
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: 14.sp,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 2.h),
                                                            AnimatedSwitcher(
                                                              duration: Duration(milliseconds: 200),
                                                              child: selectedExpanded == index
                                                                  ? Column(
                                                                children: [
                                                                  Container(
                                                                    height: 16.h,
                                                                    width: 100.w,
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      child: CachedNetworkImage(
                                                                        imageUrl: getImage(state.list!
                                                                            .content![selectedIndex]
                                                                            .locationWithSummary?[index]
                                                                            .photo ??
                                                                            ""),
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 2.h),
                                                                  Text(
                                                                    state.list!.content![selectedIndex]
                                                                        .locationWithSummary?[index]
                                                                        .summary ??
                                                                        "",
                                                                    style: TextStyle(
                                                                      color: Color(0xFF666666),
                                                                      fontFamily: 'inter',
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 14.sp,
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                                  : Row(
                                                                children: [
                                                                  Container(
                                                                    height: 10.h,
                                                                    width: 14.h,
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      child: CachedNetworkImage(
                                                                        imageUrl: getImage(state.list!
                                                                            .content![selectedIndex]
                                                                            .locationWithSummary?[index]
                                                                            .photo ??
                                                                            ""),
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 2.h),
                                                                  Expanded(
                                                                    child: Text(
                                                                      state.list!.content![selectedIndex]
                                                                          .locationWithSummary?[index]
                                                                          .summary ??
                                                                          "",
                                                                      style: TextStyle(
                                                                        color: Color(0xFF666666),
                                                                        fontFamily: 'inter',
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 14.sp,
                                                                      ),
                                                                      maxLines: 5,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
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
                  ),
                ),
              ],
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

