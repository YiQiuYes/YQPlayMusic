import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/utils/screenadaptor.dart';
import '../../components/CoverRow.dart';
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

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    state.futurePlayLists = logic.loadPlayList().obs;
    super.initState();
  }

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
        child: CustomScrollView(
          anchor: 0.06,
          slivers: [
            // 发现文本
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  top: screenAdaptor.getLengthByOrientation(20.h, 30.h),
                  bottom: screenAdaptor.getLengthByOrientation(20.h, 30.h),
                ),
                child: Text(
                  '发现',
                  style: TextStyle(
                    fontSize:
                        screenAdaptor.getLengthByOrientation(45.sp, 36.sp),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // 间距
            SliverToBoxAdapter(
              child: SizedBox(
                height: screenAdaptor.getLengthByOrientation(20.h, 30.h),
              ),
            ),
            // 分类
            SliverToBoxAdapter(child: logic.getEnableCategories()),
            // 间距
            SliverToBoxAdapter(
              child: SizedBox(
                height: screenAdaptor.getLengthByOrientation(20.h, 30.h),
              ),
            ),
            // 分类面板
            SliverToBoxAdapter(child: logic.getEnableCategoriesPanel()),
            // 获取专辑列表
            _getPlayListWidget(),
          ],
        ),
      ),
    );
  }

  // 获取专辑组件
  Widget _getPlayListWidget() {
    return Obx(
      () => FutureBuilder(
        future: state.futurePlayLists.value,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data.isNotEmpty) {
            List<Widget> widgets = [];
            if (state.isLoadNewData) {
              state.playListsData.addAll(snapshot.data);
            }
            state.isLoadNewData = false;

            return CoverRow(
              items: state.playListsData,
              subText: logic.getSubText(),
              type: "playlist",
              showPlayCount: true,
              columnCount: screenAdaptor.getOrientation() ? 4 : 5,
            );
          }

          return const SliverToBoxAdapter(child: SizedBox());
        },
      ),
    );
  }
}
