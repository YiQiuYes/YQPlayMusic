
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/common/utils/screenadaptor.dart';
import 'package:yqplaymusic/components/DailyTrackScard.dart';
import 'package:yqplaymusic/components/FMCard.dart';
import 'logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.put(HomeLogic());
  final state = Get.find<HomeLogic>().state;

  @override
  void initState() {
    super.initState();
    // 初始化数据
    state.recommendList = logic.getRecommendByLoginStatus().obs;
    state.dailyTracksList = logic.loadDailyTracksSongs().obs;
    state.personalFMList = logic.loadPersonalFM().obs;
    state.recommendArtistList = logic.loadRecommendArtist().obs;
    state.newAlbumsList = logic.loadNewAlbums().obs;
    state.topList = logic.loadTopList().obs;
  }

  @override
  void dispose() {
    super.dispose();
  }

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
          onRefresh: logic.refreshData,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 占位
                SizedBox(
                  height: screenAdaptor.getLengthByOrientation(44.h, 70.h),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: screenAdaptor.getLengthByOrientation(15.h, 25.h),
                    bottom: screenAdaptor.getLengthByOrientation(15.h, 25.h),
                  ),
                  child: Text(
                    "by Apple Music",
                    style: TextStyle(
                      fontSize:
                          screenAdaptor.getLengthByOrientation(24.sp, 15.sp),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // by Apple Music专辑
                logic.getAlbumByAppleMusic(),
                // 推荐歌单文本
                Container(
                  margin: EdgeInsets.only(
                    top: screenAdaptor.getLengthByOrientation(45.h, 70.h),
                    bottom: screenAdaptor.getLengthByOrientation(15.h, 25.h),
                  ),
                  child: Text(
                    "推荐歌单",
                    style: TextStyle(
                      fontSize:
                          screenAdaptor.getLengthByOrientation(24.sp, 15.sp),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 推荐歌单专辑
                logic.getRecommendPlaylist(),
                // For You文本
                Container(
                  margin: EdgeInsets.only(
                    top: screenAdaptor.getLengthByOrientation(45.h, 70.h),
                    bottom: screenAdaptor.getLengthByOrientation(15.h, 25.h),
                  ),
                  child: Text(
                    "For You",
                    style: TextStyle(
                      fontSize:
                          screenAdaptor.getLengthByOrientation(24.sp, 15.sp),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 私人FM
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // For You 每日推荐
                      Obx(
                        () {
                          return FutureBuilder(
                            future: state.dailyTracksList.value,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data.length != 0) {
                                return DailyTracksCard(
                                  width: 550,
                                  height: 250,
                                  dailyTracksList: snapshot.data,
                                  defaultTracksList: const [
                                    'https://p2.music.126.net/0-Ybpa8FrDfRgKYCTJD8Xg==/109951164796696795.jpg',
                                    'https://p2.music.126.net/QxJA2mr4hhb9DZyucIOIQw==/109951165422200291.jpg',
                                    'https://p1.music.126.net/AhYP9TET8l-VSGOpWAKZXw==/109951165134386387.jpg',
                                  ],
                                );
                              }
                              return const SizedBox();
                            },
                          );
                        },
                      ),
                      // 间隔
                      SizedBox(
                        width: screenAdaptor.getLengthByOrientation(40.w, 48.w),
                      ),
                      // For You 私人FM
                      Obx(
                        () {
                          return FutureBuilder(
                            future: state.personalFMList.value,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data.length != 0) {
                                return FMCard(
                                  width: 550,
                                  height: 250,
                                  items: snapshot.data,
                                );
                              }
                              return const SizedBox();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // 推荐艺人
                Container(
                  margin: EdgeInsets.only(
                    top: screenAdaptor.getLengthByOrientation(45.h, 70.h),
                    bottom: screenAdaptor.getLengthByOrientation(15.h, 25.h),
                  ),
                  child: Text(
                    "推荐艺人",
                    style: TextStyle(
                      fontSize:
                          screenAdaptor.getLengthByOrientation(24.sp, 15.sp),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 推荐艺人列表
                logic.getRecommendArtist(),
                // 新专速递
                Container(
                  margin: EdgeInsets.only(
                    top: screenAdaptor.getLengthByOrientation(45.h, 70.h),
                    bottom: screenAdaptor.getLengthByOrientation(15.h, 25.h),
                  ),
                  child: Text(
                    "新专速递",
                    style: TextStyle(
                      fontSize:
                          screenAdaptor.getLengthByOrientation(24.sp, 15.sp),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 新专列表
                logic.getNewAlbums(),
                // 排行榜
                Container(
                  margin: EdgeInsets.only(
                    top: screenAdaptor.getLengthByOrientation(45.h, 70.h),
                    bottom: screenAdaptor.getLengthByOrientation(15.h, 25.h),
                  ),
                  child: Text(
                    "排行榜",
                    style: TextStyle(
                      fontSize:
                          screenAdaptor.getLengthByOrientation(24.sp, 15.sp),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 排行榜列表
                logic.getTopList(),
                // 安全距离
                SizedBox(
                  height: screenAdaptor.getLengthByOrientation(44.h, 70.h),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
