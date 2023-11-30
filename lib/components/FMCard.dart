import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:yqplaymusic/common/utils/screenadaptor.dart';

class FMCard extends StatefulWidget {
  const FMCard(
      {super.key, required this.width, required this.height, this.items});

  // 宽高
  final double width;
  final double height;
  final List<dynamic>? items;

  @override
  State<FMCard> createState() => _FMCardState();
}

class _FMCardState extends State<FMCard> {
  // 专辑图片
  late Image image;
  late Future<List<Color>> colors;

  @override
  void initState() {
    super.initState();
    image = Image.network(widget.items![0]["album"]["picUrl"] + "?param=512y512");
    colors = PaletteGenerator.fromImageProvider(image.image).then((value) {
      TinyColor color = TinyColor.fromColor(value.dominantColor!.color);
      Color dominantColorBottomRight = color.darken(10).color;
      Color dominantColorTopLeft = color.lighten(28).spin(-30).color;
      return [dominantColorTopLeft, dominantColorBottomRight];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        screenAdaptor.getLengthByOrientation(20.w, 12.w),
      ),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: FutureBuilder(
          future: colors,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        // 渐变颜色
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: const [0.0, 1.0],
                          colors: [snapshot.data[0], snapshot.data[1]],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenAdaptor.getLengthByOrientation(16.w, 10.w),
                    left: screenAdaptor.getLengthByOrientation(18.w, 11.w),
                    bottom: screenAdaptor.getLengthByOrientation(16.w, 10.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        screenAdaptor.getLengthByOrientation(16.w, 10.w),
                      ),
                      child: image,
                    ),
                  ),
                  Positioned(
                    right: screenAdaptor.getLengthByOrientation(20.w, 12.w),
                    bottom: screenAdaptor.getLengthByOrientation(18.w, 13.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "lib/assets/icons/fm.svg",
                          width:
                              screenAdaptor.getLengthByOrientation(15.w, 10.w),
                          colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.18),
                            BlendMode.srcIn,
                          ),
                        ),
                        // 间隔
                        SizedBox(
                          width: screenAdaptor.getLengthByOrientation(8.w, 4.w),
                        ),
                        Text(
                          "私人FM",
                          style: TextStyle(
                            letterSpacing: 0,
                            color: Colors.white.withOpacity(0.18),
                            fontSize: screenAdaptor.getLengthByOrientation(
                                16.sp, 10.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 按钮侧
                  Positioned(
                    left: screenAdaptor.getLengthByOrientation(210.w, 135.w),
                    bottom: screenAdaptor.getLengthByOrientation(15.w, 10.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          // 不喜欢按钮
                          icon: SvgPicture.asset(
                            "lib/assets/icons/thumbs-down.svg",
                            width: screenAdaptor.getLengthByOrientation(
                                22.w, 14.w),
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        // 播放按钮
                        IconButton(
                          // 播放按钮
                          icon: SvgPicture.asset(
                            "lib/assets/icons/play.svg",
                            width: screenAdaptor.getLengthByOrientation(
                                22.w, 14.w),
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        // 下一首按钮
                        IconButton(
                          // 下一首按钮
                          icon: SvgPicture.asset(
                            "lib/assets/icons/next.svg",
                            width: screenAdaptor.getLengthByOrientation(
                                22.w, 14.w),
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  // 歌曲信息
                  Positioned(
                    top: screenAdaptor.getLengthByOrientation(16.w, 10.w),
                    left: screenAdaptor.getLengthByOrientation(210.w, 135.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: screenAdaptor.getLengthByOrientation(
                              300.w, 150.w),
                          child: Text(
                            widget.items![0]["name"],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenAdaptor.getLengthByOrientation(
                                  30.sp, 18.sp),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // 间隔
                        SizedBox(
                          height: screenAdaptor.getLengthByOrientation(
                              6.w, 4.w),
                        ),
                        Text(
                          widget.items![0]["artists"][0]["name"],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: screenAdaptor.getLengthByOrientation(
                                20.sp, 12.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
