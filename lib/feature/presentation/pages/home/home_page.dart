import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/core/constants/colors.dart';

import '../../../../core/constants/images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ScrollController _scrollController = ScrollController();
  double _opacity = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      print(_scrollController.offset);
      print(5.h);
      print(_scrollController.offset / 5.h);

      if (_scrollController.offset < 5.h){
        setState(() {
          _opacity = 1-( _scrollController.offset / 5.h) ;
        });
      }else{
        setState(() {
          _opacity = 0;
        });
      }

      // print(_scrollController.offset);
      // print(2.h);
      //
      // if (_scrollController.offset >= 2.h){
      //   setState(() {
      //     _isScrollToTop = 1;
      //   });
      // }else {
      //   setState(() {
      //     _isScrollToTop = _scrollController.offset;
      //   });
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
            opacity: 0.8,
            child: Image.asset(homeGradient)),
        _buildDailyJourney(),
        _buildHomeMenu()
      ],
    );
  }

  _buildDailyJourney(){
    return Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(height: 20.h,),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: 65.h,
                    minWidth: 100.w
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(48),topRight: Radius.circular(48))
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Daily Journey",style: TextStyle(fontFamily: 'poppins',fontSize: 16.sp,fontWeight: FontWeight.w600),),

                      ]
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
  _buildHomeMenu(){
    return SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 20,left: 24,right: 24),
          height: 28.h,
          child: Column(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 100),
                child: Row(
                  children: [
                    Text("Alexander P.",style: TextStyle(color: Colors.white,fontFamily: 'Poppins',fontSize: 18.sp, fontWeight: FontWeight.bold),),
                    Spacer(),
                    CircleAvatar(radius: 18.sp,backgroundImage: CachedNetworkImageProvider('https://www.georgetown.edu/wp-content/uploads/2022/02/Jkramerheadshot-scaled-e1645036825432-1050x1050-c-default.jpg') ,)
                  ],
                ),
              ),
              SizedBox(height: 5.h * _opacity,),
              _opacity==0? Container() : AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(milliseconds: 100),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          print('sdsaidjsaodsjaidasojadsiodj');
                        },
                        child: Container(
                          height: 13.h,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.16),
                              borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                  bottom: 16,
                                  right: 16,
                                  child: Image.asset(menuSummarize,scale: 0.9,)),
                              Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text("Video \nSummary",style: TextStyle(color: homeTitle,fontFamily: 'poppins' ,fontWeight: FontWeight.w600, fontSize: 16.sp),))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w,),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          print('sdsaidjsaodsjaidasojadsiodj');
                        },
                        child: Container(
                          height: 13.h,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.16),
                              borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                  bottom: 16,
                                  right: 16,
                                  child: Image.asset(menuTripGen,scale: 0.9,)),
                              Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text("Trip \nGenerator",style: TextStyle(color: homeTitle,fontFamily: 'poppins' ,fontWeight: FontWeight.w600, fontSize: 16.sp),))
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
}
