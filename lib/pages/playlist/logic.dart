import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/api/playlist.dart';
import 'package:yqplaymusic/api/track.dart';
import '../../common/utils/EventBusDistribute.dart';
import '../../common/utils/ShareData.dart';
import '../../common/utils/SongInfoUtils.dart';
import 'state.dart';

class PlaylistLogic extends GetxController {
  final PlaylistState state = PlaylistState();

  void initPage(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    state.id = arguments["id"].toString();
    state.futurePlayListInfo = getPlaylistInfo().obs;
  }

  // 获取专辑网络数据
  Future<Map<String, dynamic>> getPlaylistInfo() {
    return playListManager
        .getPlaylistDetail(id: int.parse(state.id))
        .then((value) async {
      var firstResult = value.data is String ? jsonDecode(value.data) : value.data;
      // 如果还有更多歌曲
      if (firstResult["playlist"]["trackCount"] > firstResult["playlist"]["tracks"].length) {
        List trackIDs = firstResult["playlist"]["trackIds"];
        trackIDs = trackIDs.map((e) => e["id"]).toList();
        // 请求数据
        await trackManager.getMusicDetail(ids: trackIDs).then((value) {
          var secondResult = value.data is String ? jsonDecode(value.data) : value.data;
          firstResult["playlist"]["tracks"] = secondResult["songs"];
        });
      }

      return firstResult;
    });
  }

  // 获取歌单创建者
  String getPlaylistCreator(String id, Map<String, dynamic> playlistInfo) {
    if (state.byAppleMusicIds.contains(id)) {
      return "Apple Music";
    } else {
      return playlistInfo["playlist"]["creator"]["nickname"];
    }
  }

  // 获取歌单最后更新时间和歌曲数量
  String getDataTimeAndSongCount(Map<String, dynamic> playlistInfo) {
    var updateTime = DateTime.fromMillisecondsSinceEpoch(
        playlistInfo["playlist"]["updateTime"]);
    var songCount = playlistInfo["playlist"]["trackCount"];
    return "最后更新于${updateTime.year}年${updateTime.month}月${updateTime.day}日更新•$songCount首歌";
  }

  // 播放按钮逻辑
  void playButtonLogic() {
    // 播放逻辑
    state.futurePlayListInfo.value.then((value) {
      if (value.isEmpty) return;
      List list = value["playlist"]["tracks"];
      EventBusManager.eventBus.fire(ShareData(
        musicID: list[0]["id"].toString(),
        isPlaying: true,
        playAndPause: true,
        songIDs: SongInfoUtils().getMapSongIDs(list),
      ));
    });
  }
}
