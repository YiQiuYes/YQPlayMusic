import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdaptor {

  ScreenAdaptor();
  double getLengthByOrientation(double vertical, double horizon)
  {
    return ScreenUtil().orientation.index == 0 ? vertical : horizon;
  }

  // 传入当前参数获取相对应的宽度
  double getOrientationWidth(double width) {
    return width / ScreenUtil().screenWidth;
  }

  /// 获取横屏还是竖屏
  /// true: 竖屏  false: 横屏
  bool getOrientation() {
    return ScreenUtil().orientation.index == 0 ? true : false;
  }
}

final ScreenAdaptor screenAdaptor = ScreenAdaptor();