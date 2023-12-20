import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Cover extends StatelessWidget {
  const Cover(
      {Key? key,
      required this.imageUrl,
      this.id})
      : super(key: key);

  // 专辑id
  final int? id;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
    );
  }
}
