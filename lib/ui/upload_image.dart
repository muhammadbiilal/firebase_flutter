// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebaseflutter/firebase_services/auth_service.dart';
import 'package:firebaseflutter/ui/auth/login_screen.dart';
import 'package:firebaseflutter/utils/utils.dart';
import 'package:firebaseflutter/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');
  final auth = FirebaseAuth.instance;

  Future getGalleryImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        debugPrint('No images picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Upload Image Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              await AuthService().signOut(context: context);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: () {
                  getGalleryImage();
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : const Icon(Icons.image),
                ),
              ),
            ),
            const SizedBox(height: 20),
            RoundButton(
                title: 'Upload',
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  firebase_storage.Reference ref =
                      firebase_storage.FirebaseStorage.instance.ref(
                          '/foldername/${DateTime.now().millisecondsSinceEpoch}');

                  firebase_storage.UploadTask uploadTask =
                      ref.putFile(_image!.absolute);

                  await Future.value(uploadTask).then((value) async {
                    // Utils().toastMessgae('Post updated successfully!');
                    var newUrl = await ref.getDownloadURL();
                    databaseRef.child('1').set({
                      'id': '123456',
                      'title': newUrl.toString(),
                    }).then((value) {
                      Utils().toastMessgae('Post updated successfully!');
                      Navigator.pop(context);
                      setState(() {
                        loading = false;
                      });
                    }).onError((error, stackTrace) {
                      Utils().toastMessgae(error.toString());
                      Navigator.pop(context);
                      setState(() {
                        loading = false;
                      });
                    });
                  }).onError((error, stackTrace) {
                    Utils().toastMessgae(error.toString());
                  });
                }),
          ],
        ),
      ),
    );
  }
}
