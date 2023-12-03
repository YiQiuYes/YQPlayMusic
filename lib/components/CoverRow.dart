import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yqplaymusic/common/utils/screenadaptor.dart';
import 'package:yqplaymusic/components/Cover.dart';

class CoverRow extends StatelessWidget {
  const CoverRow(
      {Key? key,
      required this.items,
      this.subText,
      this.type,
      this.showPlayCount = false})
      : super(key: key);

  // 专辑数据
  final List<dynamic> items;
  // 专辑副标题
  final String? subText;
  // 专辑类型
  final String? type;
  // 是否显示播放数据
  final bool showPlayCount;

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
      return item["copywriter"];
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
    if(playCount == null) return "";

    if(playCount > 100000000) {
      return " ${(playCount / 100000000).toStringAsFixed(2)}亿";
    } else if (playCount > 10000) {
      return " ${(playCount / 10000).toStringAsFixed(1)}万";
    } else {
      return playCount.toString();
    }
  }

  List<Widget> _buildPlayListItems() {
    List<Widget> widgets = [];

    for (var item in items) {
      widgets.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Cover(
              width: screenAdaptor.getLengthByOrientation(170.w, 110.w),
              height: screenAdaptor.getLengthByOrientation(170.w, 110.w),
              imageUrl: getImageUrl(item),
              id: item["id"],
            ),
            SizedBox(
              height: screenAdaptor.getLengthByOrientation(10.w, 10.w),
            ),
            // 播放量
            Visibility(
              visible: showPlayCount && getPlayCountText(item["playCount"]) != "",
              child: Column(
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
                        getPlayCountText(item["playCount"])!,
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
            SizedBox(
              width: screenAdaptor.getLengthByOrientation(170.w, 110.w),
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
            SizedBox(
              width: screenAdaptor.getLengthByOrientation(170.w, 110.w),
              child: Text(
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
            )
          ],
        ),
      );

      // 添加间距
      widgets.add(
        SizedBox(
          width: screenAdaptor.getLengthByOrientation(25.w, 19.5.w),
        ),
      );
    }

    // 移除最后一个间距
    widgets.removeLast();
    return widgets;
  }

  List<Widget> _buildArtistItems() {
    List<Widget> widgets = [];

    for (var item in items) {
      widgets.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                screenAdaptor.getLengthByOrientation(85.w, 48.w),
              ),
              child: Cover(
                width: screenAdaptor.getLengthByOrientation(160.w, 92.w),
                height: screenAdaptor.getLengthByOrientation(160.w, 92.w),
                imageUrl: getImageUrl(item),
                id: item["id"],
              ),
            ),
            SizedBox(
              height: screenAdaptor.getLengthByOrientation(10.w, 10.w),
            ),
            SizedBox(
              width: screenAdaptor.getLengthByOrientation(160.w, 92.w),
              child: Center(
                child: Text(
                  item["name"],
                  // 最多两行
                  maxLines: 2,
                  // 去除溢出
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize:
                        screenAdaptor.getLengthByOrientation(15.sp, 10.sp),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: screenAdaptor.getLengthByOrientation(160.w, 92.w),
              child: Text(
                getSubText(item),
                // 去除溢出
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: screenAdaptor.getLengthByOrientation(12.sp, 8.sp),
                  color: Colors.black45,
                ),
              ),
            )
          ],
        ),
      );

      // 添加间距
      widgets.add(
        SizedBox(
          width: screenAdaptor.getLengthByOrientation(25.w, 14.5.w),
        ),
      );
    }

    // 移除最后一个间距
    widgets.removeLast();
    return widgets;
  }

  List<Widget> _switchBuildItems() {
    switch (type) {
      case "playlist":
        return _buildPlayListItems();
      case "artist":
        return _buildArtistItems();
      case "album":
        return _buildPlayListItems();
      case "updateFrequency":
        return _buildPlayListItems();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _switchBuildItems(),
    );
  }
}
