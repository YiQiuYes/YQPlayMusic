import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;
import '../common/utils/screenadaptor.dart';

class TrackListItem extends StatelessWidget {
  const TrackListItem(
      {super.key,
      required this.track,
      required this.subTitleAndArtistPaddingLeft,
      required this.subTitleAndArtistPaddingRight,
      required this.artistPaddingTop,
      required this.subTitleFontSize,
      required this.artistFontSize,
      this.isShowSongAlbumNameAndTimes = false,
      this.albumNamePaddingLeft,
      this.albumNamePaddingRight,
      this.albumNamePaddingTop,
      this.albumNameFontSize,
      this.timeFontSize,
      this.timePaddingTop,
      this.isShowCount = false,
      this.playCount = "0",
      this.countPaddingTop,
      this.countFontSize});

  final Map track;
  // 歌曲标题和歌手边距
  final List<double> subTitleAndArtistPaddingLeft;
  final List<double> subTitleAndArtistPaddingRight;
  final List<double> artistPaddingTop;
  // 歌曲标题和歌手字体大小
  final List<double> subTitleFontSize;
  final List<double> artistFontSize;

  // 是否显示歌曲的专辑和歌曲时间信息
  final bool isShowSongAlbumNameAndTimes;
  // 专辑名字位置
  final List<double>? albumNamePaddingTop;
  final List<double>? albumNamePaddingLeft;
  final List<double>? albumNamePaddingRight;
  final List<double>? timePaddingTop;
  // 字体大小
  final List<double>? albumNameFontSize;
  final List<double>? timeFontSize;

