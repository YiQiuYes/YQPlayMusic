class ShareData {
  ShareData({this.musicID, this.isPlaying});

  String? musicID;
  bool? isPlaying;

  // 获取所有数据
  Map<String, dynamic> get mapData {
    return {
      "musicID": musicID,
      "isPlaying": isPlaying,
    };
  }
}
