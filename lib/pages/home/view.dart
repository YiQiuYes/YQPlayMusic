import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/api/track.dart';
import 'package:yqplaymusic/common/utils/screenadaptor.dart';
import 'package:yqplaymusic/components/DailyTrackScard.dart';
import 'package:yqplaymusic/components/FMCard.dart';
import '../../common/utils/staticdata.dart';
import '../../components/CoverRow.dart';
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
          child: CustomScrollView(
            anchor: 0.06,
            slivers: [
              // by Apple Music文本
              SliverToBoxAdapter(
                child: _getText("by Apple Music"),
              ),
              // by Apple Music专辑
              _getAlbumByAppleMusic(),
              // 推荐歌单文本
              SliverToBoxAdapter(
                child: _getText("推荐歌单"),
              ),
              // 推荐歌单专辑
              _getRecommendPlaylist(),
              // For You文本
              SliverToBoxAdapter(
                child: _getText("For You"),
              ),
              // 每日推荐 和 私人FM
              _getForYouWidgets(),
              // 间距
              SliverToBoxAdapter(
                child: SizedBox(
                  height: screenAdaptor.getLengthByOrientation(44.h, 70.h),
                ),
              ),
              // 推荐艺人
              SliverToBoxAdapter(
                child: _getText("推荐艺人"),
              ),
              // 推荐艺人列表
              _getRecommendArtist(),
              // 新专速递
              SliverToBoxAdapter(
                child: _getText("新专速递"),
              ),
              // 新专列表
              _getNewAlbums(),
              // 排行榜
              SliverToBoxAdapter(
                child: _getText("排行榜"),
              ),
              // 排行榜列表
              _getTopList(),
              // 安全距离
              SliverToBoxAdapter(
                child: SizedBox(
                  height: screenAdaptor.getLengthByOrientation(44.h, 150.h),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 获取文本组件
  Widget _getText(String text) {
    return Container(
      margin: EdgeInsets.only(
        top: screenAdaptor.getLengthByOrientation(15.h, 25.h),
        bottom: screenAdaptor.getLengthByOrientation(15.h, 25.h),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: screenAdaptor.getLengthByOrientation(24.sp, 15.sp),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 获取byAppleMusic专辑
  Widget _getAlbumByAppleMusic() {
    List<Map<String, dynamic>> verticalData =
        byAppleMusicStaticData.sublist(0, byAppleMusicStaticData.length - 1);
    return CoverRow(
      items: screenAdaptor.getOrientation()
          ? verticalData
          : byAppleMusicStaticData,
      subText: "appleMusic",
      type: "playlist",
      columnCount: screenAdaptor.getOrientation() ? 4 : 5,
    );
  }

  // 获取推荐歌单专辑
  Widget _getRecommendPlaylist() {
    return Obx(
      () => FutureBuilder(
        future: state.recommendList.value,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data.length != 0) {
            List<dynamic> netWorkData = snapshot.data.sublist(0, 10);
            return CoverRow(
              items: screenAdaptor.getOrientation()
                  ? netWorkData.sublist(0, 8)
                  : netWorkData,
              subText: "copywriter",
              type: "playlist",
              columnCount: screenAdaptor.getOrientation() ? 4 : 5,
            );
          }
          return const SliverToBoxAdapter(child: SizedBox());
        },
      ),
    );
  }

  // 获取For You组件
  Widget _getForYouWidgets() {
    List<Widget> rowWidgets = [
      // For You 每日推荐
      Obx(
        () {
          return FutureBuilder(
            future: state.dailyTracksList.value,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
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
              return SizedBox();
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
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data.length != 0) {
                return FMCard(
                  width: 550,
                  height: 250,
                  items: snapshot.data,
                );
              }
              return SizedBox();
            },
          );
        },
      ),
    ];

    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowWidgets,
        ),
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: rowWidgets,
      ),
    );
  }

  // 获取推荐艺人列表
  Widget _getRecommendArtist() {
    return Obx(() {
      return FutureBuilder(
        future: state.recommendArtistList.value,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data.length != 0) {
            List<dynamic> netWorkData = snapshot.data.sublist(0, 6);
            return CoverRow(
              items: screenAdaptor.getOrientation()
                  ? netWorkData.sublist(0, 5)
                  : netWorkData,
              type: "artist",
              columnCount: screenAdaptor.getOrientation() ? 5 : 6,
            );
          }
          return const SliverToBoxAdapter(child: SizedBox());
        },
      );
    });
  }

  // 获取新专列表
  Widget _getNewAlbums() {
    return Obx(
      () => FutureBuilder(
        future: state.newAlbumsList.value,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data.length != 0) {
            List<dynamic> netWorkData = snapshot.data.sublist(0, 10);
            return CoverRow(
              items: screenAdaptor.getOrientation()
                  ? netWorkData.sublist(0, 8)
                  : netWorkData,
              subText: "artist",
              type: "album",
              columnCount: screenAdaptor.getOrientation() ? 4 : 5,
            );
          }
          return const SliverToBoxAdapter(child: SizedBox());
        },
      ),
    );
  }

  // 获取排行榜列表
  Widget _getTopList() {
    return Obx(() {
      return FutureBuilder(
        future: state.topList.value,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data.length != 0) {
            List<dynamic> netWorkData = snapshot.data;
            return CoverRow(
              items: screenAdaptor.getOrientation()
                  ? netWorkData.sublist(0, 4)
                  : netWorkData,
              type: "playlist",
              subText: "updateFrequency",
              columnCount: screenAdaptor.getOrientation() ? 4 : 5,
            );
          }
          return const SliverToBoxAdapter(child: SizedBox());
        },
      );
    });
  }
}
