import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;
import '../common/utils/screenadaptor.dart';

class TrackListItem extends StatelessWidget {
  const TrackListItem({super.key, required this.track});

  final Map track;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 图片
        Positioned(
          top: screenAdaptor.getLengthByOrientation(8.w, 5.w),
          left: screenAdaptor.getLengthByOrientation(8.w, 5.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(screenAdaptor.getLengthByOrientation(8.w, 5.w)),
            child: SizedBox(
              width: screenAdaptor.getLengthByOrientation(47.w, 30.w),
              height: screenAdaptor.getLengthByOrientation(47.w, 30.w),
              child: CachedNetworkImage(
                imageUrl: track["al"]["picUrl"] + "?param=100y100",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // 歌曲标题
        Positioned(
          top: screenAdaptor.getLengthByOrientation(8.w, 5.w),
          left: screenAdaptor.getLengthByOrientation(65.w, 45.w),
          child: SizedBox(
            width: screenAdaptor.getLengthByOrientation(130.w, 76.w),
            child: Text(
              track["name"] + (track["tns"] != null ? '（${track["tns"].join("").toString()}）' : ""),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: screenAdaptor.getLengthByOrientation(14.sp, 8.4.sp),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // 歌手
        Positioned(
          top: screenAdaptor.getLengthByOrientation(30.w, 18.w),
          left: screenAdaptor.getLengthByOrientation(65.w, 45.w),
          child: SizedBox(
            width: screenAdaptor.getLengthByOrientation(130.w, 75.w),
            child: Text(
              track["ar"].map((e) => e["name"]).join(", "),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: screenAdaptor.getLengthByOrientation(12.sp, 7.3.sp),
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
