import 'package:dio/dio.dart';
import 'package:yqplaymusic/common/net/myoptions.dart';
import 'package:yqplaymusic/common/net/ssjrequestmanager.dart';

class TrackManager {
  const TrackManager();

  // 获取音乐品质
  int getBr() {
    return 350000;
  }

  /// 获取音乐url
  /// 说明 : 使用歌单详情接口后 , 能得到的音乐的 id, 但不能得到的音乐 url, 调用此接口, 传入的音乐 id( 可多个 , 用逗号隔开 ), 可以获取对应的音乐的 url
  /// !!!未登录状态返回试听片段(返回字段包含被截取的正常歌曲的开始时间和结束时间)
  Future<Response> getMusicUrl({required String id}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "ids": "[$id]",
      "br": getBr(),
    };
    return await ssjRequestManager.post(
      "https://interface3.music.163.com/weapi/song/enhance/player/url",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }

  /// 获取歌曲详情
  /// 说明 : 调用此接口 , 传入音乐 id( 可多个 , 用逗号隔开 ), 可获得歌曲详情(注意:歌曲封面现在需要通过专辑内容接口获取)
  /// - [ids] : 音乐 id, 如 ids=347230
  Future<Response> getMusicDetail({required List ids}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "c": "[${ids.map((e) => '{"id": $e}').join(",")}]",
    };
    return await ssjRequestManager.post(
      "https://music.163.com/weapi/v3/song/detail",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }

  // 获取歌词
  Future<Response> getLyric({required String id}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "id": id,
      "lv": -1,
      "kv": -1,
      "tv": -1,
      "rv": -1,
    };
    return await ssjRequestManager.post(
      "https://music.163.com/weapi/song/lyric?_nmclfl=1",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }
}

const TrackManager trackManager = TrackManager();
