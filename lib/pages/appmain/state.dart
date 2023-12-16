import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/pages/explore/view.dart';
import 'package:yqplaymusic/pages/home/view.dart';
import 'package:yqplaymusic/pages/music_library/view.dart';

class AppMainState {
  late AdvancedDrawerController advancedDrawerController; // 侧边栏页面控制器
  late RxString drawerUserImgUrl; // 侧边栏用户图片
  late TabController tabController; // Tab控制器
  late List<Widget> tabViews; // Tab页面列表
  late RxInt currentTabIndex; // 当前Tab索引
  // 渐变颜色列表
  late RxList<Color> gradientColors;
  // 音乐播放进度条
  late RxDouble musicProgress;

  // 歌词页动画限制
  late AnimationController lyricsPageAnimationController;
  Animation<double>? lyricsPageAnimation;
  // 歌词页是否在显示
  late RxBool isLyricsPageShow;

  // 音乐库页面key
  final GlobalKey<MusicLibraryPageState> musicLibraryPageKey =
      GlobalKey<MusicLibraryPageState>();

  // 数据共享监听器
  late StreamSubscription streamSubscription;
  // 音乐ID
  late RxInt musicId;
  // 音乐图片链接
  late RxString musicImgUrl;
  // 歌曲名字
  late RxString musicName;
  // 歌手名字
  late RxString musicArtist;
  // 是否在播放
  late RxBool isPlaying;


  AppMainState() {
    advancedDrawerController = AdvancedDrawerController();
    drawerUserImgUrl =
        "http://s4.music.126.net/style/web2/img/default/default_avatar.jpg?param=60y60"
            .obs;

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
    musicProgress = 0.0.obs;
    isLyricsPageShow = false.obs;
    currentTabIndex = 0.obs;
    musicId = 1456673752.obs;
    musicImgUrl = "https://p2.music.126.net/VnZiScyynLG7atLIZ2YPkw==/18686200114669622.jpg?param=224y224".obs;
    musicName = "歌曲名".obs;
    musicArtist = "歌手".obs;
    isPlaying = false.obs;
  }
}
