import 'dart:convert';

import 'package:get/get.dart';
import 'package:yqplaymusic/api/playlist.dart';

import '../../api/auth.dart';
import '../../api/user.dart';
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
        });
      }
    });
  }
}
