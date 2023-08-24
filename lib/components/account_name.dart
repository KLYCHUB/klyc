import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:klyc/services/functions/random_nick_name.dart';

class AccountName extends StatelessWidget {
  const AccountName({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = ModalRoute.of(context)?.settings.arguments as User?;

    String randomNickname = RandomNickName().generateRandomNickname();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        user?.displayName ?? randomNickname,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
      ),
    );
  }
}
