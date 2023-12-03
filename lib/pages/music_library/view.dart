import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yqplaymusic/api/track.dart';
import 'package:yqplaymusic/api/user.dart';

import '../../common/utils/screenadaptor.dart';
import 'logic.dart';
import 'dart:developer' as developer;

class MusicLibraryPage extends StatefulWidget {
  const MusicLibraryPage({super.key});

  @override
  State<MusicLibraryPage> createState() => _MusicLibraryPageState();
}

class _MusicLibraryPageState extends State<MusicLibraryPage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.put(MusicLibraryLogic());
  final state = Get.find<MusicLibraryLogic>().state;

  @override
  void initState() {
    logic.pageInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        screenAdaptor.getLengthByOrientation(24.h, 105.h),
        0,
        screenAdaptor.getLengthByOrientation(24.h, 115.h),
        0,
      ),
      child: SizedBox(
        // 占满屏幕
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 占位
              SizedBox(
                height: screenAdaptor.getLengthByOrientation(50.h, 80.h),
              ),
              // 音乐库标题
              Obx(() {
                return Row(
                  children: [
                    // 用户头像
                    Visibility(
                      visible: state.userImgUrl.value != "",
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: state.userImgUrl.value,
                          width:
                              screenAdaptor.getLengthByOrientation(35.h, 70.h),
                          height:
                              screenAdaptor.getLengthByOrientation(35.h, 70.h),
                        ),
                      ),
                    ),
                    // 间距
                    SizedBox(
                      width: screenAdaptor.getLengthByOrientation(20.h, 30.h),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                        top: screenAdaptor.getLengthByOrientation(20.h, 30.h),
                        bottom:
                            screenAdaptor.getLengthByOrientation(20.h, 30.h),
                      ),
                      child: Text(
                        state.userInfo["nickname"] != null
                            ? "${state.userInfo["nickname"]}的音乐库"
                            : "",
                        style: TextStyle(
                          fontSize: screenAdaptor.getLengthByOrientation(
                              30.sp, 28.sp),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }),
              // 间距
              SizedBox(
                height: screenAdaptor.getLengthByOrientation(50.h, 30.h),
              ),
              // 音乐库内容
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      screenAdaptor.getLengthByOrientation(10.h, 25.h),
                    ),
                    child: Container(
                      width: screenAdaptor.getLengthByOrientation(350.h, 550.h),
                      height:
                          screenAdaptor.getLengthByOrientation(250.h, 400.h),
                      color: const Color.fromRGBO(232, 237, 253, 1.0),
                      child: Stack(
                        children: [
                          // 歌词部分
                          Positioned(
                            top: screenAdaptor.getLengthByOrientation(
                                20.h, 35.h),
                            left: screenAdaptor.getLengthByOrientation(
                                20.h, 35.h),
                            child: Text(
                              "编曲:周以力\n制作人:周以力/郑伟\n吉他:张淞",
                              style: TextStyle(
                                fontSize: screenAdaptor.getLengthByOrientation(
                                    16.sp, 10.sp),
                                color: const Color.fromRGBO(51, 94, 235, 0.9),
                              ),
                            ),
                          ),
                          // 我喜欢的音乐
                          Positioned(
                            bottom: screenAdaptor.getLengthByOrientation(
                                50.h, 90.h),
                            left: screenAdaptor.getLengthByOrientation(
                                20.h, 35.h),
                            child: Text(
                              "我喜欢的音乐",
                              style: TextStyle(
                                fontSize: screenAdaptor.getLengthByOrientation(
                                    27.sp, 16.sp),
                                fontWeight: FontWeight.bold,
                                color: const Color.fromRGBO(51, 94, 235, 1.0),
                              ),
                            ),
                          ),
                          // 歌曲的数量
                          Positioned(
                            bottom: screenAdaptor.getLengthByOrientation(
                                20.h, 45.h),
                            left: screenAdaptor.getLengthByOrientation(
                                20.h, 35.h),
                            child: Text(
                              "35首歌",
                              style: TextStyle(
                                fontSize: screenAdaptor.getLengthByOrientation(
                                    16.sp, 10.sp),
                                color: const Color.fromRGBO(51, 94, 235, 1.0),
                              ),
                            ),
                          ),
                          // 播放按钮
                          Positioned(
                            bottom: screenAdaptor.getLengthByOrientation(
                                20.h, 35.h),
                            right: screenAdaptor.getLengthByOrientation(
                                20.h, 35.h),
                            child: ClipOval(
                              child: Container(
                                width: screenAdaptor.getLengthByOrientation(
                                    55.h, 90.h),
                                height: screenAdaptor.getLengthByOrientation(
                                    55.h, 90.h),
                                color: const Color.fromRGBO(51, 94, 235, 1.0),
                                child: IconButton(
                                  onPressed: () {},
                                  padding: EdgeInsets.fromLTRB(
                                    screenAdaptor.getLengthByOrientation(
                                        20.h, 33.h),
                                    screenAdaptor.getLengthByOrientation(
                                        18.h, 30.h),
                                    screenAdaptor.getLengthByOrientation(
                                        16.h, 27.h),
                                    screenAdaptor.getLengthByOrientation(
                                        18.h, 30.h),
                                  ),
                                  icon: SvgPicture.asset(
                                    "lib/assets/icons/play.svg",
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
