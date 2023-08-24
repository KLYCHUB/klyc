import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonTetxt,
    required this.onPressed,
  });

  final String buttonTetxt;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
          elevation: MaterialStatePropertyAll(0),
          backgroundColor: MaterialStatePropertyAll(Colors.transparent)),
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(25),
        ),
        height: MediaQuery.of(context).size.width / 8.5,
        width: MediaQuery.of(context).size.width / 2,
        child: Text(
          buttonTetxt,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
        ),
      ),
    );
  }
}
