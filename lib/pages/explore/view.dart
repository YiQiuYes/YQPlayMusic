import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/utils/screenadaptor.dart';
import 'logic.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.put(ExploreLogic());
  final state = Get.find<ExploreLogic>().state;

  Future<void> reflashData() async {}

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        screenAdaptor.getLengthByOrientation(24.h, 105.h),
        0,
        screenAdaptor.getLengthByOrientation(24.h, 115.h),
        0,
      ),
      child: SizedBox(
        // 占满屏幕
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        child: RefreshIndicator(
          edgeOffset: screenAdaptor.getLengthByOrientation(50.h, 70.h),
          onRefresh: reflashData,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 占位
                SizedBox(
                  height: screenAdaptor.getLengthByOrientation(50.h, 80.h),
                ),
                // 发现文本
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                    top: screenAdaptor.getLengthByOrientation(20.h, 30.h),
                    bottom: screenAdaptor.getLengthByOrientation(20.h, 30.h),
                  ),
                  child: Text(
                    '发现',
                    style: TextStyle(
                      fontSize: screenAdaptor.getLengthByOrientation(45.sp, 36.sp),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 间距
                SizedBox(
                  height: screenAdaptor.getLengthByOrientation(20.h, 30.h),
                ),
                // 分类
                logic.getEnableCategories(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
