import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/api/album.dart';

import '../../common/utils/screenadaptor.dart';
import 'logic.dart';

class AlbumPage extends StatelessWidget {
  AlbumPage({Key? key}) : super(key: key);

  final logic = Get.put(AlbumLogic());
  final state = Get.find<AlbumLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.initPage(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
              screenAdaptor.getLengthByOrientation(24.h, 105.h),
              0,
              screenAdaptor.getLengthByOrientation(24.h, 115.h),
              0,
            ),
            child: CustomScrollView(
              anchor: screenAdaptor.getLengthByOrientation(0.024.w, 0.05.w),
              slivers: [
                // 间距
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "专辑ID${state.id}\n此页面尚未开发呢！",
                      style: TextStyle(
                        fontSize: screenAdaptor.getLengthByOrientation(12.sp, 25.sp),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
