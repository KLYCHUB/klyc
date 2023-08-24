import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:klyc/pages/tab.dart';

class AuthServices {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp(BuildContext context,
      {required String name,
      required String email,
      required String password}) async {
    final navigator = Navigator.of(context);
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        registerUser(name: name, email: email, password: password);
        // ignore: use_build_context_synchronously
        navigator.push(MaterialPageRoute(
          builder: (context) {
            return const TabPage();
          },
        ));
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> registerUser(
      {required String name,
      required String email,
      required String password}) async {
    await userCollection.doc().set({
      "name": name,
      "email": email,
      "password": password,
    });
  }

  Future<void> signIn(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    final navigator = Navigator.of(context);
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        // ignore: use_build_context_synchronously
        navigator.push(MaterialPageRoute(
          builder: (context) {
            return const TabPage();
          },
        ));
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<User?> signInWithGoogle() async {
    // Oturum açma süreci
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // Süreç  içerisinden bilgileri al
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // Kullanıcı nesnesini oluştur
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    // kullanıcı girişini sağla
    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);

    return userCredential.user;
  }

  Future<User?> signInAnonymously() async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInAnonymously();
      if (userCredential.user != null) {
        // Hesap oluşturulduğunda yapılacak işlemler
        return userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
    return null;
  }

  Future<UserCredential> signInWithMicrosoft() async {
    final microsoftProvider = MicrosoftAuthProvider();
    UserCredential userCredential;

    if (kIsWeb) {
      userCredential =
          await FirebaseAuth.instance.signInWithPopup(microsoftProvider);
    } else {
      userCredential =
          await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
    }

    return userCredential;
  }
}
