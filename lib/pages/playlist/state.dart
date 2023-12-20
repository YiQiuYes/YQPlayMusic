import 'package:get/get.dart';

class PlaylistState {
  // 传入来的id
  late String id;
  // 歌单信息
  late Rx<Future<Map<String, dynamic>>> futurePlayListInfo;
  // by apple music 歌单id
  late List<String> byAppleMusicIds;

  PlaylistState() {
    byAppleMusicIds = ["5277771961", "5277965913", "5277969451", "5277778542", "5278068783"];
  }
}
