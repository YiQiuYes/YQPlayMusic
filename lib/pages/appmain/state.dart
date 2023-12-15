import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/pages/explore/view.dart';
import 'package:yqplaymusic/pages/home/view.dart';
import 'package:yqplaymusic/pages/music_library/view.dart';

import '../../generated/l10n.dart';

class AppMainState {
  late AdvancedDrawerController advancedDrawerController; // 侧边栏页面控制器
  late RxString drawerUserImgUrl; // 侧边栏用户图片
  late List<BadgeTab> tabs; // Tab列表
  late TabController tabController; // Tab控制器
  late List<Widget> tabViews; // Tab页面列表
  // 渐变颜色列表
  late RxList<Color> gradientColors;
  // 音乐播放进度条
  late RxDouble musicProgress;

  // 歌词页动画限制
  late AnimationController lyricsPageAnimationController;
  Animation<double>? lyricsPageAnimation;
  // 歌词页是否在显示
  late bool isLyricsPageShow;

  // 音乐库页面key
  final GlobalKey<MusicLibraryPageState> musicLibraryPageKey =
      GlobalKey<MusicLibraryPageState>();

  AppMainState() {
    advancedDrawerController = AdvancedDrawerController();
    drawerUserImgUrl =
        "http://s4.music.126.net/style/web2/img/default/default_avatar.jpg?param=60y60"
            .obs;
    // 添加顶部tab
    tabs = [];
    tabs.add(BadgeTab(text: S.current.appbar_tab_home));
    tabs.add(BadgeTab(text: S.current.appbar_tab_explore));
    tabs.add(BadgeTab(text: S.current.appbar_tab_library));

    // 添加顶部tab对应的页面
    tabViews = [
      const HomePage(),
      const ExplorePage(),
      MusicLibraryPage(key: musicLibraryPageKey),
    ];

    // 渐变颜色列表
    gradientColors = [
      Colors.blueGrey,
      Colors.blueGrey.withOpacity(0.2),
    ].obs;

    // 音乐播放进度条
    musicProgress = 0.5.obs;
    isLyricsPageShow = false;
  }
}
