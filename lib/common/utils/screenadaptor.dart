import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdaptor {

  ScreenAdaptor();
  double getLengthByOrientation(double vertical, double horizon)
  {
    return ScreenUtil().orientation.index == 0 ? vertical : horizon;
  }
}

final ScreenAdaptor screenAdaptor = ScreenAdaptor();