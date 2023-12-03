import 'package:flutter/material.dart';
import 'package:yqplaymusic/components/TrackListItem.dart';

import '../common/utils/screenadaptor.dart';

class TrackList extends StatelessWidget {
  const TrackList(
      {super.key,
      this.type = "tracklist",
      required this.tracks,
      this.columnCount = 4});

  // 类型
  final String type;
  // 歌单列表
  final List tracks;
  // 显示几列
  final int columnCount;

  Widget _bulidTrackList() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: screenAdaptor.getLengthByOrientation(3.33, 3.14)),
      itemCount: 12,
      itemBuilder: (context, index) {
        return TrackListItem(
          track: tracks[index],
        );
      },
    );
  }

  Widget switchType() {
    switch (type) {
      case "tracklist":
        return _bulidTrackList();
      default:
        return _bulidTrackList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return switchType();
  }
}
