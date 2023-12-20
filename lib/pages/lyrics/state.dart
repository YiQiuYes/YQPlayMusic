import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:yqplaymusic/common/utils/DataSaveManager.dart';
import 'package:yqplaymusic/common/utils/Player.dart';

class LyricsState {
  // 音乐id
  late RxInt musicId;
  // 歌曲信息
  late RxMap songInfo;
  // 歌词进度条进度
  late RxDouble lyricsProgress;
  // 歌曲播放进度条进度无阻挡
  late RxDouble lyricsProgressNoBlock;
  // 歌曲进度微秒
  late RxInt musicProcessPosition;
  // 歌曲总时长
  late RxInt musicDuration;


  // 歌词滚动的位置
  late RxInt lyricsScrollPosition;
  // 用户是否在滑动歌词
  late bool isUserScrollLyrics;
  // 歌词滚动控制器
  late ItemScrollController  itemScrollController;
  late ScrollOffsetController scrollOffsetController;
  // 歌词
  late RxList lyrics;
  // 歌词对应时间
  late RxList lyricsTime;
  // 5秒歌词归位定时器
  Timer? lyricsTimer;

  // 音乐url
  late RxString musicUrl;
  // 进度条是否开始拖动
  late bool isStartDrag = false;
  // 是否处于播放状态
  late RxBool isPlaying;
  // 数据共享监听器
  late StreamSubscription streamSubscription;

  LyricsState() {
    musicId = int.parse(player.musicId).obs;
    songInfo = {}.obs;
    lyricsProgress = 0.0.obs;
    lyricsProgressNoBlock = 0.0.obs;
    itemScrollController = ItemScrollController ();
    scrollOffsetController = ScrollOffsetController ();
    lyrics = [].obs;
    lyricsTime = [].obs;
    musicUrl = "".obs;
    musicProcessPosition = 0.obs;
    lyricsScrollPosition = 0.obs;
    isUserScrollLyrics = false;
    isPlaying = false.obs;
    musicDuration = 0.obs;
  }
}
