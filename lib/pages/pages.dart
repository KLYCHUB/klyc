import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:klyc/components/custom_button.dart';
import 'package:klyc/components/custom_button_2.dart';
import 'package:klyc/components/drawer_photo.dart';
import 'package:klyc/components/my_textfield.dart';
import 'package:klyc/pages/photo_ai_make.dart';
import 'package:klyc/pages/wall_post.dart';
import '../components/account_add_login.dart';
import '../components/account_name.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Future<bool> _onWillPop() async {
    return false;
  }

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController = TextEditingController();

  // sign user out
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // post message
  void postMessage() {
    if (currentUser.isAnonymous) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Anonim Kullanıcı"),
            content: const Text("Anonim kullanıcılar gönderi yapamaz."),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Tamam"),
              ),
            ],
          );
        },
      );
      return;
    }

    if (textController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Boş Mesaj"),
            content: const Text("Lütfen bir mesaj giriniz."),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Tamam"),
              ),
            ],
          );
        },
      );
      return;
    }

    FirebaseFirestore.instance.collection("User Post").add({
      'UserEmail': currentUser.email,
      'Message': textController.text,
      'TimeStamp': Timestamp.now(),
      'Likes': [],
    });

    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        drawer: SafeArea(
          child: Drawer(
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
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              // Your refresh logic here
            });
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // the wall
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("User Post")
                        .orderBy("TimeStamp", descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final post = snapshot.data!.docs[index];
                            return WallPost(
                              message: post['Message'] ??
                                  "", // Use an empty string if 'Message' is null
                              user: post['UserEmail'] ??
                                  "", // Use an empty string if 'UserEmail' is null
                              postId: post.id,
                              likes: List<String>.from(post['Likes'] ?? []),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),

                //Text("Logged in as: ${currentUser.email!}"),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomAppBar(
          elevation: 0,
          shape: CircularNotchedRectangle(), // veya BottomAppBar içeriği
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            if (currentUser.isAnonymous) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Anonymous User",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                    ),
                    content: const Text("Anonymous users do not share posts."),
                    actions: [
                      CustomButton2(
                          buttonTetxt: "OK",
                          onPressed: () => Navigator.of(context).pop())
                    ],
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "SHARE POST",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 30),
                          MyTextField(
                            controller: textController,
                            hintText: "Write something on the wall",
                            obscureText: false,
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                            buttonTetxt: "Post",
                            onPressed: () {
                              postMessage(); // Veri gönderme işlemini tetikle
                              Navigator.of(context).pop(); // Dialogu kapat
                            },
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
