import 'dart:async';

import 'package:get/get.dart';
import 'package:yqplaymusic/api/auth.dart';
import 'package:yqplaymusic/common/net/myoptions.dart';
import 'package:yqplaymusic/router/routeconfig.dart';

import 'state.dart';

class LoginLogic extends GetxController {
  final LoginState state = LoginState();

  void getQrImageUrl() {
    authManager
        .loginQrKey(myOptions: MyOptions(crypto: "weapi"))
        .then((value) async {
      String key = value.data["unikey"];
      state.qrCodeKey.value = key;
      String url = await authManager
          .loginQrCreate(key: key)
          .then((value) => value.data["data"]["qrurl"]);
      state.qrCodeUrl.value = url;
    });
  }

  // 检测是否扫码成功
  void checkQrLogin() {
    state.timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      authManager
          .loginQrCheck(
              key: state.qrCodeKey.value, myOptions: MyOptions(crypto: "weapi"))
          .then((value) {
        if (value.data["code"] == 803) {
          timer.cancel(); // 取消定时器
          // 跳转到主页
          Get.offNamed(RouteConfig.main);
        }
      });
    });
  }

  // 判断是否登录成功
  void checkLoginStatus() {
    authManager.loginStatus().then((value) {
      // 如果accout的数据不为空
      if (value.data["account"] != null) {
        // 跳转到主页
        Get.offNamed(RouteConfig.main);
      } else {
        // 获取二维码链接
        getQrImageUrl();
        // 检测是否扫码成功
        checkQrLogin();
      }
    });
  }
}
