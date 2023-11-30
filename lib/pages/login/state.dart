import 'dart:async';

import 'package:get/get.dart';

class LoginState {
  late RxString qrCodeUrl; // 登录二维码图片链接
  late RxString qrCodeKey; // 登录二维码的key
  late Timer timer; // 二维码检测是否登录成功定时器

  LoginState() {
    qrCodeUrl = "".obs;
    qrCodeKey = "".obs;
  }
}
