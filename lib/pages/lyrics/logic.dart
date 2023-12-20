import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yqplaymusic/api/track.dart';
import 'package:yqplaymusic/common/utils/Player.dart';

import '../../common/utils/DataSaveManager.dart';
import '../../common/utils/EventBusDistribute.dart';
import '../../common/utils/ShareData.dart';
import '../../common/utils/screenadaptor.dart';
import 'state.dart';
import 'dart:developer' as developer;

class LyricsLogic extends GetxController {
  final LyricsState state = LyricsState();

  // 第一次初始化读取musicID和获取网络数据
  void initPage() {
    DataSaveManager.getLocalStorage("musicID").then((value) async {
      if (value != null) {
        state.musicId.value = int.parse(value);
      }
      // 获取歌曲信息
      getSongInfo();
    });
  }

  // 获取歌曲信息
  void getSongInfo() {
    trackManager.getMusicDetail(ids: [state.musicId.value]).then((value) {
      state.songInfo.value =
          value.data is String ? jsonDecode(value.data) : value.data;
      // 获取歌词
      getSongLyrics();
    });
  }

  // 获取歌曲图片
  String getSongImageUrl({required String type}) {
    if (type == "background" &&
        state.songInfo.isNotEmpty &&
        state.songInfo["songs"].isNotEmpty) {
      return state.songInfo["songs"][0]["al"]["picUrl"] + "?param=512y512";
    } else if (type == "cover" &&
        state.songInfo.isNotEmpty &&
        state.songInfo["songs"].isNotEmpty) {
      return state.songInfo["songs"][0]["al"]["picUrl"] + "?param=1024y1024";
    } else {
      return "https://p2.music.126.net/VnZiScyynLG7atLIZ2YPkw==/18686200114669622.jpg?param=1024y1024";
    }
  }

  // 获取歌曲名字
  String getSongName() {
    if (state.songInfo.isNotEmpty && state.songInfo["songs"].isNotEmpty) {
      return state.songInfo["songs"][0]["name"];
    } else {
      return "";
    }
  }

  // 获取歌手名字
  String getArtistName() {
    // developer.log(state.songInfo.toString(), stackTrace: StackTrace.current);
    if (state.songInfo.isNotEmpty && state.songInfo["songs"].isNotEmpty) {
      return state.songInfo["songs"][0]["ar"][0]["name"] ?? "";
    } else {
      return "";
    }
  }

  // 获取专辑名称
  String getAlbumName() {
    if (state.songInfo.isNotEmpty && state.songInfo["songs"].isNotEmpty) {
      return state.songInfo["songs"][0]["al"]["name"] ?? "";
    } else {
      return "";
    }
  }

  // 获取歌曲播放时间大小
  String getSongDuration() {
    if (state.songInfo.isNotEmpty) {
      double dt = state.musicDuration.value / 1000;
      if (dt == 0) return "0:00";
      // 获取秒
      int second = (dt % 60).truncate();
      return "${dt ~/ 60}:${second < 10 ? "0$second" : second}";
    } else {
      return "0:00";
    }
  }

  // 获取播放进度文本
  String getSongProgressText() {
    if (state.songInfo.isNotEmpty) {
      double dt = state.musicProcessPosition.value / 1000;
      // 获取秒
      int second = (dt % 60).truncate();
      return "${dt ~/ 60}:${second < 10 ? "0$second" : second}";
    } else {
      return "0:00";
    }
  }

  // 获取歌词
  void getSongLyrics() {
    if (state.songInfo.isNotEmpty && state.songInfo["songs"].isNotEmpty) {
      trackManager.getLyric(id: state.musicId.value.toString()).then((value) {
        var res = value.data is String ? jsonDecode(value.data) : value.data;
        List<String> lyrics = res["lrc"]?["lyric"].split("\n") ?? [];
        List lyricResult = lyrics.map((e) {
          String lyricLine = e.split("]").last;
          // if (lyricLine.contains("作词") ||
          //     lyricLine.contains("作曲") ||
          //     lyricLine.contains("编曲")) {
          // 去除字符前的空格
          lyricLine = lyricLine.replaceAll(RegExp(r'^\s+'), "");
          //}
          return lyricLine;
        }).toList();

        List timeResult = lyrics.map((e) {
          String time = e.split("]").first.replaceAll("[", "");
          int dt = -1;
          if (time.isNotEmpty && time.split(":").first == "00") {
            dt = (double.parse(time.split(":").last) * 1000).toInt();
          } else if (time.isNotEmpty) {
            RegExp regex = RegExp(r'^\d{0,1}0+');
            String regexTime = time.replaceAll(regex, "");
            dt = (int.parse(regexTime.split(":").first) * 60 * 1000 +
                    double.parse(time.split(":").last) * 1000)
                .toInt();
          }
          return dt;
        }).toList();

        if (lyricResult.isNotEmpty && lyricResult.last == "") {
          lyricResult.removeLast();
          timeResult.removeLast();
        }

        state.lyricsTime.value = timeResult;
        state.lyrics.value = lyricResult;
        // developer.log(lyricResult.length.toString());
        // developer.log(timeResult.length.toString());
        //state.lyricsScrollPosition.value = 0;
      });
    }
  }

