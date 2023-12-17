class ShareData {
  ShareData(
      {this.musicID,
      this.isPlaying,
      this.musicImageUrl,
      this.musicName,
      this.musicArtist,
      this.playAndPause,
      this.songIDs,
      this.previous,
      this.next});

  // 音乐id
  String? musicID;
  // 是否播放
  bool? isPlaying;
  // 暂停和播放
  bool? playAndPause;
  // 音乐图片链接
  String? musicImageUrl;
  // 歌曲名
  String? musicName;
  // 歌手名
  String? musicArtist;
  // ID集合
  List<String>? songIDs;
  // 上一首
  bool? previous;
  // 下一首
  bool? next;

  // 获取所有数据
  Map<String, dynamic> get mapData {
    return {
      "musicID": musicID,
      "isPlaying": isPlaying,
      "musicImageUrl": musicImageUrl,
      "musicName": musicName,
      "musicArtist": musicArtist,
      "playAndPause" : playAndPause,
      "songIDs": songIDs,
      "previous": previous,
      "next": next,
    };
  }
}
