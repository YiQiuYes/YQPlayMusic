// 操作类
import 'package:dio/dio.dart';

class MyOptions extends Options{
  String? crypto;
  String? proxy;
  String? reaIP;
  String? ua;

  MyOptions({this.crypto, this.proxy, this.reaIP, this.ua});

  Map<String, dynamic> getMyOptions() {
    Map<String, dynamic> options = {};
    options["crypto"] = crypto;
    options["proxy"] = proxy;
    options["reaIP"] = reaIP;
    options["ua"] = ua;

    return options;
  }
}