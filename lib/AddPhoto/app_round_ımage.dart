// ignore_for_file: file_names, unused_import

import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class AppRoundImage extends StatelessWidget {
  final ImageProvider provider;
  final double height;
  final double widht;
  const AppRoundImage(this.provider,
      {super.key, required this.height, required this.widht});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Image(
        image: provider,
        height: height,
        width: widht,
      ),
    );
  }

  factory AppRoundImage.url(String url,
      {required double height, required double widht}) {
    return AppRoundImage(NetworkImage(url), height: height, widht: widht);
  }

  factory AppRoundImage.memory(Uint8List data,
      {required double height, required double widht}) {
    return AppRoundImage(MemoryImage(data), height: height, widht: widht);
  }
}
