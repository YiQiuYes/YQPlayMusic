import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/api/playlist.dart';
import 'package:yqplaymusic/components/CoverRow.dart';

import '../../api/auth.dart';
import '../../api/user.dart';
import '../../common/utils/screenadaptor.dart';
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
      }
    });
  }

  // 获取TabBar标题Text
  List<Widget> getTabBarTitleText() {
    return state.tabBarTitles.map((element) {
      int index = state.tabBarTitles.indexOf(element);
      return Obx(() {
        return InkWell(
          borderRadius: BorderRadius.circular(
            screenAdaptor.getLengthByOrientation(14.w, 8.w),
          ),
          onTap: () {
            state.currentTabBarIndex.value = index;
            // 滑到顶部
            pageScrollTo();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              screenAdaptor.getLengthByOrientation(14.w, 8.w),
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                screenAdaptor.getLengthByOrientation(18.w, 12.w),
                screenAdaptor.getLengthByOrientation(10.w, 4.w),
                screenAdaptor.getLengthByOrientation(18.w, 12.w),
                screenAdaptor.getLengthByOrientation(10.w, 4.w),
              ),
              color: state.currentTabBarIndex.value == index
                  ? const Color.fromRGBO(244, 244, 246, 1.0)
                  : Colors.transparent,
              child: Text(
                element,
                style: TextStyle(
                  fontSize: screenAdaptor.getLengthByOrientation(20.sp, 14.sp),
                  fontWeight: FontWeight.bold,
                  color: state.currentTabBarIndex.value == index
                      ? const Color.fromRGBO(51, 94, 234, 1.0)
                      : const Color.fromRGBO(34, 34, 34, 0.76),
                ),
              ),
            ),
          ),
        );
      });
    }).toList();
  }

  // 页面跳转
  void pageScrollTo() {
    state.pageController.animateTo(
      screenAdaptor.getLengthByOrientation(461.2.w, 275.2.w),
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  Future<void> refreshData() async {
    pageInit();
  }
}
