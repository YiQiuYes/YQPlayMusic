import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/pages/appmain/view.dart';
import 'package:yqplaymusic/pages/login/view.dart';
import 'package:yqplaymusic/pages/lyrics/view.dart';

class RouteConfig {
  //主页面
  static const String main = "/";
  static const String login = "/loginPage";
  static const String lyrics = "/lyricsPage";

  static final List<GetPage> getPages = [
    GetPage(name: main, page: () => const AppMainPage()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(
      name: lyrics,
      page: () => const LyricsPage(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 200),
      showCupertinoParallax: false,
    ),
  ];
}
