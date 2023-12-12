import 'package:bruno/bruno.dart';
import 'package:css_filter/css_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:yqplaymusic/common/utils/backdropcssfilter/css_filter.dart';
import 'package:yqplaymusic/common/utils/screenadaptor.dart';

import '../../common/alterwidgets/WDCustomTrackShape.dart';
import '../../common/utils/backdropcssfilter/filter.dart';
import '../../generated/l10n.dart';
import '../../router/routeconfig.dart';
import 'logic.dart';

class AppMainPage extends StatefulWidget {
  const AppMainPage({super.key});

  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage>
    with TickerProviderStateMixin {
  final logic = Get.put(AppMainLogic());
  final state = Get.find<AppMainLogic>().state;

  @override
  void initState() {
    super.initState();
    logic.tabControllerInit(this);
    // 检查用户登录状态
    logic.checkLoginStatus();
    // 获取渐变颜色
    logic.getGradientColor();
  }

  @override
  void dispose() {
    state.advancedDrawerController.dispose();
    state.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: logic.onBackPressed,
      child: AdvancedDrawer(
        backdrop: Obx(() {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: state.gradientColors.value,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          );
        }),
        controller: state.advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        // 侧边栏方向
        rtlOpening: false,
        // 是否禁用手势
        disabledGestures: false,
        // 禁止从侧边栏滑出
        availMoveWidth: -1,
        openRatio: 0.65,
        childDecoration: BoxDecoration(
          // 给原页面装饰圆角
          borderRadius: BorderRadius.all(
            Radius.circular(
              screenAdaptor.getLengthByOrientation(50.h, 40.h),
            ),
          ),
        ),
        drawer: SafeArea(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // 头像
                Container(
                  width: screenAdaptor.getLengthByOrientation(150.0.w, 100.w),
                  height: screenAdaptor.getLengthByOrientation(150.0.w, 100.w),
                  margin: EdgeInsets.only(
                    top: screenAdaptor.getLengthByOrientation(50.0.h, 20.0.h),
                    bottom:
                        screenAdaptor.getLengthByOrientation(60.0.h, 25.0.h),
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Obx(
                    () => CSSFilter.blur(
                      value: 0.3,
                      child: Image.network(state.drawerUserImgUrl.value),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenAdaptor.getLengthByOrientation(620.h, 250.h),
                  child: ListView(
                    padding: EdgeInsets.only(
                        left: screenAdaptor.getLengthByOrientation(50.w, 30.w)),
                    children: [
                      ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.account_circle_rounded,
                          size:
                              screenAdaptor.getLengthByOrientation(38.w, 22.w),
                        ),
                        title: Text(
                          S.of(context).drawer_tile_user,
                          style: TextStyle(
                            fontSize: screenAdaptor.getLengthByOrientation(
                                30.sp, 18.sp),
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.settings,
                          size:
                              screenAdaptor.getLengthByOrientation(38.w, 22.w),
                        ),
                        title: Text(
                          S.of(context).drawer_tile_setting,
                          style: TextStyle(
                            fontSize: screenAdaptor.getLengthByOrientation(
                                30.sp, 18.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize:
                        screenAdaptor.getLengthByOrientation(25.0.sp, 14.0.sp),
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical:
                          screenAdaptor.getLengthByOrientation(20.0.h, 16.0.h),
                    ),
                    child: const Text("Powered by YiQiu"),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: Scaffold(
          body: ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Stack(
              children: [
                SizedBox(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().screenHeight,
                  child: TabBarView(
                    controller: state.tabController,
                    children: state.tabViews,
                  ),
                ),
                // 顶部导航栏
                Positioned(
                  top: screenAdaptor.getLengthByOrientation(0.h, 0.h),
                  child: BackdropCSSFilter.blur(
                    value: 8,
                    child: SizedBox(
                      width: ScreenUtil().screenWidth,
                      child: BrnAppBar(
                        // 状态栏和底部栏样式
                        systemOverlayStyle: const SystemUiOverlayStyle(
                          statusBarColor: Colors.transparent,
                          statusBarIconBrightness: Brightness.dark,
                          statusBarBrightness: Brightness.dark,
                          systemNavigationBarColor: Colors.transparent,
                        ),
                        primary: true,
                        // 不显示底部分割线
                        showDefaultBottom: false,
                        backgroundColor:
                            const Color.fromRGBO(255, 255, 255, 0.75),
                        title: BrnTabBar(
                          indicatorColor: Colors.transparent,
                          backgroundcolor: Colors.transparent,
                          // tab边距
                          padding: EdgeInsets.fromLTRB(
                              screenAdaptor.getLengthByOrientation(160.w, 70.w),
                              0,
                              screenAdaptor.getLengthByOrientation(
                                  160.w, 100.w),
                              0),
                          mode: BrnTabBarBadgeMode.origin,
                          controller: state.tabController,
                          tabs: state.tabs,
                          onTap: logic.brnTabBarOnTap,
                          labelStyle: const TextStyle(
                            backgroundColor: Colors.transparent,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            backgroundColor: Colors.transparent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leadingWidth:
                            screenAdaptor.getLengthByOrientation(68.w, 100.w),
                        leading: IconButton(
                          onPressed: logic.handleMenuButtonPress, // 打开侧边栏
                          icon: const Icon(Icons.menu),
                        ),
                        themeData: BrnAppBarConfig(
                          itemSpacing: 0,
                          leftAndRightPadding: 0,
                        ),
                        actions: <Widget>[
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.search),
                          ),
                          SizedBox(
                            width: screenAdaptor.getLengthByOrientation(
                                15.w, 40.w),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // 底部播放栏
                Positioned(
                  bottom: screenAdaptor.getLengthByOrientation(0.h, 0.h),
                  child: _getMusicPlayBar(),
                ),
                // 获取进度条
                Positioned(
                  bottom: screenAdaptor.getLengthByOrientation(72.h, 118.h),
                  left: 0,
                  right: 0,
                  child: _getMusicPlayIndicator(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 获取音乐播放条
  Widget _getMusicPlayBar() {
    return BackdropCSSFilter.blur(
      value: 8,
      child: Container(
        height: screenAdaptor.getLengthByOrientation(80.h, 130.h),
        width: ScreenUtil().screenWidth,
        color: Colors.white.withOpacity(0.9),
        padding: EdgeInsets.fromLTRB(
          screenAdaptor.getLengthByOrientation(24.h, 105.h),
          screenAdaptor.getLengthByOrientation(12.h, 15.h),
          screenAdaptor.getLengthByOrientation(24.h, 115.h),
          screenAdaptor.getLengthByOrientation(25.h, 40.h),
        ),
        child: Stack(
          children: [
            // 歌曲图片
            Obx(() {
              return ClipRRect(
                borderRadius: BorderRadius.circular(
                    screenAdaptor.getLengthByOrientation(5.w, 4.w)),
                child: Image.network(
                  "${state.drawerUserImgUrl.value}?param=212y212",
                  fit: BoxFit.contain,
                ),
              );
            }),
            // 歌曲信息
            Positioned(
              left: screenAdaptor.getLengthByOrientation(58.h, 95.h),
              top: screenAdaptor.getLengthByOrientation(1.h, 5.h),
              right: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 歌词信息
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "歌曲名",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: screenAdaptor.getLengthByOrientation(
                              16.sp, 11.sp),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "歌手名",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize:
                              screenAdaptor.getLengthByOrientation(12.sp, 8.sp),
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                  // 间距
                  SizedBox(
                    width: screenAdaptor.getLengthByOrientation(18.w, 15.w),
                  ),
                  // 喜欢按钮
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "lib/assets/icons/heart.svg",
                      width: screenAdaptor.getLengthByOrientation(20.w, 13.w),
                      height: screenAdaptor.getLengthByOrientation(20.w, 13.w),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            // 中间播放控件
            Align(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "lib/assets/icons/previous.svg",
                      width: screenAdaptor.getLengthByOrientation(20.w, 13.w),
                      height: screenAdaptor.getLengthByOrientation(20.w, 13.w),
                    ),
                  ),
                  // 间距
                  SizedBox(
                    width: screenAdaptor.getLengthByOrientation(20.w, 15.w),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "lib/assets/icons/play.svg",
                      width: screenAdaptor.getLengthByOrientation(30.w, 20.w),
                      height: screenAdaptor.getLengthByOrientation(30.w, 20.w),
                    ),
                  ),
                  // 间距
                  SizedBox(
                    width: screenAdaptor.getLengthByOrientation(20.w, 15.w),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "lib/assets/icons/next.svg",
                      width: screenAdaptor.getLengthByOrientation(20.w, 13.w),
                      height: screenAdaptor.getLengthByOrientation(20.w, 13.w),
                    ),
                  ),
                ],
              ),
            ),
            // 右侧播放列表组
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 播放列表
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "lib/assets/icons/list.svg",
                      width: screenAdaptor.getLengthByOrientation(20.w, 13.w),
                      height: screenAdaptor.getLengthByOrientation(20.w, 13.w),
                    ),
                  ),
                  // 间距
                  SizedBox(
                    width: screenAdaptor.getLengthByOrientation(8.w, 5.w),
                  ),
                  // 循环播放
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "lib/assets/icons/repeat.svg",
                      width: screenAdaptor.getLengthByOrientation(20.w, 13.w),
                      height: screenAdaptor.getLengthByOrientation(20.w, 13.w),
                    ),
                  ),
                  // 间距
                  SizedBox(
                    width: screenAdaptor.getLengthByOrientation(8.w, 5.w),
                  ),
                  // 随机播放
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "lib/assets/icons/shuffle.svg",
                      width: screenAdaptor.getLengthByOrientation(20.w, 13.w),
                      height: screenAdaptor.getLengthByOrientation(20.w, 13.w),
                    ),
                  ),
                  // 间距
                  SizedBox(
                    width: screenAdaptor.getLengthByOrientation(8.w, 5.w),
                  ),
                  // 呼出歌词界面
                  IconButton(
                    onPressed: () {
                      Get.toNamed(RouteConfig.lyrics);
                    },
                    icon: SvgPicture.asset(
                      "lib/assets/icons/arrow-up.svg",
                      width: screenAdaptor.getLengthByOrientation(20.w, 13.w),
                      height: screenAdaptor.getLengthByOrientation(20.w, 13.w),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 获取音乐播放进度条指示器
  Widget _getMusicPlayIndicator() {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 3,
        inactiveTrackColor: Colors.grey[300],
        activeTrackColor: Colors.blue,
        disabledActiveTrackColor: Colors.blue,
        disabledInactiveTrackColor: Colors.blue,
        thumbColor: Colors.white,
        trackShape: WDCustomTrackShape(addHeight: 0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
      ),
      child: Obx(() {
        return Slider(
          value: state.musicProgress.value,
          onChanged: (value) {
            state.musicProgress.value = value;
          },
        );
      }),
    );
  }
}
