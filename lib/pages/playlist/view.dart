import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/common/utils/EventBusDistribute.dart';
import 'package:yqplaymusic/common/utils/ShareData.dart';
import 'package:yqplaymusic/components/Cover.dart';
import 'package:yqplaymusic/components/TrackList.dart';

import '../../common/utils/SongInfoUtils.dart';
import '../../common/utils/screenadaptor.dart';
import 'logic.dart';
import 'dart:developer' as developer;

class PlayListPage extends StatelessWidget {
  PlayListPage({super.key});

  final logic = Get.put(PlaylistLogic());
  final state = Get.find<PlaylistLogic>().state;

  @override
  Widget build(BuildContext context) {
    // 初始化页面
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
              anchor: screenAdaptor.getLengthByOrientation(0.075.w, 0.05.w),
              slivers: [
                // 头部信息区域
                _getHeadInfoWidget(),
                // 间距
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: screenAdaptor.getLengthByOrientation(50.h, 70.h),
                  ),
                ),
                // 歌单列表区域
                _getPlayListSongsWidget(),
                // 底部安全距离
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: screenAdaptor.getLengthByOrientation(130.h, 180.h),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 获取歌单列表区域
  Widget _getPlayListSongsWidget() {
    return Obx(
      () {
        return FutureBuilder(
          future: state.futurePlayListInfo.value,
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data!.isNotEmpty) {
              List list = snapshot.data!["playlist"]["tracks"];

              return TrackList(
                type: "playlist",
                tracks: list,
                columnCount: 1,
                isShowSongAlbumNameAndTimes: true,
              );
            }
            return const SliverToBoxAdapter(child: SizedBox());
          },
        );
      },
    );
  }

  // 获取头步区域组件
  Widget _getHeadInfoWidget() {
    return SliverToBoxAdapter(
      child: Obx(() {
        return FutureBuilder(
          future: state.futurePlayListInfo.value,
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data!.isNotEmpty) {
              // 获取歌单图片组件和歌单信息
              return _getPlaylistImageAndInfoWidget(context, snapshot);
            }
            return const SizedBox();
          },
        );
      }),
    );
  }

  // 获取歌单图片组件和歌单信息
  Widget _getPlaylistImageAndInfoWidget(
      BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
    // developer.log(snapshot.data.toString());
    return SizedBox(
      height: screenAdaptor.getLengthByOrientation(300.h, 450.h),
      child: Row(
        children: [
          // 歌单图片
          _getPlaylistImage(snapshot),
          // 间距
          SizedBox(
            width: screenAdaptor.getLengthByOrientation(25.w, 35.w),
          ),
          // 歌单信息
          _getPlaylistInfoText(snapshot),
        ],
      ),
    );
  }

  // 获取歌单信息介绍组件
  Widget _getPlaylistInfoText(var snapshot) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 歌单名
            Text(
              snapshot.data!["playlist"]["name"],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: screenAdaptor.getLengthByOrientation(20.sp, 15.sp),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
                color: Colors.black,
                letterSpacing: 0,
                wordSpacing: 0,
              ),
            ),
            // 间距
            SizedBox(
              height: screenAdaptor.getLengthByOrientation(10.h, 15.h),
            ),
            // 歌单创建者
            Text.rich(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              TextSpan(
                  style: TextStyle(
                    fontSize:
                        screenAdaptor.getLengthByOrientation(18.sp, 12.sp),
                    letterSpacing: 0,
                    wordSpacing: 0,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(
                      text: "Playlist by ",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: logic.getPlaylistCreator(
                          state.id, snapshot.data as Map<String, dynamic>),
                      style: TextStyle(
                        fontWeight: logic.getPlaylistCreator(state.id,
                                    snapshot.data as Map<String, dynamic>) ==
                                "Apple Music"
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    )
                  ]),
            ),
            // 更新日期
            Text(
              logic.getDataTimeAndSongCount(
                  snapshot.data as Map<String, dynamic>),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: screenAdaptor.getLengthByOrientation(15.sp, 10.sp),
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
                color: Colors.black54,
                letterSpacing: 0,
                wordSpacing: 0,
              ),
            ),
            // 间距
            SizedBox(
              height: screenAdaptor.getLengthByOrientation(15.h, 25.h),
            ),
            // 文案
            Text(
              snapshot.data!["playlist"]["description"] ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: screenAdaptor.getOrientation() ? 4 : 3,
              style: TextStyle(
                fontSize: screenAdaptor.getLengthByOrientation(15.sp, 10.sp),
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
                color: Colors.black54,
                letterSpacing: 0,
                wordSpacing: 0,
              ),
            ),
            // 间距
            Visibility(
              visible: snapshot.data!["playlist"]["description"] != null,
              child: SizedBox(
                height: screenAdaptor.getLengthByOrientation(15.h, 25.h),
              ),
            ),
            // 控件区域
            _getControlWidget(),
          ],
        ),
      ),
    );
  }

  // 获取播放控件区域
  Widget _getControlWidget() {
    return Wrap(
      spacing: screenAdaptor.getLengthByOrientation(20.w, 15.w),
      children: [
        // 播放按钮
        TextButton(
          onPressed: logic.playButtonLogic,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.blue.withOpacity(0.1),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  screenAdaptor.getLengthByOrientation(10.h, 12.h),
                ),
              ),
            ),
            padding: MaterialStateProperty.all(
              EdgeInsets.fromLTRB(
                screenAdaptor.getLengthByOrientation(16.h, 25.h),
                screenAdaptor.getLengthByOrientation(10.h, 15.h),
                screenAdaptor.getLengthByOrientation(16.h, 25.h),
                screenAdaptor.getLengthByOrientation(10.h, 15.h),
              ),
            ),
          ),
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: screenAdaptor.getLengthByOrientation(15.sp, 10.sp),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
                color: const Color.fromRGBO(51, 94, 234, 1.0),
              ),
              children: [
                WidgetSpan(
                  child: SvgPicture.asset(
                    "lib/assets/icons/play.svg",
                    fit: BoxFit.contain,
                    width: screenAdaptor.getLengthByOrientation(17.w, 11.w),
                    color: const Color.fromRGBO(51, 94, 234, 1.0),
                  ),
                ),
                // 间距
                WidgetSpan(
                  child: SizedBox(
                    width: screenAdaptor.getLengthByOrientation(10.w, 7.w),
                  ),
                ),
                const TextSpan(
                  text: "播放",
                ),
              ],
            ),
          ),
        ),
        // 收藏按钮
        IconButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.black.withOpacity(0.05),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  screenAdaptor.getLengthByOrientation(10.h, 12.h),
                ),
              ),
            ),
            padding: MaterialStateProperty.all(
              EdgeInsets.fromLTRB(
                screenAdaptor.getLengthByOrientation(12.h, 18.h),
                screenAdaptor.getLengthByOrientation(9.8.h, 15.h),
                screenAdaptor.getLengthByOrientation(12.h, 18.h),
                screenAdaptor.getLengthByOrientation(9.8.h, 15.h),
              ),
            ),
          ),
          icon: SvgPicture.asset(
            "lib/assets/icons/heart.svg",
            fit: BoxFit.contain,
            width: screenAdaptor.getLengthByOrientation(23.w, 15.w),
            color: Colors.black,
          ),
        ),
        // 更多按钮
        IconButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.black.withOpacity(0.05),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  screenAdaptor.getLengthByOrientation(10.h, 12.h),
                ),
              ),
            ),
            padding: MaterialStateProperty.all(
              EdgeInsets.fromLTRB(
                screenAdaptor.getLengthByOrientation(12.h, 18.h),
                screenAdaptor.getLengthByOrientation(9.8.h, 15.h),
                screenAdaptor.getLengthByOrientation(12.h, 18.h),
                screenAdaptor.getLengthByOrientation(9.8.h, 15.h),
              ),
            ),
          ),
          icon: SvgPicture.asset(
            "lib/assets/icons/more.svg",
            fit: BoxFit.contain,
            width: screenAdaptor.getLengthByOrientation(23.w, 15.w),
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // 获取歌单图片
  Widget _getPlaylistImage(var snapshot) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        screenAdaptor.getLengthByOrientation(10.h, 20.h),
      ),
      child: SizedBox(
        height: screenAdaptor.getLengthByOrientation(300.h, 450.h),
        width: screenAdaptor.getLengthByOrientation(300.h, 450.h),
        child: Cover(
          imageUrl:
              snapshot.data!["playlist"]["coverImgUrl"] + "?param=400y400",
        ),
      ),
    );
  }
}
