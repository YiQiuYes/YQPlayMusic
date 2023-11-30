import 'package:dio/dio.dart';
import 'package:yqplaymusic/common/net/myoptions.dart';
import 'package:yqplaymusic/common/net/ssjrequestmanager.dart';

class AuthManager {
  const AuthManager();

  /// 获取二维码所需要的key
  Future<Response> loginQrKey({MyOptions? myOptions}) async {
    myOptions ??= MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {"type": 1};
    return await ssjRequestManager.post(
      "https://music.163.com/weapi/login/qrcode/unikey",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }

  // 生成二维码链接
  Future<Response> loginQrCreate({required String key}) async {
    String url = "https://music.163.com/login?codekey=$key";
    Map<String, dynamic> data = {};
    data["code"] = 200;
    data["data"] = {"qrurl": url};

    return Response<dynamic>(
        requestOptions: RequestOptions(), statusCode: 200, data: data);
  }

  /// 检查二维码登录是否成功
  Future<Response> loginQrCheck(
      {required String key, MyOptions? myOptions}) async {
    myOptions ??= MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {};
    queryParameters["key"] = key;
    queryParameters["type"] = "1";
    return await ssjRequestManager.post(
      "https://music.163.com/weapi/login/qrcode/client/login",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }

  /// 使用cookie登录并检查登录状态信息
  Future<Response> loginStatus() async {
    return await ssjRequestManager.post(
        "https://music.163.com/weapi/w/nuser/account/get",
        myOptions: MyOptions(crypto: "weapi"));
  }

  /// 判断是否登录成功
  Future<bool> checkLoginStatus() async {
    return await loginStatus().then((value) {
      // 如果account的数据不为空
      if (value.data["account"] != null) {
        // 登录成功
        return true;
      } else {
        // 登录失败
        return false;
      }
    });
  }
}

const AuthManager authManager = AuthManager();
