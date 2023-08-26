// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:klyc/components/comment.dart';
import 'package:klyc/components/comment_button.dart';
import 'package:klyc/components/custom_button.dart';
import 'package:klyc/components/custom_button_2.dart';
import 'package:klyc/components/delete_button.dart';
import 'package:klyc/components/like_button.dart';
import 'package:klyc/components/my_textfield.dart';
import 'package:klyc/helper/helper_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  const WallPost({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  }) : super(key: key);

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
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
            content: const Text("Anonymous users don't like posts."),
            actions: [
              CustomButton2(
                  buttonTetxt: "OK",
                  onPressed: () => Navigator.of(context).pop())
            ],
          );
        },
      );
      return;
    }

    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Post').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email]),
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email]),
      });
    }
  }

  void addComment({required String commentText}) {
    if (currentUser.isAnonymous) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Anonim Kullanıcı"),
            content: const Text("Anonim kullanıcılar yorum yapamaz."),
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

    FirebaseFirestore.instance
        .collection("User Post")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });

    // Yorum eklendikten sonra, burada istediğiniz işlemleri yapabilirsiniz.
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (currentUser.isAnonymous) {
          return AlertDialog(
            title: Text(
              "Anonymous User",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
            ),
            content: const Text("Anonymous users cannot comment."),
            actions: [
              CustomButton2(
                  buttonTetxt: "OK",
                  onPressed: () => Navigator.of(context).pop())
            ],
          );
        }

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
                  "COMMENT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 30),
                MyTextField(
                  controller: _commentTextController,
                  hintText: "Write a Comment...",
                  obscureText: false,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  buttonTetxt: 'Add Comment',
                  onPressed: () {
                    addComment(commentText: _commentTextController.text);
                    Navigator.of(context).pop();
                    _commentTextController.clear();
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

  // Color _randomColor() {
  //   final random = Random();
  //   final red =
  //       random.nextInt(156) + 100; // 100-255 arasında rastgele kırmızı ton
  //   final green = random.nextInt(256);
  //   final blue = random.nextInt(256);
  //   return Color.fromARGB(255, red, green, blue);
  // }

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
                        .collection("User Post")
                        .doc(widget.postId)
                        .collection("Comments")
                        .get();

                    for (var doc in commentDocs.docs) {
                      print("Deleting comment: ${doc.id}");
                      await FirebaseFirestore.instance
                          .collection("User Post")
                          .doc(widget.postId)
                          .collection("Comments")
                          .doc(doc.id)
                          .delete();
                    }

                    print("Deleting post document: ${widget.postId}");
                    FirebaseFirestore.instance
                        .collection("User Post")
                        .doc(widget.postId)
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
    _commentTextController.dispose();
    super.dispose();
  }

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

    if (_commentTextController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Post").add({
        'UserEmail': currentUser.email,
        'Message': _commentTextController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    setState(() {
      _commentTextController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          widget.user.replaceFirst("@gmail.com", ""),
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                        const Spacer(),
                        if (widget.user == currentUser.email ||
                            currentUser.uid == "EolFFRYgUYTYZiFKQRb5jIX7Ope2")
                          DeleteButton(onTap: deletePost),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.message,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 50,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              LikeButton(isLiked: isLiked, onTap: toggleLike),
              const SizedBox(width: 5),
              Text(widget.likes.length.toString()),
              const SizedBox(width: 10),
              CommentButton(onTap: showCommentDialog),
              const SizedBox(width: 5),
              // ...
            ],
          ),
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User Post")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("No comments yet.");
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final commentData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return CommentPost(
                    text: commentData["CommentText"],
                    user: commentData["CommentBy"],
                    time: FormatData(commentData["CommentTime"]),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
