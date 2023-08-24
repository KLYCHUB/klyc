import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Function()? onTap;

  const MyButton({super.key, required this.onTap});

  @override
  // ignore: library_private_types_in_public_api
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  // Butonun rengini ve boyutunu tutan durum değişkenleri
  Color _buttonColor = Colors.black87;
  double _buttonSize = 20;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Butona tıklandığında durum değişkenlerinin değerlerini güncelle
        setState(() {
          _buttonColor = Colors.black54;
          _buttonSize = 20;
        });
        // Widget'ın onTap fonksiyonunu çağır
        widget.onTap?.call();
        // 0.5 saniye sonra durum değişkenlerinin değerlerini eski haline getir
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _buttonColor = Colors.black87;
            _buttonSize = 20;
          });
        });
      },
      child: AnimatedContainer(
        // Animasyon süresini ayarla
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(_buttonSize),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: _buttonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "Sign In",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
