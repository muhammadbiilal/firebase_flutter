// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutter/ui/posts/post_screen.dart';
import 'package:firebaseflutter/utils/utils.dart';
import 'package:firebaseflutter/widgets/round_button.dart';
import 'package:flutter/material.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;

  const VerifyCodeScreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final verifyCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Verify'),
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  TextFormField(
                    controller: verifyCodeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      hintText: '6 digit code',
                      // suffixIcon: Icon(Icons.email)),
                      // prefixIcon: Icon(Icons.alternate_email),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Code is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),
                  RoundButton(
                    title: 'Verify',
                    loading: loading,
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });
                      final credential = PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: verifyCodeController.text);

                      try {
                        await _auth.signInWithCredential(credential);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PostScreen()));
                      } catch (e) {
                        debugPrint(e.toString());
                        Utils().toastMessgae(e.toString());
                      }
                      setState(() {
                        loading = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
