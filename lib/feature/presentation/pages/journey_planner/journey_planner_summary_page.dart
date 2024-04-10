import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class JourneyPlannerSummaryPage extends StatefulWidget {
  const JourneyPlannerSummaryPage({super.key});

  @override
  State<JourneyPlannerSummaryPage> createState() => _JourneyPlannerSummaryPageState();
}

class _JourneyPlannerSummaryPageState extends State<JourneyPlannerSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: CachedNetworkImage(
            imageUrl: "https://res.klook.com/image/upload/fl_lossy.progressive,q_85/c_fill,w_680/v1677221922/blog/dmqjomlet9ohlws6lhoy.jpg",
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          'https://www.georgetown.edu/wp-content/uploads/2022/02/Jkramerheadshot-scaled-e1645036825432-1050x1050-c-default.jpg'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    "The Endless Adventure",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.17
                    ),
                  ),
                ],
              ),
              FaIcon(FontAwesomeIcons.youtube, size: 24.sp, color: const Color(0xFFFF0001)),
            ],
          ),
        ),
        Row(
          children: [
            Row(
              children: [
                FaIcon(FontAwesomeIcons.film, size: 18.sp, color: const Color(0xFF15104F)),
                SizedBox(width: 1.5.w),
                Text(
                  "Title",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.17
                  ),
                ),
              ],
            ),
            SizedBox(width: 5.w),
            Expanded(
              child: Text(
                "This is SINGAPORE!? - Our Top LOCAL Things to Do, See & Eat! 😍 The Ultimate Guide",
                style: TextStyle(
                    color: Color(0xFF25233A),
                    fontFamily: 'Inter',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.17
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
