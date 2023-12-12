import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class Player {
  Player();

  // 当前播放位置 微秒
  final RxInt position = 0.obs;
  // 歌曲总时长
  final RxInt duration = 0.obs;

  AudioPlayer? _audioPlayer;
  AudioPlayer getAudioPlayer() {
    if(_audioPlayer == null) {
      _audioPlayer = AudioPlayer();
      // 监听播放进度
      _audioPlayer?.onPositionChanged.listen((Duration position) {
        // print("onPositionChanged: ${position.inMilliseconds}");
        this.position.value = position.inMilliseconds;
      });
      // 获取歌曲总时长
      _audioPlayer?.onDurationChanged.listen((Duration duration) {
        // print("onDurationChanged: ${duration.inMilliseconds}");
        this.duration.value = duration.inMilliseconds;
      });
    }
    return _audioPlayer!;
  }

  // 获取播放器
  AudioPlayer get audioPlayer => getAudioPlayer();
}

final Player player = Player();