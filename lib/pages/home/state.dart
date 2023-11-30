import 'dart:async';
import 'package:get/get.dart';

class HomeState {

  // 登录状态
  late RxBool loginStatus;
  late Rx<Future<List<dynamic>>> recommendList;

  // 每日推荐歌曲
  late Rx<Future<List<dynamic>>> dailyTracksList;
  // 私人FM数据
  late Rx<Future<List<dynamic>>> personalFMList;
  // 推荐艺人数据
  late Rx<Future<List<dynamic>>> recommendArtistList;
  // 新碟上架数据
  late Rx<Future<List<dynamic>>> newAlbumsList;
  // 排行榜数据
  late Rx<Future<List<dynamic>>> topList;
  // 排行榜过滤器id数组
  late List<int> topListIds;


  HomeState() {
    /// 初始化变量
    loginStatus = false.obs;
    topListIds = [19723756, 180106, 60198, 3812895, 60131];
  }
}
