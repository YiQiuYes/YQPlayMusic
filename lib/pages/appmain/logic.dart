import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:tinycolor2/tinycolor2.dart';
import '../../api/auth.dart';
import 'state.dart';

class AppMainLogic extends GetxController {
  final AppMainState state = AppMainState();

  // 左上角按钮点击唤起侧边栏事件
  void handleMenuButtonPress() {
    state.advancedDrawerController.showDrawer();
  }

  // 返回键拦截
  Future<bool> onBackPressed() async {
    if (state.advancedDrawerController.value.visible) {
      state.advancedDrawerController.hideDrawer(); // 隐藏侧边栏
      return false;
    }

    return true;
  }

  void tabControllerInit(TickerProvider tickerProvider) {
    state.tabController =
        TabController(length: state.tabs.length, vsync: tickerProvider);
    state.tabController.addListener(() {
      switch(state.tabController.index) {
        case 2:
          // 音乐库页面
          state.musicLibraryPageKey.currentState?.logic.getRandomLyric();
          break;
      }
    });

    // 切换为音乐库页面 TODO: 记得删除
    state.tabController.animateTo(0);
  }

  // 路由跳转控制
  void brnTabBarOnTap(BrnTabBarState brnState, int index) {
    brnState.refreshBadgeState(index);
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
    PaletteGenerator.fromImageProvider(Image.network(state.drawerUserImgUrl.value).image).then((value) {
      TinyColor color = TinyColor.fromColor(value.dominantColor!.color);
      Color dominantColorBottomRight = color.darken(10).color;
      Color dominantColorTopLeft = color.lighten(28).spin(-30).color;
      state.gradientColors.value = [dominantColorTopLeft, dominantColorBottomRight];
    });
  }
}
