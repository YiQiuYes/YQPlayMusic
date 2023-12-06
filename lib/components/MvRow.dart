import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../common/utils/screenadaptor.dart';
import 'dart:developer' as developer;

class MvRow extends StatelessWidget {
  const MvRow({super.key, this.columnCount = 5, required this.items});

  // 列数
  final int columnCount;
  // 网络数据
  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    return SliverAlignedGrid.count(
      crossAxisCount: columnCount,
      crossAxisSpacing: screenAdaptor.getLengthByOrientation(25.w, 15.w),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return _getMvItems(items[index]);
      },
    );
  }

  String getImageUrl(item) {
    String url = item["imgurl16v9"] ?? item["cover"] ?? item["coverUrl"];
    return item["coverUrl"] + "?param=464y260";
  }

  Widget _getMvItems(Map item) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(screenAdaptor.getLengthByOrientation(14.w, 8.w)),
          child: CachedNetworkImage(
            imageUrl: getImageUrl(item),
            fit: BoxFit.cover,
          ),
        ),
        // 间距
        SizedBox(
          height: screenAdaptor.getLengthByOrientation(10.w, 5.w),
        ),
        // 标题文本
        Text(
          item["title"],
          maxLines: 2,
          // 去除溢出
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: screenAdaptor.getLengthByOrientation(15.sp, 10.sp),
            fontWeight: FontWeight.bold,
          ),
        ),
        // 副标题
        Text(
          item["creator"][0]["userName"],
          // 去除溢出
          overflow: TextOverflow.ellipsis,
          // 最多两行
          maxLines: 2,
          style: TextStyle(
            fontSize: screenAdaptor.getLengthByOrientation(12.sp, 8.sp),
            color: Colors.black45,
          ),
        ),
      ],
    );
  }
}
