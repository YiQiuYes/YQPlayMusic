import 'package:just_audio/just_audio.dart';

class Player {
  Player();

  // 当前播放位置 微秒
  int position = 0;
  // 歌曲总时长
  int duration = 0;
  // cb 函数
  List<Function()> currentPositionCbs = [];

  AudioPlayer? _audioPlayer;
  AudioPlayer getAudioPlayer() {
    if(_audioPlayer == null) {
      _audioPlayer = AudioPlayer();
      // 监听播放进度
      _audioPlayer?.positionStream.listen((Duration position) {
        // print("onPositionChanged: ${position.inMilliseconds}");
        this.position = position.inMilliseconds;
        if(currentPositionCbs.isNotEmpty) {
          for (var function in currentPositionCbs) {
            function();
          }
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
  void setCurrentPositionCb(Function() currentPositionCb) {
    currentPositionCbs.add(currentPositionCb);
  }

  // 获取播放器
  AudioPlayer get audioPlayer => getAudioPlayer();
}

final Player player = Player();