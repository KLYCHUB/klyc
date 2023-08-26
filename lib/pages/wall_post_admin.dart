// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:klyc/components/custom_button_2.dart';
import 'package:klyc/components/delete_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WallPostAdmin extends StatefulWidget {
  final String message2;
  final String user2;
  final String postId2;
  final String content;

  const WallPostAdmin({
    Key? key,
    required this.message2,
    required this.user2,
    required this.postId2,
    required this.content,
  }) : super(key: key);

  @override
  State<WallPostAdmin> createState() => _WallPostState();
}

class _WallPostState extends State<WallPostAdmin> {
  final currentUser2 = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
  }

  void deletePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "DELETE",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        content: const Text("Are you sure you want to delete?",
            textAlign: TextAlign.center),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                CustomButton2(
                  buttonTetxt: "Cancel",
                  onPressed: () => Navigator.pop(context),
                ),
                CustomButton2(
                  buttonTetxt: "Delete",
                  onPressed: () async {
                    print("Deleting post...");

                    final commentDocs = await FirebaseFirestore.instance
                        .collection("User Post 2")
                        .doc(widget.postId2)
                        .collection("Comments2")
                        .get();

                    for (var doc in commentDocs.docs) {
                      print("Deleting comment: ${doc.id}");
                      await FirebaseFirestore.instance
                          .collection("User Post 2")
                          .doc(widget.postId2)
                          .collection("Comments2")
                          .doc(doc.id)
                          .delete();
                    }

                    print("Deleting post document: ${widget.postId2}");
                    FirebaseFirestore.instance
                        .collection("User Post 2")
                        .doc(widget.postId2)
                        .delete()
                        .then((value) => print("Post deleted"))
                        .catchError(
                            (error) => print("Failed to delete post: $error"));

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void postMessage() {
    if (currentUser2.isAnonymous) {
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
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.user2.replaceFirst("@gmail.com", ""),
                            style: const TextStyle(color: Colors.blueGrey),
                          ),
                          const Spacer(),
                          if (widget.user2 == currentUser2.email ||
                              currentUser2.uid ==
                                  "EolFFRYgUYTYZiFKQRb5jIX7Ope2")
                            DeleteButton(onTap: deletePost),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.message2.toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.content.toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 50,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
