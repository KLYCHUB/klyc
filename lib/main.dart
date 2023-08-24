// ignore_for_file: await_only_futures

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:klyc/pages/s%C4%B1gn_in_page.dart';
import 'package:klyc/services/functions/notifications_helper.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initialize();
  tz.initializeTimeZones();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.delayed(const Duration(seconds: 1));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}
