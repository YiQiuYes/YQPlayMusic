import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/api/playlist.dart';
import 'package:yqplaymusic/api/track.dart';

import '../../api/auth.dart';
import '../../api/user.dart';
import '../../common/utils/screenadaptor.dart';
import '../../router/routeconfig.dart';
import 'state.dart';
import 'dart:developer' as developer;

class MusicLibraryLogic extends GetxController {
  final MusicLibraryState state = MusicLibraryState();

  // 页面初始化
  void pageInit() {
    authManager.loginStatus().then((value) {
      if (value.data["account"] != null) {
        // 登录成功
        state.loginStatus.value = true;
        // 获取用户信息
        state.userInfo.value = value.data["profile"];
        state.userImgUrl.value = value.data["profile"]["avatarUrl"];

        // 获取我喜欢的音乐列表
        userManager
            .userPlayList(uid: state.userInfo["userId"])
            .then((value) async {
          var res = jsonDecode(value.data);

          // 通过id获取我喜欢的音乐信息
          await playListManager
              .getPlaylistDetail(id: res["playlist"][0]["id"])
              .then((value) {
            var res = jsonDecode(value.data);
            state.likeSongs.value = res["playlist"]["tracks"];
          });

          // 获取用户歌单去除list中的第一个元素
          state.userPlayList.value = res["playlist"].sublist(1);

          // 获取随机歌词
          if (state.randomLyric.isEmpty) {
            await getRandomLyric();
          }
        });

        // 获取用户收藏的专辑
        userManager.userLikedAlbums().then((value) {
          state.userLikedAlbums.value = value.data is String
              ? jsonDecode(value.data)["data"]
              : value.data["data"];
        });

        // 获取用户收藏的艺人
        userManager.userLikedArtists().then((value) {
          state.userLikedArtists.value = value.data is String
              ? jsonDecode(value.data)["data"]
              : value.data["data"];
        });

        // 获取用户收藏的MV
        userManager.userLikedMVs().then((value) {
          var res = value.data is String ? jsonDecode(value.data) : value.data;
          state.userLikedMVs.value = res["data"];
          // developer.log(state.userLikedMVs.toString());
        });

        // 获取云盘歌曲
        userManager.userCloudDisk(limit: 99999, offset: 0).then((value) {
          var res = value.data is String ? jsonDecode(value.data) : value.data;
          state.userCloudDiskSongs.value = res["data"];
        });

        // 获取听歌排行
        if (state.userHistorySongsRank.isEmpty) {
          loadUserHistoryRank(type: 1);
        }
      } else {
        // 未登录
        state.loginStatus.value = false;
        // 跳转登录页面
        Get.toNamed(RouteConfig.login);
      }
    });
  }

