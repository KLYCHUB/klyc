import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DrawerPhoto extends StatefulWidget {
  const DrawerPhoto({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DrawerPhotoState createState() => _DrawerPhotoState();
}

class _DrawerPhotoState extends State<DrawerPhoto> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 10),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: 200.0,
          height: 100.0,
          child: Shimmer.fromColors(
            baseColor: Colors.black87,
            highlightColor: Colors.white,
            child: const CircleAvatar(),
          ),
        ),
      ),
    );
  }
}
