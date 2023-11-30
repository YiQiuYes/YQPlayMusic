import '../common/net/myoptions.dart';
import '../common/net/ssjrequestmanager.dart';
import 'package:dio/dio.dart';
// 歌单管理类
class PlayListManager {
  const PlayListManager();

  // 推荐歌单
  Future<Response> getRecommendPlayList({MyOptions? myOptions, int? limit}) async {
    myOptions ??= MyOptions();
    myOptions.crypto = "weapi";
    Map<String, dynamic> queryParameters = {
      "limit": limit ?? 30,
      "total": true,
      "n": 1000,
    };
    return await ssjRequestManager.post(
      "https://music.163.com/weapi/personalized/playlist",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }

  // 获取每日推荐歌单 需要登录的情况下调用
  Future<Response> getDailyRecommendPlayList({MyOptions? myOptions, int? limit}) async {
    myOptions ??= MyOptions();
    myOptions.crypto = "weapi";
    Map<String, dynamic> queryParameters = {
      "limit": limit ?? 30,
      "total": true,
      "n": 1000,
    };
    return await ssjRequestManager.post(
      "https://music.163.com/weapi/v1/discovery/recommend/resource",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }

  // 获取每日推荐歌曲 需要登录的情况下调用
  Future<Response> getDailyRecommendTracks() async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    return await ssjRequestManager.post(
      "https://music.163.com/api/v3/discovery/recommend/songs",
      myOptions: myOptions,
    );
  }

  // 获取排行榜数据
  Future<Response> getTopLists() async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    return await ssjRequestManager.post(
      "https://music.163.com/api/toplist",
      myOptions: myOptions,
    );
  }
}

const playListManager = PlayListManager();
