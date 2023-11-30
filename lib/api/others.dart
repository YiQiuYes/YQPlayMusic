import '../common/net/myoptions.dart';
import '../common/net/ssjrequestmanager.dart';
import 'package:dio/dio.dart';

class OthersManager {
  const OthersManager();

  // 获取私人FM
  Future<Response> getPersonalFM({MyOptions? myOptions}) async {
    myOptions ??= MyOptions();
    myOptions.crypto = "weapi";
    Map<String, dynamic> queryParameters = {};
    return await ssjRequestManager.post(
      "https://music.163.com/weapi/v1/radio/get",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }
}

const othersManager = OthersManager();