  // 是否显示听歌次数
  final bool isShowCount;
  final String playCount;
  final List<double>? countPaddingTop;
  // 字体大小
  final List<double>? countFontSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 图片
        Positioned(
          top: screenAdaptor.getLengthByOrientation(8.w, 5.w),
          left: screenAdaptor.getLengthByOrientation(8.w, 5.w),
          bottom: screenAdaptor.getLengthByOrientation(8.w, 5.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                screenAdaptor.getLengthByOrientation(8.w, 5.w)),
            child: CachedNetworkImage(
              imageUrl: getImageUrl(track),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // 歌曲标题
        Positioned(
          top: screenAdaptor.getLengthByOrientation(8.w, 5.w),
          left: screenAdaptor.getLengthByOrientation(
              subTitleAndArtistPaddingLeft[0], subTitleAndArtistPaddingLeft[1]),
          right: screenAdaptor.getLengthByOrientation(
              subTitleAndArtistPaddingRight[0],
              subTitleAndArtistPaddingRight[1]),
          child: Text.rich(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            TextSpan(
              style: TextStyle(
                fontSize: screenAdaptor.getLengthByOrientation(
                    subTitleFontSize[0], subTitleFontSize[1]),
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(text: track["name"]),
                TextSpan(
                  text: getSuTitle(track),
                  style: const TextStyle(
                    color: Colors.black38,
                  ),
                )
              ],
            ),
          ),
        ),
        // 歌手
        Positioned(
          top: screenAdaptor.getLengthByOrientation(
              artistPaddingTop[0], artistPaddingTop[1]),
          left: screenAdaptor.getLengthByOrientation(
              subTitleAndArtistPaddingLeft[0], subTitleAndArtistPaddingLeft[1]),
          right: screenAdaptor.getLengthByOrientation(
              subTitleAndArtistPaddingRight[0],
              subTitleAndArtistPaddingRight[1]),
          child: Text(
            getArtists(track),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: screenAdaptor.getLengthByOrientation(
                  artistFontSize[0], artistFontSize[1]),
              color: Colors.grey,
            ),
          ),
        ),
        // 显示时间
        Visibility(
          visible: isShowSongAlbumNameAndTimes,
          child: Positioned(
            top: screenAdaptor.getLengthByOrientation(
                albumNamePaddingTop?[0] ?? 0, albumNamePaddingTop?[1] ?? 0),
            left: screenAdaptor.getLengthByOrientation(
                albumNamePaddingLeft?[0] ?? 0, albumNamePaddingLeft?[1] ?? 0),
            right: screenAdaptor.getLengthByOrientation(
                albumNamePaddingRight?[0] ?? 0, albumNamePaddingRight?[1] ?? 0),
            child: Text(
              getAlbumName(track),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: screenAdaptor.getLengthByOrientation(
                    albumNameFontSize?[0] ?? 17.sp,
                    albumNameFontSize?[1] ?? 12.sp),
                color: const Color.fromRGBO(0, 0, 0, 0.8),
              ),
            ),
          ),
        ),
        // 显示时间
        Visibility(
          visible: isShowSongAlbumNameAndTimes,
          child: Positioned(
            right: 0,
            top: screenAdaptor.getLengthByOrientation(
                timePaddingTop?[0] ?? 0, timePaddingTop?[1] ?? 0),
            child: Text(
              getSongTime(track),
              style: TextStyle(
                color: const Color.fromRGBO(0, 0, 0, 0.8),
                fontSize: screenAdaptor.getLengthByOrientation(
                    timeFontSize?[0] ?? 17.sp, timeFontSize?[1] ?? 12.sp),
              ),
            ),
          ),
        ),
        // 显示听歌次数
        Visibility(
          visible: isShowCount,
          child: Positioned(
            right: screenAdaptor.getLengthByOrientation(25.w, 12.w),
            top: screenAdaptor.getLengthByOrientation(
                countPaddingTop?[0] ?? 0, countPaddingTop?[1] ?? 0),
            child: Text(
              playCount,
              style: TextStyle(
                color: const Color.fromRGBO(0, 0, 0, 0.8),
                fontSize: screenAdaptor.getLengthByOrientation(
                    countFontSize?[0] ?? 17.sp, countFontSize?[1] ?? 12.sp),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 获取歌曲标题信息
  String getSuTitle(Map item) {
    String tn = "";
    if (item["tns"] != null &&
        item["tns"].isNotEmpty &&
        item["name"] != item["tns"][0]) {
      tn = item["tns"][0];
    }

    String alia = "";
    if (item["alia"] != null) {
      alia = item["alia"].isNotEmpty ? item["alia"][0] : "";
    } else {
      alia = "";
    }

    // 优先显示alia
    if (tn != "" || alia != "") {
      if (alia != "") {
        return "（$alia）";
      } else {
        return "（$tn）";
      }
    } else {
      return tn;
    }
  }

  // 获取图片链接
  String getImageUrl(Map item) {
    String imageUrl = item["al"]?["picUrl"] ??
        item["album"]?["picUrl"] ??
        "https://p2.music.126.net/UeTuwE7pvjBpypWLudqukA==/3132508627578625.jpg";

    return "$imageUrl?param=224y224";
  }

  // 获取歌手信息
  String getArtists(Map item) {
    if (item["ar"] != null) {
      if (item["ar"].isNotEmpty) {
        String name = item["ar"].map((e) => e["name"]).join(", ");
        if(name == "null") return "";
        return name;
      }
    } else if (item["artists"] != null) {
      if (item["artists"].isNotEmpty) {
        String name = item["artists"].map((e) => e["name"]).join(", ");
        if(name == "null") return "";
        return name;
      }
    }
    return "";
  }

  // 获取专辑名字
  String getAlbumName(Map item) {
    if (item["album"] != null) {
      return item["album"]["name"] ?? "";
    } else if (item["al"] != null) {
      return item["al"]["name"] ?? "";
    }
    return "";
  }

  // 获取歌曲时间
  String getSongTime(Map item) {
    // 歌曲时间
    double dt = item["dt"] / 1000;
    if(dt == 0) return "";
    return "${dt ~/ 60}:${(dt % 60).truncate()}";
  }
}
