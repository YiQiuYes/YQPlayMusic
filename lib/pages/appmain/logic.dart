import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:yqplaymusic/common/utils/DataSaveManager.dart';
import '../../api/auth.dart';
import '../../common/utils/EventBusDistribute.dart';
import '../../common/utils/Player.dart';
import '../../common/utils/ShareData.dart';
import '../../router/AppMainRouteController.dart';
import 'state.dart';

class AppMainLogic extends GetxController {
  final AppMainState state = AppMainState();

  // 底部播放栏图片歌曲信息初始化获取
  void initMusicBarInfo() {
    // 获取音乐图片链接
    DataSaveManager.getLocalStorage("musicImageUrl").then((value) {
      if (value != null) {
        state.musicImgUrl.value = value;
      }
    });

    // 获取歌曲名字
    DataSaveManager.getLocalStorage("musicName").then((value) {
      if (value != null) {
        state.musicName.value = value;
      }
    });

    // 获取歌手信息
    DataSaveManager.getLocalStorage("musicArtist").then((value) {
      if (value != null) {
        state.musicArtist.value = value;
      }
    });
  }

  // 左上角按钮点击唤起侧边栏事件
  void handleMenuButtonPress() {
    state.advancedDrawerController.showDrawer();
  }

  // 返回键拦截
  Future<bool> onBackPressed() async {
    if (state.isLyricsPageShow.value) {
      // 开始执行动画
      state.lyricsPageAnimation = Tween<double>(
        begin: ScreenUtil().screenHeight,
        end: 0,
      ).animate(state.lyricsPageAnimationController);
      state.lyricsPageAnimationController.reverse().then((value) {
        state.isLyricsPageShow.value = false;
      });
      return false;
    }

    if(state.stackTabBarViewIndex.value != 0) {
      state.stackTabBarViewIndex.value--;
      Get.back(id: 1);
      return false;
    }

    if (state.advancedDrawerController.value.visible) {
      // 隐藏侧边栏
      state.advancedDrawerController.hideDrawer();
      return false;
    }

    return true;
  }

  // tab切换逻辑
  void handleTabChange({required int index}) {
    while(state.stackTabBarViewIndex.value != 0) {
      state.stackTabBarViewIndex.value--;
      Get.back(id: 1);
    }
    state.currentTabIndex.value = index;
    state.tabController.animateTo(index);
  }

  // 控制器初始化
  void tabControllerInit(TickerProvider tickerProvider) {
    state.tabController =
        TabController(length: state.tabViews.length, vsync: tickerProvider);
    state.tabController.addListener(() {
      switch (state.tabController.index) {
        case 0:
          {
            if (state.tabController.indexIsChanging) return;
            // 首页页面
            state.currentTabIndex.value = 0;
          }
          break;
        case 1:
          {
            if (state.tabController.indexIsChanging) return;
            // 我的页面
            state.currentTabIndex.value = 1;
          }
        case 2:
          {
            if (state.tabController.indexIsChanging) return;
            // 音乐库页面
            state.musicLibraryPageKey.currentState?.logic.getRandomLyric();
            state.currentTabIndex.value = 2;
          }
          break;
      }
    });

    // 切换为音乐库页面 TODO: 记得删除
    state.tabController.animateTo(0);
  }

  // 检查用户登录状态
  void checkLoginStatus() {
    authManager.loginStatus().then((value) {
      if (value.data["account"] != null) {
        state.drawerUserImgUrl.value = value.data["profile"]["avatarUrl"];
      }
    });
  }

  // 渐变颜色获取
  void getGradientColor() {
    PaletteGenerator.fromImageProvider(
            Image.network(state.drawerUserImgUrl.value).image)
        .then((value) {
      TinyColor color = TinyColor.fromColor(value.dominantColor!.color);
      Color dominantColorBottomRight = color.darken(10).color;
      Color dominantColorTopLeft = color.lighten(28).spin(-30).color;
      state.gradientColors.value = [
        dominantColorTopLeft,
        dominantColorBottomRight
      ];
    });
  }

  // 呼出歌词页面逻辑
  void showLyricsPageBtn() {
    // 开始执行动画
    state.lyricsPageAnimation = Tween<double>(
      begin: ScreenUtil().screenHeight,
      end: 0,
    ).animate(state.lyricsPageAnimationController);

    // 显示歌词页面
    state.isLyricsPageShow.value = true;
    state.lyricsPageAnimationController.forward();
  }

  // 定时器歌曲进度获取
  void listenMusicPrecess() {
    player.setCurrentPositionCb(() {
      double result =
          (player.duration == 0 ? 0 : player.position / player.duration);

      // 获取进度条进度
      if (result > 1.0) {
        state.musicProgress.value = 1.0;
      } else {
        state.musicProgress.value = result;
      }
    });
  }

  // 数据监听处理
  void handleDataListener() {
    state.streamSubscription =
        EventBusManager.eventBus.on<ShareData>().listen((event) {
      // 刷新数据
      if (event.mapData["musicImageUrl"] != null) {
        state.musicImgUrl.value = event.mapData["musicImageUrl"];
      }
      if (event.mapData["musicName"] != null) {
        state.musicName.value = event.mapData["musicName"];
      }
      if (event.mapData["musicArtist"] != null) {
        state.musicArtist.value = event.mapData["musicArtist"];
      }
      if (event.mapData["playAndPause"] != null) {
        state.isPlaying.value = event.mapData["playAndPause"];
      }
    });
  }

  // 底部MusicBar播放按钮处理逻辑
  void handleMusicBarPlayBtn() {
    if (state.isPlaying.value) {
      EventBusManager.eventBus.fire(ShareData(playAndPause: false));
    } else {
      EventBusManager.eventBus.fire(ShareData(playAndPause: true));
    }
    state.isPlaying.value = !state.isPlaying.value;
  }

  // 上一首按钮逻辑
  void handleMusicBarPreBtn() {
    EventBusManager.eventBus.fire(ShareData(previous: true));
  }

  // 下一首按钮逻辑
  void handleMusicBarNextBtn() {
    EventBusManager.eventBus.fire(ShareData(next: true));
  }
}
