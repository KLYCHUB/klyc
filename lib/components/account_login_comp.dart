import 'package:flutter/material.dart';

class AccounAddComponents extends StatelessWidget {
  const AccounAddComponents({super.key, required this.componentsText});

  final String componentsText;

  @override
  Widget build(BuildContext context) {
    return Text(
      componentsText,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
    );
  }
}
