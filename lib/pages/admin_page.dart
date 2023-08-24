// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:klyc/services/functions/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50),
                    const Icon(
                      Icons.lock,
                      size: 100,
                    ),
                    const SizedBox(height: 50),
                    Text(
                      'Welcome back you\'ve been missed!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 25),
                    MyTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _rememberPassword,
                            onChanged: (newValue) {
                              setState(() {
                                _rememberPassword = newValue!;
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          Text(
                            'Remember Password',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    MyButton(
                      onTap: () => signIn(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
