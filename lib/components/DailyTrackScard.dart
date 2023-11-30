import 'dart:async';
import 'dart:math';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/utils/screenadaptor.dart';

class DailyTracksCard extends StatefulWidget {
  const DailyTracksCard(
      {super.key,
      required this.width,
      required this.height,
      this.dailyTracksList,
      this.defaultTracksList});

  final double width;
  final double height;
  final List<dynamic>? dailyTracksList;
  final List<String>? defaultTracksList;

  @override
  State<DailyTracksCard> createState() => _DailyTracksCardState();
}

class _DailyTracksCardState extends State<DailyTracksCard>
    with SingleTickerProviderStateMixin {
  // 平移动画控制器
  late AnimationController animationController;
  late Animation<double> animation;
  late Future<ui.Image> image;

  // 获取For You 每日推荐图片
  Future<ui.Image> loadDailyTracksImage(String path) async {
    final data = await NetworkAssetBundle(Uri.parse(path)).load(path);
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);
    return image;
  }

  // 获取图片构建器
  Future<ui.Image> loadUiImage() async {
    if (widget.dailyTracksList!.isNotEmpty) {
      return await loadDailyTracksImage(widget.dailyTracksList![0]["al"]["picUrl"])
              .then((value) {
        animationController = AnimationController(
          duration: const Duration(seconds: 28),
          vsync: this,
        )..repeat(reverse: true);

        animation = animationController.drive(Tween(
          begin: 0,
          end: (value.height * widget.width / value.width - widget.height),
        ));
        return value;
      });
    } else {
      // 随机从0到3的数，不包括3
      int index = Random().nextInt(3).toInt();
      return await  loadDailyTracksImage(widget.defaultTracksList![index])
          .then((value) {
        animationController = AnimationController(
          duration: const Duration(seconds: 28),
          vsync: this,
        )..repeat(reverse: true);

        animation = animationController.drive(Tween(
          begin: 0,
          end: (value.height * widget.width / value.width - widget.height),
        ));
        return value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 异步获取图片
    image = loadUiImage();
  }

  @override
  void dispose() {
    // 释放动画资源
    animationController.dispose();
    super.dispose();
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
          future: image,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DailyTracksCardPainter(
                        image: snapshot.data,
                        currentY: animation,
                        repaint: animationController,
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 38,
                    left: 50,
                    child: Text(
                      "每日\n推荐",
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 12,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 30,
                    bottom: 30,
                    child: IconButton(
                      style: ButtonStyle(
                        // 半透明背景
                        backgroundColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.15),
                        ),
                        overlayColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.3),
                        ),
                      ),
                      // 播放按钮
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 60,
                      ),
                      onPressed: () {},
                    ),
                  )
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

// 画布类
class DailyTracksCardPainter extends CustomPainter {
  ui.Image? image;
  double x;
  // 当前y轴位置
  final Animation<double> currentY;
  final Animation<double> repaint;

  DailyTracksCardPainter({this.image, this.x = 0, required this.currentY, required this.repaint})
      : super(repaint: repaint);

  final painter = Paint();
  @override
  void paint(Canvas canvas, Size size) {
    double imageX = image!.width.toDouble();
    double imageY = image!.height.toDouble();
    // 要绘制的Rect，即原图片的大小
    Rect src = Rect.fromLTWH(0, 0, imageX, imageY);
    // 要绘制成的Rect，即绘制后的图片大小
    canvas.drawImageRect(
        image!,
        src,
        Rect.fromLTWH(
            x,
            -currentY.value,
            image!.width.toDouble() * size.width / imageX,
            image!.height.toDouble() * size.width / imageY),
        painter);
  }

  @override
  bool shouldRepaint(covariant DailyTracksCardPainter oldDelegate) {
    return oldDelegate.repaint != repaint;
  }
}
