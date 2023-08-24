import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final bool isLiked;
  final void Function() onTap;

  const LikeButton({
    Key? key,
    required this.isLiked,
    required this.onTap,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // onTap işlevini direkt olarak kullanın
      child: Icon(
        widget.isLiked ? Icons.favorite : Icons.favorite_border,
        color: widget.isLiked ? Colors.red : Colors.grey,
      ),
    );
  }
}
