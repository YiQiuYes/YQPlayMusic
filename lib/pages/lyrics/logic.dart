import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/api/track.dart';
import 'package:yqplaymusic/common/utils/Player.dart';

import 'state.dart';
import 'dart:developer' as developer;

class LyricsLogic extends GetxController {
  final LyricsState state = LyricsState();

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
    if (type == "background" && state.songInfo.isNotEmpty) {
      return state.songInfo["songs"][0]["al"]["picUrl"] + "?param=512y512";
    } else if (type == "cover" && state.songInfo.isNotEmpty) {
      return state.songInfo["songs"][0]["al"]["picUrl"] + "?param=1024y1024";
    } else {
      return "https://p2.music.126.net/VnZiScyynLG7atLIZ2YPkw==/18686200114669622.jpg?param=512y512";
    }
  }

  // 获取歌曲名字
  String getSongName() {
    if (state.songInfo.isNotEmpty) {
      return state.songInfo["songs"][0]["name"];
    } else {
      return "";
    }
  }

  // 获取歌手名字
  String getArtistName() {
    if (state.songInfo.isNotEmpty) {
      return state.songInfo["songs"][0]["ar"][0]["name"];
    } else {
      return "";
    }
  }

  // 获取专辑名称
  String getAlbumName() {
    if (state.songInfo.isNotEmpty) {
      return state.songInfo["songs"][0]["al"]["name"];
    } else {
      return "";
    }
  }

  // 获取歌曲播放时间大小
  String getSongDuration() {
    if (state.songInfo.isNotEmpty) {
      double dt = state.songInfo["songs"][0]["dt"] / 1000;
      if (dt == 0) return "";
      return "${dt ~/ 60}:${(dt % 60).truncate()}";
    } else {
      return "0:00";
    }
  }

  // 获取歌词
  void getSongLyrics() {
    if (state.songInfo.isNotEmpty) {
      trackManager.getLyric(id: state.musicId.value.toString()).then((value) {
        var res = value.data is String ? jsonDecode(value.data) : value.data;
        List<String> lyrics = res["lrc"]["lyric"].split("\n");

        List lyricResult = lyrics.map((e) {
          return e.split("]").last;
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

        if (lyricResult.last == "") {
          lyricResult.removeLast();
          timeResult.removeLast();
        }

        state.lyrics.value = lyricResult;
        state.lyricsTime.value = timeResult;
        // developer.log(lyricResult.length.toString());
        // developer.log(timeResult.length.toString());
      });
    }
  }

  // 获取音乐url
  void getMusicUrl() {
    if (state.songInfo.isNotEmpty) {
      trackManager
          .getMusicUrl(id: state.musicId.value.toString())
          .then((value) {
        // print(value);
        var res = value.data is String ? jsonDecode(value.data) : value.data;
        String url = res["data"][0]["url"];
        state.musicUrl.value = url.replaceAll("http:", "https:");
        player.audioPlayer.play(UrlSource(state.musicUrl.value));
      });
    }
  }

  // 开启歌曲进度定时器
  void startTimerMusicPrecess() {
    state.timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        state.lyricsProgress.value = player.duration.value == 0
            ? 0
            : player.position.value / player.duration.value;
      },
    );
  }
}
