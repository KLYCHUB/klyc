// ignore_for_file: file_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:klyc/components/app_icon.dart';
import 'package:klyc/pages/tab.dart';
import 'package:klyc/services/functions/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/square_tile.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Future<bool> _onWillPop() async {
    return false;
  }

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  late SharedPreferences _prefs;

  bool _rememberPassword = false;

  @override
  void initState() {
    super.initState();
    _loadRememberPassword();
    _loadSavedText(); // Load the saved email
  }

  Future<void> _loadRememberPassword() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberPassword = _prefs.getBool('rememberPassword') ?? false;
    });

    if (_rememberPassword) {
      final savedPassword = _prefs.getString('savedPassword') ?? '';
      _passwordController.text = savedPassword;
    }
  }

  Future<void> _loadSavedText() async {
    _prefs = await SharedPreferences.getInstance();
    final savedText = _prefs.getString('savedText') ?? '';
    setState(() {
      _emailController.text = savedText;
    });
  }

  void signIn(BuildContext context) async {
    AuthServices().signIn(
      context,
      email: _emailController.text,
      password: _passwordController.text,
    );

    await _prefs.setBool('rememberPassword', _rememberPassword);
    await _prefs.setString(
        'savedText', _emailController.text); // Save email value

    if (_rememberPassword) {
      await _prefs.setString('savedPassword', _passwordController.text);
    } else {
      await _prefs.remove('savedPassword');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const SizedBox(height: 50),
              const AppIcon(imagePath: 'assets/images/klyc.png'),
              const SizedBox(height: 50),
              Text(
                'Welcome back you\'ve been missed!👋',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      AuthServices().signInWithGoogle().then((value) =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const TabPage(),
                              settings: RouteSettings(arguments: value))));
                    },
                    child:
                        const SquareTile(imagePath: 'assets/images/google.png'),
                  ),
                  const SizedBox(width: 30),
                  InkWell(
                    onTap: () async {
                      UserCredential? userCredential =
                          await AuthServices().signInWithMicrosoft();
                      // signInWithMicrosoft fonksiyonu tarafından dönen userCredential'ı kullanarak işlemleri yapabilirsiniz.
                      // ignore: unnecessary_null_comparison
                      if (userCredential != null) {
                        // Kullanıcı başarılı bir şekilde Microsoft ile giriş yaptı, işlemleri burada yapabilirsiniz.
                      } else {
                        // Kullanıcı Microsoft ile giriş yaparken bir hata oluştu.
                      }
                    },
                    child: const SquareTile(imagePath: 'assets/images/mc.png'),
                  ),
                  const SizedBox(width: 30),
                  InkWell(
                    onTap: () async {
                      User? user = await AuthServices().signInAnonymously();
                      if (user != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const TabPage(),
                            settings: RouteSettings(arguments: user)));
                      }
                    },
                    child: const SquareTile(
                      imagePath: 'assets/images/anonim.png',
                    ),
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.info,
                  size: 34,
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
