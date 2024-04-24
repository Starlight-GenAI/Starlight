import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:starlight/feature/presentation/pages/login/login_page.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/images.dart';
import '../../manager/navigation_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, dynamic>> details = [
    {'title': 'Email', 'value': Get.find<NavigationController>().name.value, 'icon': FaIcon(FontAwesomeIcons.envelope, size: 16.sp, color: const Color(0xFF646C9C))},
    {'title': "Joined", 'value': '16 March 2024', 'icon': FaIcon(FontAwesomeIcons.calendar, size: 16.sp, color: const Color(0xFF646C9C))},
    {'title': "Location", 'value': 'Thailand 🇹🇭', 'icon': FaIcon(FontAwesomeIcons.locationDot, size: 16.sp, color: const Color(0xFF646C9C))}
  ];
  List<String>  placeImgList = [
    'https://upload.wikimedia.org/wikipedia/commons/3/3c/Vue_de_nuit_de_la_Place_Stanislas_à_Nancy.jpg',
    'https://www.themaplecake.com/images/content/original-1631012354879.jpg',
    'https://images.nationalgeographic.org/image/upload/t_edhub_resource_key_image/v1652341395/EducationHub/photos/sonoran-desert.jpg',
    'https://a.cdn-hotels.com/gdcs/production50/d1634/bbe337ad-02fe-49d6-b761-02cab15d54f9.jpg?impolicy=fcrop&w=800&h=533&q=medium'
  ];
  final BoxDecoration boxStyle = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    boxShadow: [
      BoxShadow(
          color: shadowColor.withOpacity(0.3),
          offset: Offset(0,6),
          blurRadius: 30
      )
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF15104F),
      body: Stack(
        children: [
          Opacity(opacity: 1, child: Image.asset(homeGradient)),
          _buildHeader(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 68.h,
                  width: 100.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9FBFE),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 120, left: 2.5.h, right: 2.5.h),
                    child: Column(
                      children: [
                        Container(
                          decoration: boxStyle,
                          child: Padding(
                            padding: EdgeInsets.all(6.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Information",
                                  style: TextStyle(
                                      color: Color(0xFF15104F),
                                      fontFamily: 'Inter',
                                      fontSize: 16.5.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.17
                                  ),
                                ),
                                SizedBox(height: 2.5.w,),
                                Column(
                                  children: details.map((data) => InformationRow(data: data)).toList(),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 5.w,),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.w),
                                decoration: boxStyle,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        FaIcon(FontAwesomeIcons.earthEurope, size: 16.sp, color: const Color(0xFF15104F)),
                                        SizedBox(width: 2.w,),
                                        Text(
                                          "All Journey",
                                          style: TextStyle(
                                              color: Color(0xFF15104F),
                                              fontFamily: 'Inter',
                                              fontSize: 16.5.sp,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: -0.17
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2.w,),
                                    Text(
                                      "15",
                                      style: TextStyle(
                                          color: Color(0xFF15104F),
                                          fontFamily: 'Inter',
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.bold,
                                        height: 1
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 5.w,),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.w),
                                  decoration: boxStyle,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "All Place",
                                            style: TextStyle(
                                                color: Color(0xFF15104F),
                                                fontFamily: 'Inter',
                                                fontSize: 16.5.sp,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: -0.17
                                            ),
                                          ),
                                          Spacer(),
                                          FaIcon(FontAwesomeIcons.angleRight, size: 16.sp, color: const Color(0xFF15104F))
                                        ],
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: placeImgList.map((data) => ImgStack(data: data)).toList(),
                                          ),
                                          SizedBox(width: 4.w,),
                                          Text(
                                            "+ 24",
                                            style: TextStyle(
                                                color: Color(0xFF9FA1AD),
                                                fontFamily: 'Inter',
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: -0.17
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -30,
                  left: (100.w - 120) / 2,
                  child: Container(
                    width: 120,
                    height:120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(1000000)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            Get.find<NavigationController>().profile.value ?? ""),
                      ),
                    ),
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildHeader() {
    return SafeArea(
      child: Container(
        width: 100.w,
        padding: EdgeInsets.only(top: 20, left: 2.5.h, right: 2.5.h),
        child: Obx(
              () => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Good Morning,",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontFamily: 'Inter',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 0.25.h,),
                  Text(
                    Get.find<NavigationController>().name.value,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Spacer(),
              FaIcon(FontAwesomeIcons.arrowRightFromBracket, size: 20.sp,
                  color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  _imgStack(data,index) {
    return Positioned(
      left: index * 10,
      child: Container(
        width: 3.w,
        height: 3.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100000)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(data),
          ),
        ),
      ),
    );
  }
}

class ImgStack extends StatelessWidget {
  final String data;
  const ImgStack({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Align(
      widthFactor: 0.5,
      child: Container(
        width: 8.w,
        height: 8.w,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100000)
        ),
        child: Padding(
          padding: EdgeInsets.all(0.8.w),
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(data),
          ),
        ),
      ),
    );
  }
}

class InformationRow extends StatelessWidget {
  final Map<String, dynamic> data;

  const InformationRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.25.w),
      child: Row(
        children: [
          Container(
            width: 16.sp,
            child: Center(
              child: data['icon'],
            )
          ),
          SizedBox(width: 2.5.w),
          Text(
            data['title'],
            style: TextStyle(
                color: Color(0xFF646C9C),
                fontFamily: 'Inter',
                fontSize: 15.sp,
                fontWeight: FontWeight.w600),
          ),
          Spacer(),
          Text(
            data['value'],
            style: TextStyle(
                color: Color(0xFF15104F),
                fontFamily: 'Inter',
                fontSize: 15.sp,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
