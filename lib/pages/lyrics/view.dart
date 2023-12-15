import 'package:cached_network_image/cached_network_image.dart';
import 'package:css_filter/css_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:yqplaymusic/common/utils/Player.dart';

import '../../common/utils/screenadaptor.dart';
import 'logic.dart';

class LyricsPage extends StatefulWidget {
  const LyricsPage({super.key});

  @override
  State<LyricsPage> createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  final logic = Get.put(LyricsLogic());
  final state = Get.find<LyricsLogic>().state;

  @override
  void initState() {
    logic.getSongInfo();
    logic.startTimerMusicPrecess();
    // 设置当前播放位置回调
    player.setCurrentPositionCb(logic.handleLyricsScroll);
    super.initState();
  }

  @override
  void dispose() {
    state.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 获取背景控件
        ..._getBackgroundWidget(),
        // 播放空间和歌词滚动模块
        Center(
          child: NotificationListener(
            onNotification: logic.handleLyricsIsScroll,
            child: _getPlayControlAndLyricsScrollWidget(),
          ),
        ),
      ],
    );
  }

  // 获取背景控件
  List<Widget> _getBackgroundWidget() {
    return [
      Positioned.fill(
        child: Container(
          color: Colors.white,
          child: CSSFilter.apply(
            value: CSSFilterMatrix().contrast(0.3).brightness(2.5).blur(50),
            child: Obx(
              () => Image.network(
                logic.getSongImageUrl(type: "background"),
                alignment: Alignment.topRight,
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.color,
                color: Colors.white,
                gaplessPlayback: true,
              ),
            ),
          ),
        ),
      ),
      // 两张图片叠加
      Positioned.fill(
        child: CSSFilter.apply(
          value: CSSFilterMatrix().contrast(0.3).brightness(2.5).blur(50),
          child: Obx(
            () => Image.network(
              logic.getSongImageUrl(type: "background"),
              fit: BoxFit.cover,
              alignment: Alignment.bottomLeft,
              gaplessPlayback: true,
            ),
          ),
        ),
      ),
    ];
  }

  // 获取我喜欢和添加到歌单控件
  Widget _getLikeAndAddSongListWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            "lib/assets/icons/heart.svg",
            fit: BoxFit.contain,
            width: screenAdaptor.getLengthByOrientation(30.w, 15.w),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            "lib/assets/icons/plus.svg",
            fit: BoxFit.contain,
            width: screenAdaptor.getLengthByOrientation(30.w, 15.w),
          ),
        ),
      ],
    );
  }

  // 获取播放控件和歌词滚动模块
  Widget _getPlayControlAndLyricsScrollWidget() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: [
        // 歌词信息及播放控件
        Visibility(
          visible: false || !screenAdaptor.getOrientation(),
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(
              top: screenAdaptor.getLengthByOrientation(200.w, 60.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 歌词图片
                _getSongImage(),
                // 间距
                SizedBox(
                  height: screenAdaptor.getLengthByOrientation(30.w, 15.w),
                ),
                // 歌曲信息及我喜欢等控件
                SizedBox(
                  width: screenAdaptor.getLengthByOrientation(400.w, 200.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 歌曲信息
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 歌曲名称
                          _getSongNameText(),
                          // 间距
                          SizedBox(
                            height:
                                screenAdaptor.getLengthByOrientation(5.w, 5.w),
                          ),
                          // 歌曲副标题
                          _getSongNameSubText(),
                        ],
                      ),
                      // 我喜欢等控件
                      _getLikeAndAddSongListWidget(),
                    ],
                  ),
                ),
                // 间距
                SizedBox(
                  height: screenAdaptor.getLengthByOrientation(30.w, 8.w),
                ),
                // 播放进度条
                _getPlayPrecessBar(),
                // 间距
                SizedBox(
                  height: screenAdaptor.getLengthByOrientation(30.w, 8.w),
                ),
                // 播放控件
                _getPlayControlBar(),
              ],
            ),
          ),
        ),
        // 间距
        Visibility(
          visible: !screenAdaptor.getOrientation(),
          child: SizedBox(
            width: screenAdaptor.getLengthByOrientation(50.w, 70.w),
          ),
        ),
        // 歌词
        Visibility(
          visible: !screenAdaptor.getOrientation() || true,
          child: _getLyricWidget(),
        ),
      ],
    );
  }

  // 获取歌词行组件
  Widget _getLyricLineBuilder(BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Text(
            "${state.lyrics[index]}",
            style: TextStyle(
              decoration: TextDecoration.none,
              color: state.lyricsScrollPosition.value == index
                  ? Colors.black
                  : Colors.black26,
              fontSize: screenAdaptor.getLengthByOrientation(40.sp, 22.sp),
            ),
          );
        }),
        // 间距
        SizedBox(
          height: screenAdaptor.getLengthByOrientation(20.w, 20.w),
        ),
      ],
    );
  }

  // 获取歌词组件
  Widget _getLyricWidget() {
    return SizedBox(
      width: screenAdaptor.getLengthByOrientation(480.w, 270.w),
      child: Obx(() {
        return ScrollablePositionedList.builder(
          shrinkWrap: true,
          itemScrollController: state.itemScrollController,
          scrollOffsetController: state.scrollOffsetController,
          itemCount: state.lyrics.length,
          padding: EdgeInsets.only(
            top: screenAdaptor.getLengthByOrientation(580.w, 200.w),
            bottom: screenAdaptor.getLengthByOrientation(650.w, 300.w),
          ),
          itemBuilder: _getLyricLineBuilder,
        );
      }),
    );
  }

  // 获取播放控件
  Widget _getPlayControlBar() {
    return SizedBox(
      width: screenAdaptor.getLengthByOrientation(400.w, 200.w),
      child: Padding(
        padding: EdgeInsets.only(
          left: screenAdaptor.getLengthByOrientation(10.w, 12.w),
          right: screenAdaptor.getLengthByOrientation(10.w, 12.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 循环播放
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "lib/assets/icons/repeat.svg",
                fit: BoxFit.contain,
                width: screenAdaptor.getLengthByOrientation(28.w, 12.w),
                color: Colors.black26,
              ),
            ),
            // 上一首
            IconButton(
              onPressed: logic.handlePreBtn,
              icon: SvgPicture.asset(
                "lib/assets/icons/previous.svg",
                fit: BoxFit.contain,
                width: screenAdaptor.getLengthByOrientation(35.w, 15.w),
              ),
            ),
            // 播放
            IconButton(
              onPressed: logic.handlePlayBtn,
              icon: Obx(() {
                return SvgPicture.asset(
                  state.isPlaying.value
                      ? "lib/assets/icons/pause.svg"
                      : "lib/assets/icons/play.svg",
                  fit: BoxFit.contain,
                  width: screenAdaptor.getLengthByOrientation(40.w, 20.w),
                );
              }),
            ),
            // 下一首
            IconButton(
              onPressed: logic.handleNextBtn,
              icon: SvgPicture.asset(
                "lib/assets/icons/next.svg",
                fit: BoxFit.contain,
                width: screenAdaptor.getLengthByOrientation(35.w, 15.w),
              ),
            ),
            // 随机播放
            IconButton(
              onPressed: () {
                logic.refreshData();
              },
              icon: SvgPicture.asset(
                "lib/assets/icons/shuffle.svg",
                fit: BoxFit.contain,
                width: screenAdaptor.getLengthByOrientation(28.w, 12.w),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 获取播放进度条
  Widget _getPlayPrecessBar() {
    return SizedBox(
      width: screenAdaptor.getLengthByOrientation(400.w, 200.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            return Text(
              logic.getSongProgressText(),
              style: TextStyle(
                color: Colors.black54,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
                wordSpacing: 0,
                letterSpacing: 0,
                fontSize: screenAdaptor.getLengthByOrientation(20.sp, 10.sp),
              ),
            );
          }),
          // 进度条
          Expanded(
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3,
                  inactiveTrackColor: Colors.grey[300],
                  activeTrackColor: Colors.blue,
                  disabledActiveTrackColor: Colors.blue,
                  disabledInactiveTrackColor: Colors.blue,
                  thumbColor: Colors.white,
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 20),
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 7),
                ),
                child: Obx(() {
                  return Slider(
                    value: state.lyricsProgress.value,
                    secondaryTrackValue: state.lyricsProgressNoBlock.value,
                    inactiveColor: Colors.grey[500],
                    thumbColor: Colors.black,
                    activeColor: Colors.black,
                    secondaryActiveColor: Colors.black,
                    onChanged: (double value) {
                      state.lyricsProgress.value = value;
                    },
                    onChangeStart: logic.startMusicProcessDrag,
                    onChangeEnd: logic.endMusicProcessDrag,
                  );
                }),
              ),
            ),
          ),
          // 歌曲时长
          Obx(() {
            return Text(
              logic.getSongDuration(),
              style: TextStyle(
                color: Colors.black54,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
                wordSpacing: 0,
                letterSpacing: 0,
                fontSize: screenAdaptor.getLengthByOrientation(20.sp, 10.sp),
              ),
            );
          }),
        ],
      ),
    );
  }

  // 获取歌曲副标题
  Widget _getSongNameSubText() {
    return Obx(() {
      return SizedBox(
        width: screenAdaptor.getLengthByOrientation(250.w, 110.w),
        child: Text.rich(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black54,
            fontSize: screenAdaptor.getLengthByOrientation(18.sp, 8.sp),
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.none,
          ),
          TextSpan(
            children: [
              TextSpan(
                text: logic.getArtistName(),
              ),
              const TextSpan(
                text: " - ",
              ),
              TextSpan(
                text: logic.getAlbumName(),
              ),
            ],
          ),
        ),
      );
    });
  }

  // 获取歌曲名称
  Widget _getSongNameText() {
    return Obx(() {
      return SizedBox(
        width: screenAdaptor.getLengthByOrientation(250.w, 110.w),
        child: Text(
          logic.getSongName(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: screenAdaptor.getLengthByOrientation(27.sp, 13.sp),
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),
      );
    });
  }

  // 获取歌词图片
  Widget _getSongImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        screenAdaptor.getLengthByOrientation(20.w, 8.w),
      ),
      child: Obx(() {
        return CachedNetworkImage(
          imageUrl: logic.getSongImageUrl(type: "cover"),
          fit: BoxFit.contain,
          width: screenAdaptor.getLengthByOrientation(400.w, 200.w),
          height: screenAdaptor.getLengthByOrientation(400.w, 200.w),
        );
      }),
    );
  }
}
