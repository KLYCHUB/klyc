import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:klyc/pages/wall_post.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<QueryDocumentSnapshot>> _favoritePosts;

  @override
  void initState() {
    super.initState();
    _favoritePosts = _getFavoritePosts();
  }

  Future<void> _refreshFavoritePosts() async {
    setState(() {
      _favoritePosts = _getFavoritePosts();
    });
  }

  Future<List<QueryDocumentSnapshot>> _getFavoritePosts() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('User Post')
        .where('UserEmail', isEqualTo: currentUser.email)
        .get();

    return querySnapshot.docs;
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: RefreshIndicator(
        onRefresh: _refreshFavoritePosts,
        child: FutureBuilder<List<QueryDocumentSnapshot>>(
          future: _favoritePosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Colors.transparent,
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('NO FAVORITE POST FOUND.'),
              );
            } else {
              final favoritePosts = snapshot.data!;
              return ListView.builder(
                itemCount: favoritePosts.length,
                itemBuilder: (context, index) {
                  final post = favoritePosts[index];
                  return WallPost(
                    message: post['Message'],
                    user: post['UserEmail'],
                    postId: post.id,
                    likes: List<String>.from(post['Likes'] ?? []),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
