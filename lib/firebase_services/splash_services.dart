import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutter/ui/auth/login_screen.dart';
import 'package:firebaseflutter/ui/upload_image.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(
        const Duration(seconds: 1),
        () => Navigator.push(
          context,
          // MaterialPageRoute(builder: (context) => const PostScreen()),
          // MaterialPageRoute(builder: (context) => const FireStoreScreen()),
          MaterialPageRoute(builder: (context) => const UploadImageScreen()),
        ),
      );
    } else {
      Timer(
        const Duration(seconds: 1),
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        ),
      );
    }
  }
}
