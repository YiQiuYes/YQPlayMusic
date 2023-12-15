import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yqplaymusic/common/utils/screenadaptor.dart';
import 'package:yqplaymusic/components/Cover.dart';

class CoverRow extends StatelessWidget {
  const CoverRow(
      {Key? key,
      required this.items,
      this.subText,
      this.type,
      this.showPlayCount = false,
      this.columnCount = 5})
      : super(key: key);

  // 专辑数据
  final List<dynamic> items;
  // 专辑副标题
  final String? subText;
  // 专辑类型
  final String? type;
  // 是否显示播放数据
  final bool showPlayCount;
  // 列数
  final int columnCount;

  // 获取副标题
  String getSubText(item) {
    if (subText == "appleMusic") {
      return "by Apple Music";
    } else if (subText == "artist") {
      if (item["artist"] != null) {
        return item["artist"]["name"];
      }

      if (item["artists"] != null) {
        return item["artists"][0]["name"];
      }
    } else if (subText == "updateFrequency") {
      return item["updateFrequency"];
    } else if (subText == "copywriter") {
      return item["copywriter"] ?? "";
    } else if (subText == "creator") {
      return "by ${item["creator"]["nickname"]}";
    }
    return "";
  }

  // 获取图片链接
  String getImageUrl(Map<String, dynamic> item) {
    if (item["img1v1Url"] != null) {
      var img1v1ID = item["img1v1Url"].split('/');
      img1v1ID = img1v1ID[img1v1ID.length - 1];

      if (img1v1ID == "5639395138885805.jpg") {
        // 没有头像的歌手，网易云返回的img1v1Url并不是正方形的 😅😅😅
        return "https://p2.music.126.net/VnZiScyynLG7atLIZ2YPkw==/18686200114669622.jpg?param=512y512";
      }

      return item["img1v1Url"] + "?param=512y512";
    }

    if (item["picUrl"] != null) {
      return item["picUrl"] + "?param=512y512";
    }

    return item["coverImgUrl"] + "?param=512y512";
  }

  // 获取播放数量文本
  String getPlayCountText(var playCount) {
    if (playCount == null) return "";

    if (playCount > 100000000) {
      return " ${(playCount / 100000000).toStringAsFixed(2)}亿";
    } else if (playCount > 10000) {
      return " ${(playCount / 10000).toStringAsFixed(1)}万";
    } else {
      return " ${playCount.toString()}";
    }
  }

  List<Widget> _buildArtistItems(List<dynamic> items) {
    List<Widget> widgets = [];
    for (var item in items) {
      List<Widget> columnWidgets = [
        ClipOval(
          child: Cover(
            imageUrl: getImageUrl(item),
            id: item["id"],
          ),
        ),
        SizedBox(
          height: screenAdaptor.getLengthByOrientation(10.w, 10.w),
        ),
        Center(
          child: Text(
            item["name"],
            // 最多两行
            maxLines: 2,
            // 去除溢出
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: screenAdaptor.getLengthByOrientation(15.sp, 10.sp),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          getSubText(item),
          // 去除溢出
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: screenAdaptor.getLengthByOrientation(12.sp, 8.sp),
            color: Colors.black45,
          ),
        ),
      ];
      widgets.add(
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: columnWidgets.length,
          itemBuilder: (BuildContext context, int index) {
            return columnWidgets[index];
          },
        ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: columnWidgets,
        // ),
      );
    }

    return widgets;
  }

  List<Widget> _buildPlayListItems(List<dynamic> items) {
    List<Widget> widgets = [];
    for (var item in items) {
      List<Widget> columnWidgets = [
        ClipRRect(
          borderRadius: BorderRadius.circular(
              screenAdaptor.getLengthByOrientation(14.w, 8.w)),
          child: Cover(
            id: item["id"],
            imageUrl: getImageUrl(item),
          ),
        ),
        SizedBox(
          height: screenAdaptor.getLengthByOrientation(10.w, 10.w),
        ),
        // 播放量
        Visibility(
          visible: showPlayCount && getPlayCountText(item["playCount"]) != "",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    "lib/assets/icons/play.svg",
                    width: screenAdaptor.getLengthByOrientation(11.w, 7.w),
                    height: screenAdaptor.getLengthByOrientation(11.w, 7.w),
                    color: Colors.black26,
                  ),
                  // 播放量数量文本
                  Text(
                    getPlayCountText(item["playCount"]),
                    style: TextStyle(
                      fontSize:
                          screenAdaptor.getLengthByOrientation(12.sp, 8.sp),
                      color: Colors.black26,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenAdaptor.getLengthByOrientation(5.w, 5.w),
              ),
            ],
          ),
        ),
        // 专辑文本
        Text(
          item["name"],
          // 最多两行
          maxLines: 2,
          // 去除溢出
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: screenAdaptor.getLengthByOrientation(15.sp, 10.sp),
            fontWeight: FontWeight.bold,
          ),
        ),
        // 副标题文本
        Text(
          getSubText(item),
          // 去除溢出
          overflow: TextOverflow.ellipsis,
          // 最多两行
          maxLines: 2,
          style: TextStyle(
            fontSize: screenAdaptor.getLengthByOrientation(12.sp, 8.sp),
            color: Colors.black45,
          ),
        ),
      ];
      widgets.add(
        ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return columnWidgets[index];
          },
          itemCount: columnWidgets.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      );
    }
    return widgets;
  }

  List<Widget> _switchBuildItems(List<dynamic> items) {
    switch (type) {
      case "playlist":
        return _buildPlayListItems(items);
      case "artist":
        return _buildArtistItems(items);
      case "album":
        return _buildPlayListItems(items);
      case "updateFrequency":
        return _buildPlayListItems(items);
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAlignedGrid.count(
      crossAxisCount: columnCount,
      crossAxisSpacing: screenAdaptor.getLengthByOrientation(25.w, 15.w),
      itemCount: _switchBuildItems(items).length,
      itemBuilder: (BuildContext context, int index) {
        return _switchBuildItems(items)[index];
      },
    );
  }
}
