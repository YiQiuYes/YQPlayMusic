import 'dart:ui';

import 'package:flutter/material.dart';

class BlurRectWidget extends StatelessWidget {
  final Widget _widget;
  final double singmaX;
  final double singmaY;

  const BlurRectWidget(this._widget, {super.key, required this.singmaX, required this.singmaY});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: singmaX,
          sigmaY: singmaY,
        ),
        child: _widget,
      ),
    );
  }
}
