import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/components/MvRow.dart';
import 'package:yqplaymusic/components/TrackList.dart';

import '../../common/utils/screenadaptor.dart';
import '../../components/CoverRow.dart';
import 'logic.dart';
import 'dart:developer' as developer;

class MusicLibraryPage extends StatefulWidget {
  const MusicLibraryPage({super.key});

  @override
  State<MusicLibraryPage> createState() => MusicLibraryPageState();
}

class MusicLibraryPageState extends State<MusicLibraryPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final logic = Get.put(MusicLibraryLogic());
  final state = Get.find<MusicLibraryLogic>().state;

  @override
  void initState() {
    logic.pageInit();
    super.initState();
  }

  @override
  void dispose() {
    state.pageController.dispose();
    super.dispose();
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
        child: RefreshIndicator(
          edgeOffset: screenAdaptor.getLengthByOrientation(50.h, 70.h),
          onRefresh: logic.refreshData,
          child: Listener(
            child: CustomScrollView(
              anchor: 0.08,
              controller: state.pageController,
              slivers: [
                // 音乐库标题
                _getMusicTitleBar(),
                // 间距
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: screenAdaptor.getLengthByOrientation(50.h, 30.h),
                  ),
                ),
                // 音乐库内容
                _getMusicLibraryContent(),
                // 间距
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: screenAdaptor.getLengthByOrientation(70.w, 50.w),
                  ),
                ),
                // TabBar导航栏
                _getTabBar(),
                // 间距
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: screenAdaptor.getLengthByOrientation(20.h, 40.h),
                  ),
                ),
                // 是否显示听歌排行中的子项选择标签
                _getIsShowHistoryRankTitle(),
                // TabBarView页面
                Obx(() => _getTabBarPage()),
                // 间距
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: screenAdaptor.getLengthByOrientation(40.h, 150.h),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 获取音乐库标题
  Widget _getMusicTitleBar() {
    return Obx(() {
      return SliverToBoxAdapter(
        child: Row(
          children: [
            // 用户头像
            Visibility(
              visible: state.userImgUrl.value != "",
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: state.userImgUrl.value,
                  width: screenAdaptor.getLengthByOrientation(35.h, 70.h),
                  height: screenAdaptor.getLengthByOrientation(35.h, 70.h),
                ),
              ),
            ),
            // 间距
            SizedBox(
              width: screenAdaptor.getLengthByOrientation(20.h, 30.h),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                top: screenAdaptor.getLengthByOrientation(20.h, 30.h),
                bottom: screenAdaptor.getLengthByOrientation(20.h, 30.h),
              ),
              child: Text(
                state.userInfo["nickname"] != null
                    ? "${state.userInfo["nickname"]}的音乐库"
                    : "",
                style: TextStyle(
                  fontSize: screenAdaptor.getLengthByOrientation(30.sp, 28.sp),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // 获取音乐库内容
  Widget _getMusicLibraryContent() {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        // 组件从左开始
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // 我喜欢的音乐随机歌词显示
            ClipRRect(
              borderRadius: BorderRadius.circular(
                screenAdaptor.getLengthByOrientation(10.h, 25.h),
              ),
              child: Container(
                width: screenAdaptor.getLengthByOrientation(350.h, 550.h),
                height: screenAdaptor.getLengthByOrientation(250.h, 400.h),
                color: const Color.fromRGBO(232, 237, 253, 1.0),
                child: Stack(
                  children: [
                    // 歌词部分
                    Positioned(
                      top: screenAdaptor.getLengthByOrientation(20.h, 35.h),
                      left: screenAdaptor.getLengthByOrientation(20.h, 35.h),
                      child: SizedBox(
                        width:
                            screenAdaptor.getLengthByOrientation(310.h, 480.h),
                        child: Obx(() {
                          return Text(
                            state.randomLyric.value,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: TextStyle(
                              fontSize: screenAdaptor.getLengthByOrientation(
                                  16.sp, 10.sp),
                              color: const Color.fromRGBO(51, 94, 235, 0.9),
                            ),
                          );
                        }),
                      ),
                    ),
                    // 我喜欢的音乐
                    Positioned(
                      bottom: screenAdaptor.getLengthByOrientation(50.h, 90.h),
                      left: screenAdaptor.getLengthByOrientation(20.h, 35.h),
                      child: Text(
                        "我喜欢的音乐",
                        style: TextStyle(
                          fontSize: screenAdaptor.getLengthByOrientation(
                              27.sp, 16.sp),
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(51, 94, 235, 1.0),
                        ),
                      ),
                    ),
                    // 歌曲的数量
                    Positioned(
                      bottom: screenAdaptor.getLengthByOrientation(20.h, 45.h),
                      left: screenAdaptor.getLengthByOrientation(20.h, 35.h),
                      child: Obx(() {
                        return Text(
                          "${state.likeSongs.length}首歌",
                          style: TextStyle(
                            fontSize: screenAdaptor.getLengthByOrientation(
                                16.sp, 10.sp),
                            color: const Color.fromRGBO(51, 94, 235, 1.0),
                          ),
                        );
                      }),
                    ),
                    // 播放按钮
                    Positioned(
                      bottom: screenAdaptor.getLengthByOrientation(20.h, 35.h),
                      right: screenAdaptor.getLengthByOrientation(20.h, 35.h),
                      child: ClipOval(
                        child: Container(
                          width:
                              screenAdaptor.getLengthByOrientation(55.h, 90.h),
                          height:
                              screenAdaptor.getLengthByOrientation(55.h, 90.h),
                          color: const Color.fromRGBO(51, 94, 235, 1.0),
                          child: IconButton(
                            onPressed: () {},
                            padding: EdgeInsets.fromLTRB(
                              screenAdaptor.getLengthByOrientation(20.h, 33.h),
                              screenAdaptor.getLengthByOrientation(18.h, 30.h),
                              screenAdaptor.getLengthByOrientation(16.h, 27.h),
                              screenAdaptor.getLengthByOrientation(18.h, 30.h),
                            ),
                            icon: SvgPicture.asset(
                              "lib/assets/icons/play.svg",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 间距
            SizedBox(
              width: screenAdaptor.getLengthByOrientation(20.h, 50.h),
            ),
            // 我喜欢的音乐列表显示
            Obx(() {
              return Visibility(
                visible: state.likeSongs.isNotEmpty,
                replacement: SizedBox(
                    width: screenAdaptor.getLengthByOrientation(600.h, 905.h)),
                child: SizedBox(
                  width: screenAdaptor.getLengthByOrientation(600.h, 905.h),
                  height: screenAdaptor.getLengthByOrientation(250.h, 400.h),
                  child: TrackList(
                    type: "tracklist",
                    tracks: state.likeSongs.value,
                    columnCount: 3,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // 获取新建歌单和上传歌曲
  Widget _getNewPlayListAndUploadSong(
      {required String svgPath, required String title}) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: screenAdaptor.getLengthByOrientation(15.sp, 10.sp),
          color: const Color.fromRGBO(34, 34, 34, 0.56),
        ),
        children: [
          WidgetSpan(
            child: Container(
              width: screenAdaptor.getLengthByOrientation(30.w, 20.w),
              padding: EdgeInsets.only(
                left: screenAdaptor.getLengthByOrientation(5.w, 5.w),
                right: screenAdaptor.getLengthByOrientation(5.w, 5.w),
                top: screenAdaptor.getLengthByOrientation(5.w, 3.w),
                bottom: screenAdaptor.getLengthByOrientation(5.w, 3.w),
              ),
              child: SvgPicture.asset(
                svgPath,
                width: screenAdaptor.getLengthByOrientation(13.h, 24.h),
                height: screenAdaptor.getLengthByOrientation(13.h, 24.h),
                fit: BoxFit.contain,
                color: const Color.fromRGBO(34, 34, 34, 0.56),
              ),
            ),
          ),
          TextSpan(text: title),
        ],
      ),
    );
  }

  // 根据当前index选择返回新建歌单还是上传歌曲
  Widget _getNewPlayListOrUploadSong(int index) {
    switch (index) {
      case 0:
        return _getNewPlayListAndUploadSong(
          svgPath: "lib/assets/icons/plus.svg",
          title: "新建歌单",
        );
      case 4:
        return _getNewPlayListAndUploadSong(
          svgPath: "lib/assets/icons/arrow-up-alt.svg",
          title: "上传歌曲",
        );
      default:
        return const SizedBox();
    }
  }

  // 获取TabBar导航栏
  Widget _getTabBar() {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            direction: Axis.horizontal,
            spacing: screenAdaptor.getLengthByOrientation(5.h, 30.h),
            children: logic.getTabBarTitleText(),
          ),
          // +新建歌单 和 上传歌曲
          Obx(() {
            return _getNewPlayListOrUploadSong(state.currentTabBarIndex.value);
          }),
        ],
      ),
    );
  }

  // 获取ListView
  Widget _getListViewBuilder(List items,
      {required String subText, required String type, int? columnCount}) {
    return CoverRow(
      items: items,
      subText: subText,
      type: type,
      columnCount: screenAdaptor.getOrientation() ? 4 : 5,
    );
  }

  // 是否显示听歌排行中的子项选择标签
  Widget _getIsShowHistoryRankTitle() {
    return Obx(() {
      return Visibility(
        visible: state.currentTabBarIndex.value == 5,
        replacement: const SliverToBoxAdapter(child: SizedBox()),
        child: SliverToBoxAdapter(
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      screenAdaptor.getLengthByOrientation(8.w, 5.w),
                    ),
                    child: InkWell(
                      onTap: () {
                        state.currentUserHistorySongsRank.value = 0;
                        state.userHistorySongsRank.clear();
                        logic.loadUserHistoryRank(type: 1);
                      },
                      borderRadius: BorderRadius.circular(
                        screenAdaptor.getLengthByOrientation(8.w, 5.w),
                      ),
                      child: Container(
                        color: state.currentUserHistorySongsRank.value == 0
                            ? const Color.fromRGBO(244, 244, 246, 1.0)
                            : Colors.transparent,
                        padding: EdgeInsets.fromLTRB(
                          screenAdaptor.getLengthByOrientation(12.w, 8.w),
                          screenAdaptor.getLengthByOrientation(5.w, 3.w),
                          screenAdaptor.getLengthByOrientation(12.w, 8.w),
                          screenAdaptor.getLengthByOrientation(5.w, 3.w),
                        ),
                        child: Text(
                          "最近一周",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                screenAdaptor.getLengthByOrientation(13.sp, 10.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 间距
                  SizedBox(
                    width: screenAdaptor.getLengthByOrientation(5.w, 8.w),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      screenAdaptor.getLengthByOrientation(8.w, 5.w),
                    ),
                    child: InkWell(
                      onTap: () {
                        state.currentUserHistorySongsRank.value = 1;
                        state.userHistorySongsRank.clear();
                        logic.loadUserHistoryRank(type: 0);
                      },
                      borderRadius: BorderRadius.circular(
                        screenAdaptor.getLengthByOrientation(8.w, 5.w),
                      ),
                      child: Container(
                        color: state.currentUserHistorySongsRank.value == 1
                            ? const Color.fromRGBO(244, 244, 246, 1.0)
                            : Colors.transparent,
                        padding: EdgeInsets.fromLTRB(
                          screenAdaptor.getLengthByOrientation(12.w, 8.w),
                          screenAdaptor.getLengthByOrientation(5.w, 3.w),
                          screenAdaptor.getLengthByOrientation(12.w, 8.w),
                          screenAdaptor.getLengthByOrientation(5.w, 3.w),
                        ),
                        child: Text(
                          "所有时间",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                screenAdaptor.getLengthByOrientation(13.sp, 10.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // 间距
              SizedBox(
                height: screenAdaptor.getLengthByOrientation(22.w, 12.w),
              )
            ],
          ),
        ),
      );
    });
  }

  // 获取TabBar页面
  Widget _getTabBarPage() {
    switch (state.currentTabBarIndex.value) {
      // 全部歌单页面
      case 0:
        if (state.userPlayList.isNotEmpty) {
          return _getListViewBuilder(state.userPlayList,
              subText: "creator", type: "playlist");
        } else {
          return const SliverToBoxAdapter(child: SizedBox());
        }
      // 专辑页面
      case 1:
        if (state.userLikedAlbums.isNotEmpty) {
          return _getListViewBuilder(state.userLikedAlbums,
              subText: "artist", type: "album");
        } else {
          return const SliverToBoxAdapter(child: SizedBox());
        }
      // 艺人页面
      case 2:
        if (state.userLikedArtists.isNotEmpty) {
          return _getListViewBuilder(state.userLikedArtists,
              subText: "", type: "artist", columnCount: 5);
        } else {
          return const SliverToBoxAdapter(child: SizedBox());
        }
      // MV页面
      case 3:
        if (state.userLikedMVs.isNotEmpty) {
          return MvRow(
            columnCount: screenAdaptor.getOrientation() ? 4 : 5,
            items: state.userLikedMVs,
          );
        } else {
          return const SliverToBoxAdapter(child: SizedBox());
        }
      // 云盘页面
      case 4:
        if (state.userCloudDiskSongs.isNotEmpty) {
          return TrackList(
            tracks: state.userCloudDiskSongs,
            type: "sliverCloudDisk",
            columnCount: 1,
            isShowSongAlbumNameAndTimes: true,
          );
        } else {
          return const SliverToBoxAdapter(child: SizedBox());
        }
      // 听歌排行页面
      case 5:
        if (state.userHistorySongsRank.isNotEmpty) {
          return TrackList(
            tracks: state.userHistorySongsRank,
            type: "sliverTrackList",
            columnCount: 1,
          );
        } else {
          return const SliverToBoxAdapter(child: SizedBox());
        }
      default:
        return const SliverToBoxAdapter(child: SizedBox());
    }
  }

  @override
  bool get wantKeepAlive => true;
}
