// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebaseflutter/ui/auth/login_screen.dart';
import 'package:firebaseflutter/ui/posts/add_posts.dart';
import 'package:firebaseflutter/utils/utils.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          // FirebaseAnimatedList for data fetching and rendering
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              defaultChild: const Text('Loading...'),
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('title').value.toString();
                if (searchFilter.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          onTap: () {
                            // Navigator.pop(context);
                            showUpdateDialog(
                                title, snapshot.child('id').value.toString());
                          },
                          child: const ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Edit'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          onTap: () {
                            // Navigator.pop(context);
                            // showUpdateDialog(snapshot.child('title').value.toString());
                            showDeleteDialog(
                                snapshot.child('id').value.toString());
                          },
                          child: const ListTile(
                            leading: Icon(Icons.delete_outline),
                            title: Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(searchFilter.text.toLowerCase())) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          // firebase with streambuilder for real-time updates
          // Expanded(
          //   child: StreamBuilder(
          //     stream: ref.onValue,
          //     builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         // Show loading indicator while waiting for data
          //         return const Center(child: CircularProgressIndicator());
          //       }

          //       if (!snapshot.hasData ||
          //           snapshot.data!.snapshot.value == null) {
          //         // Return a message or an empty widget if there is no data
          //         return const Center(child: Text('No data available'));
          //       }

          //       Map<dynamic, dynamic> map =
          //           snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          //       List<dynamic> list = map.values.toList();

          //       return ListView.builder(
          //         itemCount: list.length,
          //         itemBuilder: (context, index) {
          //           return ListTile(
          //             title: Text(list[index]['title'] as String),
          //             subtitle: Text(list[index]['id'] as String),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
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

  Future<void> showUpdateDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              controller: editController,
              decoration: const InputDecoration(
                hintText: 'Edit',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  ref.child(id).update(
                    {'title': editController.text.toLowerCase()},
                  ).then((value) {
                    Utils().toastMessgae('Post updated successfully!');
                    Navigator.pop(context);
                  }).onError((error, stackTrace) {
                    Utils().toastMessgae(error.toString());
                    Navigator.pop(context);
                  });
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }

  Future<void> showDeleteDialog(String id) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  ref.child(id).remove().then((value) {
                    Utils().toastMessgae('Post deleted successfully!');
                    Navigator.pop(context);
                  }).onError((error, stackTrace) {
                    Utils().toastMessgae(error.toString());
                    Navigator.pop(context);
                  });
                },
                child: const Text('Delete'),
              ),
            ],
          );
        });
  }


}
