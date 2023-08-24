import 'package:flutter/material.dart';

class AppBarText extends StatelessWidget {
  const AppBarText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "KLYC",
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: Colors.white,
          ),
    );
  }
}
