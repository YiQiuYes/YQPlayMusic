import 'package:get/get.dart';

class MusicLibraryState {
  // 登录状态
  late RxBool loginStatus;
  // 用户头像
  late RxString userImgUrl;
  // 用户信息
  late RxMap userInfo;
  // 我喜欢的歌曲
  late RxList likeSongs;

  MusicLibraryState() {
    loginStatus = false.obs;
    userImgUrl = "".obs;
    userInfo = {}.obs;
    likeSongs = [].obs;
  }
}
