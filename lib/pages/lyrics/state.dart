import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LyricsState {
  // 音乐id
  late RxInt musicId;
  // 歌曲信息
  late RxMap songInfo;
  // 歌词进度
  late RxDouble lyricsProgress;
  // 歌词滚动控制器
  late ItemScrollController  itemScrollController;
  late ScrollOffsetController scrollOffsetController;
  // 歌词
  late RxList lyrics;
  // 歌词对应时间
  late RxList lyricsTime;
  // 音乐url
  late RxString musicUrl;

  // 定时器
  late Timer timer;

  LyricsState() {
    musicId = 29207681.obs;
    songInfo = {}.obs;
    lyricsProgress = 0.0.obs;
    itemScrollController = ItemScrollController ();
    scrollOffsetController = ScrollOffsetController ();
    lyrics = [].obs;
    lyricsTime = [].obs;
    musicUrl = "".obs;
  }
}
