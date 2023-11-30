import 'package:get/get.dart';
import 'package:yqplaymusic/pages/appmain/view.dart';
import 'package:yqplaymusic/pages/login/view.dart';

class RouteConfig {
  //主页面
  static const String main = "/";
  static const String login = "/loginPage";

  static final List<GetPage> getPages = [
    GetPage(name: main, page: () => const AppMainPage()),
    GetPage(name: login, page: () => const LoginPage()),
  ];
}