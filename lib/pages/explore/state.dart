import '../../common/utils/staticdata.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ExploreState {
  late List<Map<String, dynamic>> playlistCategories;
  // 被选择中的分类
  late RxString selectedCategory;
  // 上一次被选中的分类
  late RxString lastSelectedCategory;
  // 分类面板总分类标题
  late List<String> playlistCategoriesTile;
  // 分类导航展示数据
  late RxList<dynamic> playlistCategoriesShowData;
  // 分类导航栏
  late RxList<Widget> playlistCategoriesWidget;
  // 分类导航栏组件信息
  late Map<String, dynamic> playlistCategoriesWidgetInfo;

  // 登陆状态
  late RxBool loginStatus;
  // 用于异步获取专辑数据
  late Rx<Future<List<dynamic>>> futurePlayLists;
  // 判断加载的数据是新数据还是老数据
  late bool isLoadNewData;
  // 专辑列表数据
  late RxList<dynamic> playListsData;

  ExploreState() {
    playlistCategories = playlistCategoriesStaticData;
    selectedCategory = "全部".obs;
    lastSelectedCategory = "全部".obs;
    playlistCategoriesTile = ["语种", "风格", "场景", "情感", "主题"];
    playlistCategoriesWidgetInfo = {};
    loginStatus = false.obs;
    isLoadNewData = false;
    playListsData = [].obs;
  }
}
