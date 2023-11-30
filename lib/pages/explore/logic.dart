
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/common/utils/staticdata.dart';
import 'package:flutter/material.dart';

import '../../common/utils/screenadaptor.dart';
import 'state.dart';

class ExploreLogic extends GetxController {
  final ExploreState state = ExploreState();

  // 获取页面选择表
  Widget getEnableCategories() {
    List<Widget> listCategories = state.playlistCategories.map((e) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
                screenAdaptor.getLengthByOrientation(10.h, 15.h)),
            child: Container(
              padding: EdgeInsets.only(
                  top: screenAdaptor.getLengthByOrientation(8.h, 10.h),
                  bottom: screenAdaptor.getLengthByOrientation(8.h, 10.h),
                  left: screenAdaptor.getLengthByOrientation(16.h, 25.h),
                  right: screenAdaptor.getLengthByOrientation(16.h, 25.h)),
              color: const Color.fromRGBO(244, 244, 246, 1.0),
              child: Text(
                e["name"],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenAdaptor.getLengthByOrientation(15.sp, 12.sp),
                  color: const Color.fromRGBO(122, 122, 122, 1.0),
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();

    // 添加更多
    listCategories.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
                screenAdaptor.getLengthByOrientation(10.h, 15.h)),
            child: Container(
              padding: EdgeInsets.only(
                  top: screenAdaptor.getLengthByOrientation(8.h, 10.h),
                  bottom: screenAdaptor.getLengthByOrientation(8.h, 10.h),
                  left: screenAdaptor.getLengthByOrientation(16.h, 25.h),
                  right: screenAdaptor.getLengthByOrientation(16.h, 25.h)),
              color: const Color.fromRGBO(244, 244, 246, 1.0),
              child: SvgPicture.asset(
                "lib/assets/icons/more.svg",
                color: const Color.fromRGBO(122, 122, 122, 1.0),
                width: screenAdaptor.getLengthByOrientation(22.h, 40.h),
              ),
            ),
          ),
        ],
      ),
    );

    return Obx(() {
      return Wrap(
        spacing: screenAdaptor.getLengthByOrientation(20.h, 30.h),
        runSpacing: screenAdaptor.getLengthByOrientation(20.h, 30.h),
        children: listCategories,
      );
    });
  }
}
