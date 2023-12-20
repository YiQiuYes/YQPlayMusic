import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/pages/album/view.dart';
import 'package:yqplaymusic/pages/appmain/view.dart';
import 'package:yqplaymusic/pages/login/view.dart';
import 'package:yqplaymusic/pages/lyrics/view.dart';
import 'package:yqplaymusic/pages/playlist/view.dart';

class RouteConfig {
  //主页面
  static const String main = "/";
  static const String login = "/loginPage";
  static const String album = "/albumPage";
  //static const String playlist = "/playlistPage";

  static final List<GetPage> getPages = [
    GetPage(name: main, page: () => const AppMainPage()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(
      name: album,
      page: () => AlbumPage(),
      transition: Transition.circularReveal,
      transitionDuration: const Duration(milliseconds: 200),
      showCupertinoParallax: false,
    ),
    // GetPage(
    //   name: playlist,
    //   page: () => PlaylistPage(),
    //   transition: Transition.circularReveal,
    //   transitionDuration: const Duration(milliseconds: 200),
    //   showCupertinoParallax: false,
    // ),
  ];
}
