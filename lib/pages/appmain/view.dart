import 'package:bruno/bruno.dart';
import 'package:css_filter/css_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:yqplaymusic/common/utils/backdropcssfilter/css_filter.dart';
import 'package:yqplaymusic/common/utils/screenadaptor.dart';

import '../../common/utils/backdropcssfilter/filter.dart';
import '../../generated/l10n.dart';
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
    logic.tabControllerInit(this);
    // 检查用户登录状态
    logic.checkLoginStatus();
    // 获取渐变颜色
    logic.getGradientColor();
    super.initState();
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
