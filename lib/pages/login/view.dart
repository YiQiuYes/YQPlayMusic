import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yqplaymusic/common/utils/screenadaptor.dart';
import 'package:yqplaymusic/pages/login/state.dart';

import '../../generated/l10n.dart';
import 'logic.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginLogic logic = Get.put(LoginLogic());
  final LoginState state = Get.find<LoginLogic>().state;

  @override
  void initState() {
    // 判断是否登录成功
    logic.checkLoginStatus();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(
            0, screenAdaptor.getLengthByOrientation(10.h, 10.h), 0, 0),
        child: Column(
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: Image.asset("lib/assets/logos/netease-music.png"),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  0,
                  screenAdaptor.getLengthByOrientation(35.h, 35.h),
                  0,
                  screenAdaptor.getLengthByOrientation(35.h, 35.h)),
              child: Text(
                S.of(context).login_loginText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              width: 240,
              height: 240,
              padding: EdgeInsets.all(
                  screenAdaptor.getLengthByOrientation(16.h, 16.h)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
                color: const Color.fromRGBO(234, 239, 253, 1.0),
              ),
              child: Obx(
                () => QrImageView(
                  data: state.qrCodeUrl.value,
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color.fromRGBO(51, 94, 234, 1.0),
                  ),
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color.fromRGBO(51, 94, 234, 1.0),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Text(S.of(context).login_qr_tip),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).loginWithEmail,
                    style: const TextStyle(
                      color: Color.fromRGBO(82, 82, 82, 0.8),
                      fontSize: 13,
                      decorationThickness: 1.0,
                      decorationColor: Colors.black,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                    child: const Text("|"),
                  ),
                  Text(
                    S.of(context).loginWithPhone,
                    style: const TextStyle(
                      color: Color.fromRGBO(82, 82, 82, 0.8),
                      fontSize: 13,
                      decorationThickness: 1.0,
                      decorationColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
