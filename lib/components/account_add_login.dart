// ignore: unused_element
import 'package:flutter/material.dart';

import '../pages/sıgn_in_page.dart';
import 'account_login_comp.dart';

class AccountAddLogin extends StatelessWidget {
  const AccountAddLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: IconButton(
        onPressed: () {
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            context: context,
            builder: (context) {
              return SizedBox(
                height: MediaQuery.of(context).size.width / 2.5,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            Text(
                              "HESAP DEĞİŞTİR",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.black87,
                            )
                          ],
                        ),
                      ),
                      buildTextButton(context, "OTURUM AÇMA SAYFASI"),
                    ],
                  ),
                ),
              );
            },
          );
        },
        icon: const Icon(Icons.filter_tilt_shift_rounded),
      ),
    );
  }

  Widget buildTextButton(BuildContext context, String buttonText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const SignInPage();
              },
            ));
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                side: const BorderSide(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AccounAddComponents(componentsText: buttonText),
          ),
        ),
      ),
    );
  }
}
