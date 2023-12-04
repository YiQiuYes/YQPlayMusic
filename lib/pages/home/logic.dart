import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:yqplaymusic/api/album.dart';
import 'package:yqplaymusic/api/artist.dart';
import 'package:yqplaymusic/api/auth.dart';
import 'package:yqplaymusic/api/playlist.dart';

import '../../api/others.dart';
import 'state.dart';
import 'dart:developer' as developer;

class HomeLogic extends GetxController {
  final HomeState state = HomeState();

  // 判断登陆状态
  Future<void> checkLoginStatus() async {
    await authManager.checkLoginStatus().then((value) {
      state.loginStatus.value = value;
    });
  }

  // 通过判断是否登录成功来获取每日推荐和推荐歌单专辑
  Future<List<dynamic>> getRecommendByLoginStatus() async {
    // 判断state.loginStatus是否为false
    if (state.loginStatus.value == false) {
      await checkLoginStatus();
    }
    if (state.loginStatus.value) {
      var resRecommend = await playListManager
          .getRecommendPlayList(limit: 8)
          .then((value) => jsonDecode(value.data));

      var resDailyRecommend = await playListManager
          .getDailyRecommendPlayList(limit: 30)
          .then((value) => jsonDecode(value.data));

      if (resDailyRecommend["code"] == 200 && resRecommend["code"] == 200) {
        List<dynamic> list = [];
        // 合并list
        list.addAll(resDailyRecommend["recommend"]);
        list.addAll(resRecommend["result"]);

        return list;
      }
    } else {
      var resDailyRecommend = await playListManager
          .getDailyRecommendPlayList(limit: 8)
          .then((value) => value.data);

      if (resDailyRecommend["code"] != 200) {
        return [];
      }

      if (jsonDecode(resDailyRecommend)["code"] == 200) {
        return jsonDecode(resDailyRecommend)["recommend"];
      }
    }

    return [];
  }

  // 获取每日推荐歌曲
  Future<List<dynamic>> loadDailyTracksSongs() async {
    // 判断state.loginStatus是否为false
    if (state.loginStatus.value == false) {
      await checkLoginStatus();
    }
    if (state.loginStatus.value) {
      var res = await playListManager
          .getDailyRecommendTracks()
          .then((value) => jsonDecode(value.data));
      return res["data"]["dailySongs"];
    }
    return [];
  }

  // 获取私人FM数据
  Future<List<dynamic>> loadPersonalFM() async {
    // 判断state.loginStatus是否为false
    if (state.loginStatus.value == false) {
      await checkLoginStatus();
    }
    if (state.loginStatus.value) {
      var res = await othersManager.getPersonalFM().then((value) => value.data);
      return res["data"];
    }
    return [];
  }

  // 获取推荐艺人数据
  Future<List<dynamic>> loadRecommendArtist() async {
    // 判断state.loginStatus是否为false
    if (state.loginStatus.value == false) {
      await checkLoginStatus();
    }

    if (state.loginStatus.value) {
      // 随机数0到50的整数
      var offset = Random().nextInt(50);

      var res = await artistManager
          .getTopListOfArtists(limit: 6, offset: offset)
          .then((value) {
        return jsonDecode(value.data);
      });

      return res["artists"];
    }
    return [];
  }

  // 获取新专数据
  Future<List<dynamic>> loadNewAlbums() async {
    // 判断state.loginStatus是否为false
    if (state.loginStatus.value == false) {
      await checkLoginStatus();
    }

    if (state.loginStatus.value) {
      var res = await albumManager.getNewAlbums(limit: 10).then((value) {
        return jsonDecode(value.data);
      });

      return res["albums"];
    }
    return [];
  }

  // 获取排行榜数据
  Future<List<dynamic>> loadTopList() {
    return playListManager.getTopLists().then((value) {
      List<dynamic> test = value.data["list"];
      return test.where((dynamic element) {
        return state.topListIds.contains(element["id"]);
      }).toList();
    });
  }

  // 刷新数据
  Future<void> refreshData() async {
    state.recommendList.value = getRecommendByLoginStatus();
    state.dailyTracksList.value = loadDailyTracksSongs();
    state.personalFMList.value = loadPersonalFM();
    state.recommendArtistList.value = loadRecommendArtist();
    state.newAlbumsList.value = loadNewAlbums();
    state.topList.value = loadTopList();
  }
}
