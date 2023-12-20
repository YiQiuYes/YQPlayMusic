import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'state.dart';

class AlbumLogic extends GetxController {
  final AlbumState state = AlbumState();

  void initPage(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    state.id = arguments["id"].toString();
  }
}
