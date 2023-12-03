import 'package:cached_network_image/cached_network_image.dart';
import 'package:css_filter/css_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/utils/screenadaptor.dart';

class Cover extends StatelessWidget {
  const Cover(
      {Key? key,
      required this.width,
      required this.height,
      required this.imageUrl,
      this.id})
      : super(key: key);

  // 专辑id
  final int? id;
  final String imageUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          screenAdaptor.getLengthByOrientation(14.w, 8.w),
        ),
        child: CSSFilter.blur(
          value: 0.4,
          // child: Image.network(
          //   imageUrl,
          //   fit: BoxFit.cover,
          //   gaplessPlayback: true,
          // ),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