  // 获取TabBar标题Text
  List<Widget> getTabBarTitleText() {
    return state.tabBarTitles.map((element) {
      int index = state.tabBarTitles.indexOf(element);
      return Obx(() {
        return ClipRRect(
          borderRadius: BorderRadius.circular(
            screenAdaptor.getLengthByOrientation(12.w, 8.w),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              screenAdaptor.getLengthByOrientation(15.w, 12.w),
              screenAdaptor.getLengthByOrientation(7.w, 4.w),
              screenAdaptor.getLengthByOrientation(
                  index == 0 ? 9.w : 15.w, index == 0 ? 6.5.w : 12.w),
              screenAdaptor.getLengthByOrientation(7.w, 4.w),
            ),
            color: state.currentTabBarIndex.value == index
                ? const Color.fromRGBO(244, 244, 246, 1.0)
                : Colors.transparent,
            child: Visibility(
              visible: index != 0,
              replacement: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize:
                        screenAdaptor.getLengthByOrientation(20.sp, 14.sp),
                    fontWeight: FontWeight.bold,
                    color: state.currentTabBarIndex.value == index
                        ? const Color.fromRGBO(51, 94, 234, 1.0)
                        : const Color.fromRGBO(34, 34, 34, 0.76),
                  ),
                  children: [
                    WidgetSpan(
                      child: InkWell(
                        onTap: () {
                          state.currentTabBarIndex.value = index;
                        },
                        child: Text(
                          element,
                          style: TextStyle(
                            fontSize: screenAdaptor.getLengthByOrientation(
                                20.sp, 14.sp),
                            fontWeight: FontWeight.bold,
                            color: state.currentTabBarIndex.value == index
                                ? const Color.fromRGBO(51, 94, 234, 1.0)
                                : const Color.fromRGBO(34, 34, 34, 0.76),
                          ),
                        ),
                      ),
                    ),
                    WidgetSpan(
                      child: InkWell(
                        onTap: () {
                          state.currentTabBarIndex.value = index;
                        },
                        child: Container(
                          width:
                              screenAdaptor.getLengthByOrientation(25.w, 20.w),
                          padding: EdgeInsets.only(
                            left:
                                screenAdaptor.getLengthByOrientation(5.w, 5.w),
                            right:
                                screenAdaptor.getLengthByOrientation(5.w, 5.w),
                            top: screenAdaptor.getLengthByOrientation(5.w, 3.w),
                            bottom:
                                screenAdaptor.getLengthByOrientation(5.w, 3.w),
                          ),
                          child: SvgPicture.asset(
                            "lib/assets/icons/dropdown.svg",
                            width: screenAdaptor.getLengthByOrientation(
                                15.h, 28.h),
                            height: screenAdaptor.getLengthByOrientation(
                                15.h, 28.h),
                            fit: BoxFit.cover,
                            color: state.currentTabBarIndex.value == index
                                ? const Color.fromRGBO(51, 94, 234, 1.0)
                                : const Color.fromRGBO(34, 34, 34, 0.76),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              child: InkWell(
                onTap: () {
                  state.currentTabBarIndex.value = index;
                },
                child: Text(
                  element,
                  style: TextStyle(
                    fontSize:
                        screenAdaptor.getLengthByOrientation(20.sp, 14.sp),
                    fontWeight: FontWeight.bold,
                    color: state.currentTabBarIndex.value == index
                        ? const Color.fromRGBO(51, 94, 234, 1.0)
                        : const Color.fromRGBO(34, 34, 34, 0.76),
                  ),
                ),
              ),
            ),
          ),
        );
      });
    }).toList();
  }

  // 获取随机歌词
  Future<void> getRandomLyric() async {
    List likeSongs = state.likeSongs;
    if (likeSongs.isEmpty) {
      return;
    }
    // developer.log(likeSongs[0]["id"].runtimeType.toString());
    int id = likeSongs[Random().nextInt(likeSongs.length)]["id"];
    trackManager.getLyric(id: id.toString()).then((value) {
      String lyric = value.data is String
          ? (jsonDecode(value.data)["lrc"] != null
              ? jsonDecode(value.data)["lrc"]["lyric"]
              : "")
          : value.data["lrc"]["lyric"];
      // developer.log(lyric.runtimeType.toString());
      List isInstrumental = lyric
          .split("\n")
          .where((element) => !element.contains("纯音乐，请欣赏"))
          .toList();
      if (isInstrumental.isNotEmpty) {
        List<String> lyrics = lyric.split("\n");
        state.randomLyric.value = pickedLyric(lyrics);
      }
    });
  }

  // 摘取三行歌词
  String pickedLyric(List<String> lyrics) {
    // developer.log(state.randomLyric.toString());
    List lyricLines = lyrics
        .where((line) =>
            !line.contains("作词") &&
            !line.contains("作曲") &&
            line.split("]").last != " ")
        .toList();
    // 获取随机三行歌词
    int lyricsToPick = min(lyricLines.length, 3);
    int randomUpperBound = lyricLines.length - lyricsToPick;

    // 防止为0的时候报错
    if(randomUpperBound == 0) {
      return lyricLines.map((e) {
        return e.split("]").last;
      }).join("\n");
    }

    int startLyricLineIndex = Random().nextInt(randomUpperBound - 1);
    return lyricLines
        .sublist(startLyricLineIndex, startLyricLineIndex + lyricsToPick)
        .map((e) {
      return e.split("]").last;
    }).join("\n");
  }

  /// 处理听歌排行子选项逻辑
  /// -[type] 0 为最近一周 1 为所有时间
  Future<void> loadUserHistoryRank({required int type}) async {
    // 非空时才获取听歌排行信息
    if (state.loginStatus.value && state.userInfo.isNotEmpty) {
      userManager
          .userPlayHistory(uid: state.userInfo["userId"].toString(), type: type)
          .then((value) {
        Map res = value.data is String ? jsonDecode(value.data) : value.data;

        // 获取数据
        state.userHistorySongsRank.value =
            res[type == 0 ? "allData" : "weekData"];
        // developer.log(res.toString());
      });
    }
  }

  Future<void> refreshData() async {
    pageInit();
    getRandomLyric();
    loadUserHistoryRank(
        type: state.currentUserHistorySongsRank.value == 0 ? 1 : 0);
  }
}