  // 开启歌曲进度定时器
  void listenMusicPrecess() {
    player.setCurrentPositionCb(() {
      double result =
          (player.duration == 0 ? 0 : player.position / player.duration);
      // 获取歌曲进度
      state.musicProcessPosition.value = player.position;

      // 获取歌曲总时长
      if (state.musicDuration.value != player.duration) {
        state.musicDuration.value = player.duration;
      }

      // 获取进度条进度
      if (result > 1.0 && !state.isStartDrag) {
        state.lyricsProgress.value = 1.0;
        state.lyricsProgressNoBlock.value = 1.0;
      } else if (!state.isStartDrag) {
        state.lyricsProgress.value = result;
        state.lyricsProgressNoBlock.value = result;
      } else if (result > 1.0) {
        state.lyricsProgressNoBlock.value = 1.0;
      } else {
        state.lyricsProgressNoBlock.value = result;
      }
    });
  }

  // 歌词页面滚动
  void lyricsWidgetScroll() {
    state.itemScrollController.scrollTo(
      index: state.lyricsScrollPosition.value,
      duration: const Duration(milliseconds: 300),
      alignment: screenAdaptor.getLengthByOrientation(0.47, 0.35),
    );
  }

  // 歌词刚开始触摸滑动逻辑
  void handleLyricsStartDrag(PointerDownEvent pointerDownEvent) {
    //if (player.audioPlayer.playing) {
      state.isUserScrollLyrics = true;
      // 取消定时器
      state.lyricsTimer?.cancel();
    //}
  }

  // 歌词结束滑动逻辑
  void handleLyricsEndDrag(PointerUpEvent pointerUpEvent) {
    // 结束滚动 5s后歌词归位
    state.lyricsTimer = Timer(const Duration(seconds: 4), () {
      state.isUserScrollLyrics = false;
      if(player.audioPlayer.playing) {
        // 歌词页面滚动
        lyricsWidgetScroll();
      }
    });
  }

  // 处理歌词滚动
  void handleLyricsScroll() {
    if (state.lyricsTime.isNotEmpty && state.lyrics.isNotEmpty) {
      if(player.position < state.lyricsTime.first && player.position < state.lyricsTime.last) {
        if (!state.isUserScrollLyrics && state.lyricsScrollPosition.value != 0) {
          state.lyricsScrollPosition.value = 0;
          // 歌词页面滚动
          lyricsWidgetScroll();
        }
        return;
      }

      // 查看循环有无break
      bool flag = true;
      for (int i = 0; i < state.lyricsTime.length - 1; i++) {
        if (player.position >= state.lyricsTime[i] &&
            player.position < state.lyricsTime[i + 1]) {
          flag = false;
          // 如果是同一位置
          if (state.lyricsScrollPosition.value == i) {
            break;
          }

          state.lyricsScrollPosition.value = i;
          // 界面滚动
          if (!state.isUserScrollLyrics) {
            // 歌词页面滚动
            lyricsWidgetScroll();
          }
          break;
        }
      }

      // 如果是最后一个
      if (flag) {
        if (state.lyricsScrollPosition.value == state.lyricsTime.length - 1) {
          return;
        }

        state.lyricsScrollPosition.value = state.lyricsTime.length - 1;
        // 界面滚动
        if (!state.isUserScrollLyrics) {
          // 歌词页面滚动
          lyricsWidgetScroll();
        }
      }
    }
  }

  // 进度条开始拖动逻辑
  void startMusicProcessDrag(double value) {
    state.isStartDrag = true;
  }

  // 进度条结束拖动逻辑
  void endMusicProcessDrag(double value) {
    state.lyricsProgress.value = value;
    player.audioPlayer.seek(Duration(
        milliseconds: (state.lyricsProgress.value * player.duration).toInt()));
    state.isStartDrag = false;
  }

  // 播放按钮逻辑
  void handlePlayBtn() {
    if (state.isPlaying.value) {
      EventBusManager.eventBus.fire(ShareData(playAndPause: false));
    } else {
      EventBusManager.eventBus.fire(ShareData(playAndPause: true));
    }
    state.isPlaying.value = !state.isPlaying.value;
  }

  // 上一首按钮逻辑
  void handlePreBtn() {
    EventBusManager.eventBus.fire(ShareData(previous: true));
  }

  // 下一首按钮逻辑
  void handleNextBtn() {
    EventBusManager.eventBus.fire(ShareData(next: true));
  }

  // 刷新数据
  void refreshData() {
    getSongInfo();
  }

  // 数据监听处理
  void handleDataListener() {
    state.streamSubscription =
        EventBusManager.eventBus.on<ShareData>().listen((event) {
      if (event.mapData["musicID"] != null) {
        state.musicId.value = int.parse(event.mapData["musicID"]);
        // 刷新数据
        refreshData();
      }

      // if (event.mapData["isPlaying"] != null) {
      //   if (event.mapData["isPlaying"]) {
      //     state.lyricsScrollPosition.value = 0;
      //   }
      // }

      if (event.mapData["playAndPause"] != null) {
        state.isPlaying.value = event.mapData["playAndPause"];
      }
    });
  }
}
