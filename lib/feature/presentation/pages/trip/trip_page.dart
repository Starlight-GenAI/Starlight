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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:starlight/feature/domain/entities/trip_planner/trip_planner.dart';
import 'package:starlight/feature/presentation/manager/trip_planner/trip_planner_bloc.dart';
import 'package:starlight/feature/presentation/manager/trip_planner/trip_planner_state.dart';
import 'package:starlight/feature/presentation/pages/customize/customize_select_page.dart';
import 'dart:ui' as ui;
import 'package:get/get_navigation/src/routes/transitions_type.dart' as page;

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
  final scrollController = ScrollController();
  final indicatorController =
  PageController(viewportFraction: 0.8, keepPage: true);
  var selectedIndex = 0;
  var selectedExpanded = -1;
  CarouselController carouselController = CarouselController();
  final colorList = [
    {'majorColor': Color(0xFF4D32F8), 'mainColor': Color(0xFF647AFF), 'lightColor': Color(0xFFE1E9FF)},
    {'majorColor': Color(0xFF774198), 'mainColor': Color(0xFF6F63B0), 'lightColor': Color(0xFFE3DEFE)},
    {'majorColor': Color(0xFF13C18D), 'mainColor': Color(0xFF355939), 'lightColor': Color(0xFFA3F3AB)},
    {'majorColor': Color(0xFFE41F4F), 'mainColor': Color(0xFF973B51), 'lightColor': Color(0xFFFFD3D8)},
    {'majorColor': Color(0xFFFF7A00), 'mainColor': Color(0xFF905824), 'lightColor': Color(0xFFFFEBD3)}
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

  _formatText(text) {
    try {
      if (text.contains('##')) {
        const start = "## ";
        final checkColon = text.contains(':') && !hasNewlineBeforeColon(text);
        // final hasNewlineBeforeColon = !text.substring(0, text.contains(':')).contains('\n');
        final end = checkColon ? ":" : '\n';
        final startIndex = text.indexOf(start);
        int endIndex = text.indexOf(end, startIndex + start.length);
        final title = text.substring(startIndex + start.length, endIndex + 1);

        int indexToRemove = checkColon ? text.indexOf(":") : text.indexOf("\n");
        String textRemoveTitle = text.substring(indexToRemove + 1);
        final splitText = textRemoveTitle.contains('**')
            ? textRemoveTitle.split("**")
            : [textRemoveTitle];

        return [title, ...splitText];
      } else if (text.contains('**')) {
        return text.split("**");
      } else {
        return text;
      }
    }
    catch(e){
      return text;
    }
  }

  bool hasNewlineBeforeColon(String text) {
    final index = text.indexOf(':');
    return index != -1 && text.substring(0, index).contains('\n');
  }

  @override
  void initState() {
    super.initState();
    pageController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollToStart();
    });
  }

  void _scrollToStart() {
    scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
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
                    minExtent: 50.h,
                    useSafeArea: false,
                    maxExtent: 90.h,
                    previewWidget: _previewWidget(pageController,state),
                    backgroundWidget: _backgroundWidget(state),
                    expandedWidget: _expandedWidget(state),
                    expansionExtent: 1,
                    onDragging: (res) {

                      setState(() {
                        Get.find<NavigationController>().toTop.value = (1- ((res - 50.h) / (90.h - 50.h))).clamp(0.0, 1.0);
                      });
                      print("res$res");
                      print("${100.h}");


                    },
                    controller: pageController,
                  ),
                  Positioned(
                      top: 0,
                      left: 0,
                      child: Obx(
                        ()=> AnimatedOpacity(
                          duration: Duration(milliseconds: 100),
                          opacity: Get.find<NavigationController>().toTop.value,
                          child: SafeArea(
                            child: Container(
                              width: 100.w,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1.h,vertical: 1.h),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 11.w,
                                      height: 11.w,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(100),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                offset: Offset(0,1),
                                                blurRadius: 24
                                            )
                                          ]
                                      ),
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
                                    Spacer(),

                                    Container(
                                      width: 24.w,
                                      height: 11.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 20,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(24),
                                        child: ClipOval(
                                          child: InkWell(
                                            customBorder: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(24)
                                            ),
                                            onTap: () {
                                              Share.share('Check out my incredible trip generated by Starlight! : https://example.com');
                                            },
                                            splashColor: Colors.grey.withOpacity(0.5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(shareIcon),
                                                SizedBox(width: 2.w,),
                                                Text("Share",style: TextStyle(fontFamily: 'inter',fontWeight: FontWeight.w700),)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )



                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),

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
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        EvaIcons.arrowUpwardOutline,
                        color: Colors.black,
                        size: 16.sp,
                      ),
                      SizedBox(
                        width: .5.h,
                      ),
                      Text(
                        'Swipe up to see more',
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'inter',
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: CarouselSlider.builder(
                carouselController: carouselController,
                itemCount: state.list?.content?[selectedIndex].locationWithSummary?.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  final summaryText = state.list?.content?[selectedIndex].locationWithSummary?[itemIndex].summary;
                  final textList = _formatText(summaryText!);
                  return Padding(
                    padding: EdgeInsets.only(right: 1.h, top: 1.h),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        // height: 1.h,
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
                                    color: Colors.grey.withOpacity(0.2),
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          (state.list?.content?[selectedIndex].locationWithSummary?[itemIndex].photos?.length == 0)  ? "":
                                            getImage(
                                              state.list?.content?[selectedIndex].locationWithSummary?[itemIndex].photos?[0] ?? "",

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
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            height: 1.3,
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'inter'),
                                      ),
                                      Spacer(),
                                      summaryText.contains('##') ? RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4,
                                        text: _buildNewTextFormat(textList, false),
                                      ) : Text(
                                        state.list!.content![selectedIndex]
                                            .locationWithSummary?[itemIndex]
                                            .summary?.replaceAll('\n', ' ') ??
                                            "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(
                                          color: Color(0xFF666666),
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
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
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(left: 2.h,right: 2.h, bottom: 2.h),
              child: Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  Container(
                    height: 5.3.h,
                    padding: EdgeInsets.only(left: 7.w, right: 2.w),
                    decoration: BoxDecoration(
                        color: Color(0xFF4D32F8),
                        borderRadius: BorderRadius.circular(48)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Center(
                    child: AnimatedSmoothIndicator(
                      count: state.list?.content?.length ?? 3,
                      activeIndex: selectedIndex,
                      effect: ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          expansionFactor: 2,
                          activeDotColor: Colors.white,
                          dotColor: Colors.white.withOpacity(0.50)),
                    ),
                  )
                ],
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
        mapToolbarEnabled: false,
        compassEnabled: false,
        zoomControlsEnabled: false,
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
        color: Color(0xFFF9FBFE),
        borderRadius: BorderRadius.only(topRight: Radius.circular(32),topLeft: Radius.circular(32)),
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
                                _scrollToStart();
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
                                _scrollToStart();
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
                //list trip expanded
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: 80.h, maxHeight: double.infinity),
                          child: ListView.builder(
                            controller: scrollController,
                            padding: EdgeInsets.only(top: 5.w),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.list!.content?[selectedIndex].locationWithSummary?.length,
                            itemBuilder: (context, index) {
                              final allLocation = state.list!.content?[selectedIndex].locationWithSummary;
                              final summaryText = state.list!.content![selectedIndex]
                                  .locationWithSummary?[index].summary;
                              final textList = _formatText(summaryText);
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 3.h, right: 3.h, bottom: (index == allLocation!.length + 1)
                                    && state.list!.content?[selectedIndex].locationWithSummary?[index + 1].category != "recommended_dining" ? 1.h : 0),
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
                                          state.list!.content?[selectedIndex].locationWithSummary?[index].category == "dining" ||
                                          state.list!.content?[selectedIndex].locationWithSummary?[index].category == "recommended_dining"? Expanded(
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
                                                    color: state.list!.content?[selectedIndex].locationWithSummary?[index].category == 'dining' ?
                                                    colorList[index % colorList.length]['lightColor'] :
                                                    colorList[(index-1) % colorList.length]['lightColor'],
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
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            state.list!.content?[selectedIndex].locationWithSummary?[index].category != 'dining' ? Padding(
                                                              padding: EdgeInsets.only(right: 2.h),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: state.list!.content?[selectedIndex].locationWithSummary?[index].category == 'dining' ?
                                                                  colorList[index % colorList.length]['mainColor']?.withOpacity(0.5) :
                                                                  colorList[(index-1) % colorList.length]['mainColor']?.withOpacity(0.5),
                                                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(vertical: 1.w, horizontal: 6.w),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      FaIcon(FontAwesomeIcons.starOfLife, size: 13.sp,
                                                                          color: Colors.white),
                                                                      SizedBox(width: 1.w,),
                                                                      Text("Recommend Diner by Starlight",
                                                                        style: TextStyle(
                                                                          color: Colors.white,
                                                                          fontFamily: 'inter',
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: 12.5.sp,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ) : const SizedBox(),
                                                            Padding(
                                                              padding: EdgeInsets.all(2.h),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        RichText(
                                                                          overflow: TextOverflow.ellipsis,
                                                                          maxLines: 3,
                                                                            text: TextSpan(
                                                                              style: const TextStyle(
                                                                                height: 1.3
                                                                              ),
                                                                              children: [
                                                                                TextSpan(text: "${state.list!.content![selectedIndex]
                                                                                    .locationWithSummary![index]
                                                                                    .locationName!} - " ?? "", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, fontFamily: 'inter',color: Colors.black)),
                                                                                TextSpan(text: "${state.list!.content![selectedIndex]
                                                                                    .locationWithSummary![index]
                                                                                    .summary!.replaceAll("##", "").replaceAll("\n", "")} - " ?? "", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600,fontFamily: 'inter',color: Color(0xFF44464D)))
                                                                              ]
                                                                            )
                                                                        ),
                                                                        SizedBox(height: 3.w,),
                                                                        Row(
                                                                          children: [
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                color: state.list!.content?[selectedIndex].locationWithSummary?[index].category == 'dining' ?
                                                                                colorList[index % colorList.length]['mainColor'] :
                                                                                colorList[(index-1) % colorList.length]['mainColor'],
                                                                                borderRadius: BorderRadius.circular(48),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.symmetric(
                                                                                    vertical: .5.h, horizontal: 2.5.w),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      EvaIcons.star,
                                                                                      color: Color(0xFFFFBF1B),
                                                                                      size: 15.sp,
                                                                                    ),
                                                                                    SizedBox(width: 1.w),
                                                                                    Text((state.list!.content![selectedIndex]
                                                                                        .locationWithSummary?[index].rating) == 0?"5.0 Rating" :"${state.list!.content![selectedIndex]
                                                                                        .locationWithSummary?[index].rating.toString() ?? ""} Rating",
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

                                                                        imageUrl: state.list!
                                                                            .content![selectedIndex]
                                                                            .locationWithSummary![index]
                                                                            .photos!.isEmpty ? "" : getImage(state.list!
                                                                            .content![selectedIndex]
                                                                            .locationWithSummary?[index]
                                                                            .photos?[0] ??
                                                                            ""),
                                                                        fit: BoxFit.cover,
                                                                        errorWidget: (context, url, error) => Container(),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          ],
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
                                                              color: colorList[index % colorList.length]['majorColor'],
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
                                                                        color: colorList[index % colorList.length]['lightColor'],
                                                                        borderRadius: BorderRadius.circular(48),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical: .5.h, horizontal: 3.w),
                                                                        child: Row(
                                                                          children: [
                                                                            state.list!.content![selectedIndex]
                                                                                .locationWithSummary?[index]
                                                                                .category == 'hotel' ? FaIcon(FontAwesomeIcons.hotel, size: 14.sp,
                                                                                color: Colors.black) : Icon(
                                                                              EvaIcons.pin,
                                                                              color: Colors.black,
                                                                              size: 15.sp,
                                                                            ),
                                                                            SizedBox(width: 1.w),
                                                                            ConstrainedBox(
                                                                              constraints: BoxConstraints(
                                                                                maxWidth: 54.w
                                                                              ),
                                                                              child: Text(
                                                                                state.list!.content![selectedIndex]
                                                                                    .locationWithSummary?[index]
                                                                                    .locationName ??
                                                                                    "",
                                                                                style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontFamily: 'inter',
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: 14.sp,
                                                                                  overflow: TextOverflow.ellipsis
                                                                                ),
                                                                                maxLines: 1,
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
                                                                                .photos?[0] ??
                                                                                ""),
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 2.h),
                                                                      summaryText!.contains('##') ? RichText(
                                                                        text: _buildNewTextFormat(textList, true),
                                                                      ) : Text(
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
                                                                                .photos?[0] ??
                                                                                ""),
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 2.h),
                                                                      Expanded(
                                                                        child: summaryText!.contains('##') ? RichText(
                                                                          maxLines: 4,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          text: _buildNewTextFormat(textList, false),
                                                                        ) : Text(
                                                                          state.list!.content![selectedIndex]
                                                                              .locationWithSummary?[index]
                                                                              .summary?.replaceAll('\n', ' ') ??
                                                                              "",
                                                                          style: TextStyle(
                                                                            color: Color(0xFF666666),
                                                                            fontFamily: 'inter',
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: 14.sp,
                                                                          ),
                                                                          maxLines: 4,
                                                                          overflow: TextOverflow.ellipsis,
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
                                    state.list!.content?[selectedIndex].locationWithSummary?[index].category != "recommended_dining" ? SizedBox(
                                      width: 2.h,
                                      child: SvgPicture.asset(
                                        index == 0 ? iconPinStart : iconPinEnd,
                                        width: index == 0 ? 2.h : 1.5.h,
                                      ),
                                    ) : Container(
                                      height: 2.5.h,
                                      child: VerticalDivider(
                                            color: Color(0xFFC7CEDF),
                                            thickness: 2,
                                            width: 2.h,
                                      ),
                                    ),
                                    index == allLocation.length - 1 ? Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: SizedBox(
                                        width: 2.h,
                                        child: SvgPicture.asset(
                                          iconPinEnd,
                                          width: 1.5.h,
                                      )),
                                    ) : Container()
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 8.h,),
                      ],
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

  _buildNewTextFormat(textList, isExpand) {
    return TextSpan(
      style: const TextStyle(
          height: 1.5
      ),
      children: [
        TextSpan(text: isExpand ? textList[0] : textList[0].replaceAll('\n', ' '), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, fontFamily: 'inter',color: Colors.black)),
        for(int i = 1; i < textList.length; i++)
          !(i % 2 == 0) ? TextSpan(text: isExpand ? textList[i] : textList[i].replaceAll('\n', ' '), style: TextStyle(fontSize: 14.sp, fontFamily: 'inter',color: Color(0xFF666666), fontWeight: FontWeight.w500)) :
          TextSpan(text: isExpand ? textList[i] : textList[i].replaceAll('\n', ' '), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, fontFamily: 'inter',color: Color(0xFF44464D))),


      ],
    );
  }

}

