import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:klyc/components/custom_button.dart';
import 'package:klyc/components/my_textfield.dart';
import 'package:klyc/pages/wall_post_admin.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Future<bool> _onWillPop() async {
    return false;
  }

  // user
  final currentUser2 = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController2 = TextEditingController();
  final textController2content = TextEditingController();

  // sign user out
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // post message
  void postMessage() {
    if (textController2.text.isEmpty) {
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

    FirebaseFirestore.instance.collection("User Post 2").add({
      'UserEmail2': currentUser2.email,
      'Message2': textController2.text,
      'TimeStamp2': Timestamp.now(),
      'content': textController2content.text,
    });

    setState(() {
      textController2.clear();
      textController2content.clear();
    });
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
            children: [
              // the wall
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("User Post 2")
                      .orderBy("TimeStamp2", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index];
                          return WallPostAdmin(
                            message2: post['Message2'] ?? "",
                            user2: post['UserEmail2'] ?? "",
                            postId2: post.id,
                            content: post['content'] ?? "",
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

              //Text("Logged in as: ${currentUser2.email!}"),
            ],
          ),
        ),
        bottomNavigationBar: const BottomAppBar(
          elevation: 0,
          shape: CircularNotchedRectangle(),
        ),
        floatingActionButton: currentUser2.uid == "EolFFRYgUYTYZiFKQRb5jIX7Ope2"
            ? FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () {
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
                                  controller: textController2,
                                  hintText: "BAŞLIK",
                                  obscureText: false),
                              const SizedBox(height: 30),
                              MyTextField(
                                  controller: textController2content,
                                  hintText: "AÇIKLAMA",
                                  obscureText: false),
                              const SizedBox(height: 30),
                              CustomButton(
                                buttonTetxt: "Post",
                                onPressed: () {
                                  postMessage();
                                  Navigator.of(context).pop();
                                },
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
              )
            : Container(),
      ),
    );
  }
}
