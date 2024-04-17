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
import 'package:starlight/feature/presentation/manager/journey_summary/journet_summary_bloc.dart';
import 'package:starlight/feature/presentation/manager/journey_summary/journet_summary_event.dart';
import 'package:starlight/feature/presentation/pages/summary/summary_page.dart';
import 'package:starlight/feature/presentation/pages/trip/trip_page.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/constants/images.dart';
import '../../manager/navigation_controller.dart';

class JourneyListPage extends StatefulWidget {
  const JourneyListPage({super.key});

  @override
  State<JourneyListPage> createState() => _JourneyListPageState();
}

class _JourneyListPageState extends State<JourneyListPage> {
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
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 2.h),
                          shrinkWrap: true,
                          itemCount: 8,
                            itemBuilder: (context,index){
                          return Padding(
                            padding: EdgeInsets.only(bottom: 1.5.h),
                            child: GestureDetector(
                              onTap: (){

                                bloc.BlocProvider.of<JourneySummaryBloc>(context).add(GetSummaryVideo(id: '514436d358b0436e973c7fdf6d2912e7'));
                                
                                Get.to(
                                  transition: Transition.rightToLeft,
                                    () => SummaryPage()
                                );
                              },
                              child: Container(height: 8.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(48),),
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
                                    SizedBox(width: 1.w,),

                                    Expanded(
                                      child: CircleAvatar(
                                        radius: 20.sp,
                                      ),
                                    ),

                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("The Endless Adventure",maxLines: 1,style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, fontFamily: 'inter'),),
                                          SizedBox(height: .2.h,),
                                          Text("This is SINGAPORE!? - Our Top LOC..asdasdas.",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color: Color(0xFF201E38).withOpacity(0.6),fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: 'inter')),
                                        ],
                                      ),
                                    ),
                                    Expanded(child: Icon(EvaIcons.checkmark, size: 24.sp,color: Color(0xFF009421),))
                                  ],
                                ),
                                ),
                            ),
                          );
                        }),
                      )
                    ],
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
        padding: EdgeInsets.only(top: 20, left: 2.5.h, right: 2.5.h),
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
    );
  }

}
