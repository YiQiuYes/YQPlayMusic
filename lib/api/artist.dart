import '../common/net/myoptions.dart';
import '../common/net/ssjrequestmanager.dart';
import 'package:dio/dio.dart';

class ArtistManager {
  const ArtistManager();

  // 歌手榜
  Future<Response> getTopListOfArtists({MyOptions? myOptions, int? limit, int? offset}) async {
    myOptions ??= MyOptions();
    myOptions.crypto = "weapi";
    Map<String, dynamic> queryParameters = {
      "limit" : limit ?? 50,
      "offset" : offset ?? 0,
      "total" : true,
    };
    return await ssjRequestManager.post(
      "https://music.163.com/weapi/artist/top",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }
}

const artistManager = ArtistManager();