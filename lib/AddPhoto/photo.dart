import 'package:flutter/material.dart';
import 'package:klyc/AddPhoto/user_image.dart';

class PhotoAdd extends StatefulWidget {
  const PhotoAdd({super.key});

  @override
  State<PhotoAdd> createState() => _PhotoAddState();
}

class _PhotoAddState extends State<PhotoAdd> {
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return UserImage(
      onFileChanged: (imageUrl) {
        setState(() {
          this.imageUrl = imageUrl;
        });
      },
    );
  }
}
