// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseflutter/utils/utils.dart';
import 'package:firebaseflutter/widgets/round_button.dart';
import 'package:flutter/material.dart';

class FireStoreAddPostScreen extends StatefulWidget {
  const FireStoreAddPostScreen({super.key});

  @override
  State<FireStoreAddPostScreen> createState() => _FireStoreAddPostScreenState();
}

class _FireStoreAddPostScreenState extends State<FireStoreAddPostScreen> {
  bool loading = false;
  final postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Firestore Add Post Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "What's in your mind?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            RoundButton(
              title: "Add",
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                fireStore.doc(id).set({
                  'title': postController.text.toString(),
                  'id': id,
                }).then((value) {
                  postController.clear();
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessgae(error.toString());
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
