import 'package:dio/dio.dart';
import 'package:yqplaymusic/common/net/myoptions.dart';
import 'package:yqplaymusic/common/net/ssjrequestmanager.dart';

class UserManager {
  const UserManager();

  /// 获取用户详情
  /// 说明: 登录后调用此接口 , 传入用户 id, 可以获取用户详情
  /// - [uid] : 用户 id
  /// - [myOptions] : 可选参数
  Future<Response> userDetail({required int uid}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    return await ssjRequestManager.post(
      "https://music.163.com/weapi/v1/user/detail/$uid",
      myOptions: myOptions,
    );
  }

  /// 喜欢的歌曲列表无序
  Future<Response> userLikedSongsIDs({required int uid}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "uid": uid,
    };
    return await ssjRequestManager.post(
      "https://music.163.com/weapi/song/like/get",
      myOptions: myOptions,
      queryParameters: queryParameters,
    );
  }

  // 获取用户歌单
  Future<Response> userPlayList({required int uid, int? limit, int? offset}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "uid": uid,
      "limit": limit ?? 30,
      "offset": offset ?? 0,
      "includeVideo": true,
    };
    return await ssjRequestManager.post(
      "https://music.163.com/weapi/user/playlist",
      myOptions: myOptions,
      queryParameters: queryParameters,
    );
  }
}

const UserManager userManager = UserManager();
