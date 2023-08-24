import 'package:flutter/material.dart';
import 'package:klyc/components/account_add_login.dart';
import 'package:klyc/components/account_name.dart';
import 'package:klyc/components/custom_button.dart';
import 'package:klyc/components/drawer_photo.dart';
import 'package:klyc/pages/photo_ai_make.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: Colors.black87,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  DrawerPhoto(),
                  AccountName(),
                ],
              ),
            ],
          ),
          const Spacer(),
          CustomButton(
            buttonTetxt: 'RESİM OLUŞTUR',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const PhotoAI();
                },
              ));
            },
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(10),
            child: AccountAddLogin(),
          ),
        ],
      ),
    );
  }
}
