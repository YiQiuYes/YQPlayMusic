import 'dart:developer' as developer;

class SongInfoUtils {
  // 单例模式
  SongInfoUtils._internal();
  static final SongInfoUtils _songInfoUtils = SongInfoUtils._internal();

  factory SongInfoUtils() {
    return _songInfoUtils;
  }

  // 获取歌曲名字
  String getSongName(Map item) {
    if (item["simpleSong"] != null) {
      item = item["simpleSong"];
    } else {
      item = item["songs"][0];
    }

    return item["name"];
  }

  // 获取歌曲标题信息
  String getSuTitle(Map item) {
    if (item["simpleSong"] != null) {
      item = item["simpleSong"];
    } else {
      item = item["songs"][0];
    }
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
    if (item["simpleSong"] != null) {
      item = item["simpleSong"];
    } else {
      item = item["songs"][0];
    }
    String imageUrl = item["al"]?["picUrl"] ??
        item["album"]?["picUrl"] ??
        "https://p2.music.126.net/UeTuwE7pvjBpypWLudqukA==/3132508627578625.jpg";

    return imageUrl;
  }

  // 获取歌手信息
  String getArtists(Map item) {
    if (item["simpleSong"] != null) {
      item = item["simpleSong"];
    } else {
      item = item["songs"][0];
    }
    if (item["ar"] != null) {
      if (item["ar"].isNotEmpty) {
        String name = item["ar"].map((e) => e["name"]).join(", ");
        if (name == "null") return "";
        return name;
      }
    } else if (item["artists"] != null) {
      if (item["artists"].isNotEmpty) {
        String name = item["artists"].map((e) => e["name"]).join(", ");
        if (name == "null") return "";
        return name;
      }
    }
    return "";
  }

  // 获取专辑名字
  String getAlbumName(Map item) {
    if (item["simpleSong"] != null) {
      item = item["simpleSong"];
    } else {
      item = item["songs"][0];
    }
    if (item["album"] != null) {
      return item["album"]["name"] ?? "";
    } else if (item["al"] != null) {
      return item["al"]["name"] ?? "";
    }
    return "";
  }

  // 获取歌曲时间
  String getSongTime(Map item) {
    if (item["simpleSong"] != null) {
      item = item["simpleSong"];
    } else {
      item = item["songs"][0];
    }
    // 歌曲时间
    double dt = item["dt"] / 1000;
    if (dt == 0) return "0:00";
    // 获取秒
    int second = (dt % 60).truncate();
    return "${dt ~/ 60}:${second < 10 ? "0$second" : second}";
  }

  // 获取所有id集合
 List<String> getMapSongIDs(List items) {
    // developer.log(items.toString());
    List<String> result = [];
    Map item = {};
    for(int i = 0; i < items.length; i++) {
      item = items[i];
      if (item["simpleSong"] != null) {
        item = item["simpleSong"];
      }
      result.add(item["id"].toString());
    }
    return result;
 }
}
