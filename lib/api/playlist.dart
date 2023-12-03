import '../common/net/myoptions.dart';
import '../common/net/ssjrequestmanager.dart';
import 'package:dio/dio.dart';

// 歌单管理类
class PlayListManager {
  const PlayListManager();

  // 推荐歌单
  Future<Response> getRecommendPlayList(
      {MyOptions? myOptions, int? limit}) async {
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
  Future<Response> getDailyRecommendPlayList(
      {MyOptions? myOptions, int? limit}) async {
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

  /// 获取歌单（网友精选碟）
  ///  说明 : 调用此接口 , 可获取网友精选碟歌单
  ///  order: 可选值为 'new' 和 'hot', 分别对应最新和最热 , 默认为 'hot'
  ///  cat: tag, 比如 " 华语 "、" 古风 " 、" 欧美 "、" 流行 ", 默认为 "全部"
  ///  limit: 取出歌单数量 , 默认为 50
  Future<Response> getTopPlayList(
      {String? cat, String? order, int? limit, int? offset}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "cat": cat ?? "全部",
      "order": order ?? "hot",
      "limit": limit ?? 50,
      "offset": offset ?? 0,
      "total": true,
    };

    return await ssjRequestManager.post(
      "https://music.163.com/weapi/playlist/list",
      myOptions: myOptions,
      queryParameters: queryParameters,
    );
  }

  // 获取精品歌单
  Future<Response> getHighQualityPlayList(
      {String? cat, int? limit, int? lasttime}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "cat": cat ?? "全部",
      "limit": limit ?? 50,
      "lasttime": lasttime ?? 0,
    };

    return await ssjRequestManager.post(
      "https://music.163.com/api/playlist/highquality/list",
      myOptions: myOptions,
      queryParameters: queryParameters,
    );
  }

  /// 通过歌单id获取歌单详情
  /// 说明 : 调用此接口 , 传入歌单 id, 可获得歌单详情
  /// - [id] : 歌单 id
  /// - [s] : 歌单最近的 s 个收藏者,默认为8
  Future<Response> getPlaylistDetail(
      {int? id, int? s}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "id": id,
      "n": 100000,
      "s": s ?? 8,
    };

    return await ssjRequestManager.post(
      "https://music.163.com/weapi/v6/playlist/detail",
      myOptions: myOptions,
      queryParameters: queryParameters,
    );
  }
}

const playListManager = PlayListManager();
