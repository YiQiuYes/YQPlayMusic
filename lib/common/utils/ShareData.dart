class ShareData {
  ShareData(
      {this.musicID,
      this.isPlaying,
      this.musicImageUrl,
      this.musicName,
      this.musicArtist});

  // 音乐id
  String? musicID;
  // 是否播放
  bool? isPlaying;
  // 音乐图片链接
  String? musicImageUrl;
  // 歌曲名
  String? musicName;
// 歌手名
  String? musicArtist;

  // 获取所有数据
  Map<String, dynamic> get mapData {
    return {
      "musicID": musicID,
      "isPlaying": isPlaying,
      "musicImageUrl": musicImageUrl,
      "musicName": musicName,
      "musicArtist": musicArtist,
    };
  }
}
