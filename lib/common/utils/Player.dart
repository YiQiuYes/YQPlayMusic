import 'package:just_audio/just_audio.dart';

class Player {
  Player();

  // 当前播放位置 微秒
  int position = 0;
  // 歌曲总时长
  int duration = 0;
  // cb 函数
  Function(int)? currentPositionCb;

  AudioPlayer? _audioPlayer;
  AudioPlayer getAudioPlayer() {
    if(_audioPlayer == null) {
      _audioPlayer = AudioPlayer();

      // 监听播放进度
      _audioPlayer?.positionStream.listen((Duration position) {
        // print("onPositionChanged: ${position.inMilliseconds}");
        this.position = position.inMilliseconds;
        if(currentPositionCb != null) {
          currentPositionCb!(this.position);
        }
      });

      // 获取歌曲总时长
      _audioPlayer?.durationStream.listen((Duration? duration) {
        this.duration = duration?.inMilliseconds ?? 0;
      });
    }
    return _audioPlayer!;
  }

  // 设置cb函数
  void setCurrentPositionCb(Function(int) currentPositionCb) {
    this.currentPositionCb = currentPositionCb;
  }

  // 获取播放器
  AudioPlayer get audioPlayer => getAudioPlayer();
}

final Player player = Player();