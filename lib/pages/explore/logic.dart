import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../api/auth.dart';
import '../../api/playlist.dart';
import '../../common/utils/screenadaptor.dart';
import '../../components/CoverRow.dart';
import 'state.dart';
import 'dart:developer' as developer;

class ExploreLogic extends GetxController {
  final ExploreState state = ExploreState();

  // 判断登陆状态
  Future<void> checkLoginStatus() async {
    await authManager.checkLoginStatus().then((value) {
      state.loginStatus.value = value;
    });
  }

  // 返回一个导航栏组件
  Widget buildGuildTile(Map<String, dynamic> e) {
    Row widget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
              screenAdaptor.getLengthByOrientation(10.h, 15.h)),
          child: Obx(() {
            return InkWell(
              onTap: () {
                state.selectedCategory.value = e["name"];
                if(state.lastSelectedCategory.value != e["name"]) {
                  state.lastSelectedCategory.value = e["name"];
                  state.playListsData.clear();
                  state.futurePlayLists.value = loadPlayList();
                }
              },
              borderRadius: BorderRadius.circular(
                  screenAdaptor.getLengthByOrientation(10.h, 15.h)),
              child: Container(
                padding: EdgeInsets.only(
                    top: screenAdaptor.getLengthByOrientation(8.h, 10.h),
                    bottom: screenAdaptor.getLengthByOrientation(8.h, 10.h),
                    left: screenAdaptor.getLengthByOrientation(16.h, 25.h),
                    right: screenAdaptor.getLengthByOrientation(16.h, 25.h)),
                color: state.selectedCategory.value == e["name"]
                    ? const Color.fromRGBO(52, 94, 234, 0.18)
                    : const Color.fromRGBO(244, 244, 246, 1.0),
                child: Text(
                  e["name"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:
                        screenAdaptor.getLengthByOrientation(15.sp, 12.sp),
                    color: state.selectedCategory.value == e["name"]
                        ? const Color.fromRGBO(51, 94, 234, 1.0)
                        : const Color.fromRGBO(122, 122, 122, 1.0),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );

    state.playlistCategoriesWidgetInfo[e["name"]] = widget;
    return widget;
  }

  // 获取页面选择表
  Widget getEnableCategories() {
    state.playlistCategoriesShowData = state.playlistCategories
        .where((element) => element['enable'] == true)
        .toList()
        .obs;

    state.playlistCategoriesWidget = state.playlistCategoriesShowData
        .map((e) {
          return buildGuildTile(e);
        })
        .toList()
        .obs;

    // 添加更多
    state.playlistCategoriesWidget.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
                screenAdaptor.getLengthByOrientation(10.h, 15.h)),
            child: Obx(() {
              return InkWell(
                onTap: () {
                  state.selectedCategory.value = "more";
                },
                borderRadius: BorderRadius.circular(
                    screenAdaptor.getLengthByOrientation(10.h, 15.h)),
                child: Container(
                  padding: EdgeInsets.only(
                      top: screenAdaptor.getLengthByOrientation(8.h, 10.h),
                      bottom: screenAdaptor.getLengthByOrientation(8.h, 10.h),
                      left: screenAdaptor.getLengthByOrientation(16.h, 25.h),
                      right: screenAdaptor.getLengthByOrientation(16.h, 25.h)),
                  color: state.selectedCategory.value == "more"
                      ? const Color.fromRGBO(52, 94, 234, 0.18)
                      : const Color.fromRGBO(244, 244, 246, 1.0),
                  child: SvgPicture.asset(
                    "lib/assets/icons/more.svg",
                    color: state.selectedCategory.value == "more"
                        ? const Color.fromRGBO(51, 94, 234, 1.0)
                        : const Color.fromRGBO(122, 122, 122, 1.0),
                    width: screenAdaptor.getLengthByOrientation(22.h, 40.h),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );

    return Obx(
      () => Wrap(
        spacing: screenAdaptor.getLengthByOrientation(20.h, 30.h),
        runSpacing: screenAdaptor.getLengthByOrientation(20.h, 30.h),
        children: state.playlistCategoriesWidget.value,
      ),
    );
  }

  // 获取分类面板
  Widget getEnableCategoriesPanel() {
    // 列表标签Text组件
    List<Widget> listCategories = [];
    listCategories.add(SizedBox(
      height: screenAdaptor.getLengthByOrientation(15.h, 30.h),
    ));
    listCategories.addAll(state.playlistCategoriesTile.map((e) {
      // 获取相对应的标签
      List<dynamic> listText = state.playlistCategories.where((element) {
        return element["bigCat"] == e;
      }).toList();

      // 获取标签内容Widget --华语
      List<Widget> tileWidgetList = listText.map((e) {
        return InkWell(
          onTap: () {
            // 添加原始数据
            if (!state.playlistCategoriesShowData.contains(e)) {
              state.playlistCategoriesShowData.add(e);
              // 添加组件到导航栏倒数第二个位置
              state.playlistCategoriesWidget.insert(
                  state.playlistCategoriesWidget.length - 1, buildGuildTile(e));
            } else {
              // 删除原始数据
              state.playlistCategoriesShowData.remove(e);
              // 删除组件
              state.playlistCategoriesWidget
                  .remove(state.playlistCategoriesWidgetInfo[e["name"]]);
              state.playlistCategoriesWidgetInfo.remove(e["name"]);
            }
          },
          child: Obx(() {
            return SizedBox(
              width: screenAdaptor.getLengthByOrientation(83.h, 180.h),
              child: Text(
                e["name"],
                style: TextStyle(
                  fontSize: screenAdaptor.getLengthByOrientation(15.sp, 12.sp),
                  color: state.playlistCategoriesShowData.contains(e)
                      ? const Color.fromRGBO(51, 94, 234, 0.7)
                      : const Color.fromRGBO(34, 34, 34, 0.76),
                ),
              ),
            );
          }),
        );
      }).toList();

      return Padding(
        padding: EdgeInsets.only(
            left: screenAdaptor.getLengthByOrientation(24.h, 50.h),
            right: screenAdaptor.getLengthByOrientation(24.h, 50.h)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      right: screenAdaptor.getLengthByOrientation(25.h, 50.h)),
                  child: Center(
                    child: Text(
                      e,
                      style: TextStyle(
                        fontSize:
                            screenAdaptor.getLengthByOrientation(25.sp, 20.sp),
                        fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(34, 34, 34, 0.76),
                        height: 0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenAdaptor.getLengthByOrientation(500.h, 1250.h),
                  child: Container(
                    // 将列表字符下移
                    margin: EdgeInsets.only(
                        top: screenAdaptor.getLengthByOrientation(3.h, 5.h)),
                    child: Wrap(
                      spacing: screenAdaptor.getLengthByOrientation(20.h, 30.h),
                      runSpacing:
                          screenAdaptor.getLengthByOrientation(20.h, 35.h),
                      children: tileWidgetList,
                    ),
                  ),
                ),
              ],
            ),
            // 间距
            SizedBox(
              height: screenAdaptor.getLengthByOrientation(30.h, 80.h),
            ),
          ],
        ),
      );
    }).toList());

    return Obx(() {
      return Visibility(
        visible: state.selectedCategory.value == "more",
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              screenAdaptor.getLengthByOrientation(10.h, 15.h)),
          child: Container(
            color: const Color.fromRGBO(244, 244, 246, 1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listCategories,
            ),
          ),
        ),
      );
    });
  }

  String getSubText() {
    switch (state.selectedCategory.value) {
      case "排行榜":
        return "updateFrequency";
      case "推荐歌单":
        return "copywriter";
      default:
        return "";
    }
  }

  // 获取歌单列表
  Future<List<dynamic>> loadPlayList() async {
    // 判断state.loginStatus是否为false
    if (state.loginStatus.value == false) {
      await checkLoginStatus();
    }

    if (state.loginStatus.value) {
      state.isLoadNewData = true;
      switch (state.selectedCategory.value) {
        case "排行榜":
          return await playListManager.getTopLists().then((value) {
            return value.data["list"];
          });
        case "推荐歌单":
          var resRecommend = await playListManager
              .getRecommendPlayList(limit: 92)
              .then((value) => jsonDecode(value.data));

          var resDailyRecommend = await playListManager
              .getDailyRecommendPlayList(limit: 8)
              .then((value) => jsonDecode(value.data));

          if (resDailyRecommend["code"] == 200 && resRecommend["code"] == 200) {
            List<dynamic> list = [];
            // 合并list
            list.addAll(resDailyRecommend["recommend"]);
            list.addAll(resRecommend["result"]);

            return list;
          }
          break;
        case "精品歌单":
          int lasttime = 0;
          if (state.playListsData.isNotEmpty) {
            lasttime = state.playListsData.last["updateTime"];
          } else {
            lasttime = 0;
          }

          return await playListManager
              .getHighQualityPlayList(limit: 50, lasttime: lasttime)
              .then((value) {
            var res = jsonDecode(value.data);
            return res["playlists"];
          });
      }

      return await playListManager
          .getTopPlayList(
              cat: state.selectedCategory.value,
              offset: state.playListsData.length)
          .then((value) {
        var res = jsonDecode(value.data);
        return res["playlists"];
      });
    }

    return [];
  }

  // 获取专辑组件
  Widget getPlayListWidget() {
    return Obx(
      () => FutureBuilder(
        future: state.futurePlayLists.value,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data.isNotEmpty) {
            List<Widget> widgets = [];
            if (state.isLoadNewData) {
              state.playListsData.addAll(snapshot.data);
            }
            state.isLoadNewData = false;

            for (var i = 0; i < state.playListsData.length; i += 5) {
              widgets.add(
                SingleChildScrollView(
                  //physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: CoverRow(
                    items: state.playListsData.sublist(
                        i,
                        i + 5 > state.playListsData.length
                            ? state.playListsData.length
                            : i + 5),
                    subText: getSubText(),
                    type: "playlist",
                    showPlayCount: true,
                  ),
                ),
              );
              widgets.add(
                SizedBox(
                  height: screenAdaptor.getLengthByOrientation(30.w, 25.w),
                ),
              );
            }
            // 移除最后一个多余的SizedBox
            widgets.removeLast();

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return widgets[index];
              },
              itemCount: widgets.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            );
          }

          return SizedBox(
            height: screenAdaptor.getLengthByOrientation(481.h, 25.h),
          );
        },
      ),
    );
  }
}
