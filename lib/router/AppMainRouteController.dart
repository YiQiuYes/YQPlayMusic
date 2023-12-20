import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/pages/album/view.dart';
import 'package:yqplaymusic/pages/playlist/view.dart';

import '../pages/appmain/logic.dart';

class AppMainRouteController extends GetxController {
  static const String main = "/";
  static const String playlist = "/playlistPage";
  static const String album = "/albumPage";

  // 获取首页TabBarView
  Widget getTabBarView() {
    final state = Get.find<AppMainLogic>().state;
    return Scaffold(
      body: TabBarView(
        controller: state.tabController,
        children: state.tabViews,
      ),
    );
  }

  static final Map<String, Widget> pages = {
    main: AppMainRouteController().getTabBarView(),
    playlist: PlayListPage(),
    album: AlbumPage(),
  };

  Route? onGenerateRoute(RouteSettings settings) {
    GetPageRoute? getPageRoute;
    pages.forEach((key, value) {
      if (settings.name == key) {
        getPageRoute = GetPageRoute(
          settings: settings,
          page: () => value,
          transition: Transition.circularReveal,
          transitionDuration: const Duration(milliseconds: 200),
          showCupertinoParallax: false,
        );
      }
    });

    final state = Get.find<AppMainLogic>().state;
    // 如果不是主页
    if (settings.name != main) {
      state.stackTabBarViewIndex.value++;
    }

    return getPageRoute;
  }
}
