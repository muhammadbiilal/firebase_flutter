// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebaseflutter/ui/auth/login_screen.dart';
import 'package:firebaseflutter/ui/posts/add_posts.dart';
import 'package:firebaseflutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Post Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              // await AuthService().signOut(context: context);
              auth.signOut().then((result) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }).onError((error, stackTrace) {
                Utils().toastMessgae(error.toString());
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // FirebaseAnimatedList for data fetching and rendering
          // Expanded(
          // child: FirebaseAnimatedList(
          // query: ref,
          // defaultChild: const Text('Loading...'),
          // itemBuilder: (context, snapshot, animation, index) {
          // return ListTile(
          // title: Text(snapshot.child('title').value.toString()),
          // );
          // },
          // ),
          // ),
          // firebase with streambuilder for real-time updates
          Expanded(
            child: StreamBuilder(
              stream: ref.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                Map<dynamic, dynamic> map =
                    snapshot.data!.snapshot.value as dynamic;
                List<dynamic> list = [];
                list.clear();
                list = map.values.toList();
                if (!snapshot.hasData) return const SizedBox.shrink();
                return ListView.builder(
                  itemCount: snapshot.data!.snapshot.children.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(list[index]['title'] as String),
                      subtitle: Text(list[index]['id'] as String),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
