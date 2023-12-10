import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MusicLibraryState {
  // 登录状态
  late RxBool loginStatus;
  // 用户头像
  late RxString userImgUrl;
  // 用户信息
  late RxMap userInfo;
  // 我喜欢的歌曲
  late RxList likeSongs;
  // 用户歌单
  late RxList userPlayList;
  // 用户收藏的专辑
  late RxList userLikedAlbums;
  // 用户收藏的艺人
  late RxList userLikedArtists;
  // 用户收藏的MV
  late RxList userLikedMVs;
  // 用户云盘歌曲信息
  late RxList userCloudDiskSongs;
  // 用户听歌排行信息
  late RxList userHistorySongsRank;

  // 随机歌词
  late RxString randomLyric;

  // 滑动页面控制器
  late ScrollController pageController;
  // TabBar导航栏标题
  late RxList<String> tabBarTitles;
  // 当前选择的标签
  late RxInt currentTabBarIndex;
  // 当前用户排行信息选择的标签
  late RxInt currentUserHistorySongsRank;


  MusicLibraryState() {
    loginStatus = false.obs;
    userImgUrl = "".obs;
    userInfo = {}.obs;
    likeSongs = [].obs;
    pageController = ScrollController();
    tabBarTitles = ["全部歌单", "专辑", "艺人", "MV", "云盘", "听歌排行"].obs;
    currentTabBarIndex = 0.obs;
    userPlayList = [].obs;
    userLikedAlbums = [].obs;
    userLikedArtists = [].obs;
    userLikedMVs = [].obs;
    randomLyric = "".obs;
    userCloudDiskSongs = [].obs;
    userHistorySongsRank = [].obs;
    currentUserHistorySongsRank = 0.obs;
  }
}
