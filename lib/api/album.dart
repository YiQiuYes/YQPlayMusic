import '../common/net/myoptions.dart';
import '../common/net/ssjrequestmanager.dart';
import 'package:dio/dio.dart';

class AlbumManager {
  const AlbumManager();

  /// 获取全部新碟
  /// ALL:全部,ZH:华语,EA:欧美,KR:韩国,JP:日本
  Future<Response> getNewAlbums({MyOptions? myOptions, int? limit, int? offset, String? area}) async {
    myOptions ??= MyOptions();
    myOptions.crypto = "weapi";
    Map<String, dynamic> queryParameters = {
      "limit" : limit ?? 30,
      "offset" : offset ?? 0,
      "total" : true,
      "area" : area ?? "ALL",
    };
    return await ssjRequestManager.post(
      "https://music.163.com/weapi/album/new",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }

  /// 获取专辑内容
  Future<Response> getAlbum({required String id}) async {
    MyOptions myOptions = MyOptions();
    myOptions.crypto = "weapi";
    // Map<String, dynamic> queryParameters = {
    //   "id" : id,
    // };

    return await ssjRequestManager.post(
      "https://music.163.com/weapi/v1/album/${id}",
      //queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }
}

const albumManager = AlbumManager();