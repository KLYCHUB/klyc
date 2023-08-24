import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final String imagePath;
  const AppIcon({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset(
        imagePath,
        height: 128,
      ),
    );
  }
}
