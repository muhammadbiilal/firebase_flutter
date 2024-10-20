import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutter/firebase_services/auth_service.dart';
import 'package:firebaseflutter/ui/auth/verify_code.dart';
import 'package:firebaseflutter/utils/utils.dart';
import 'package:firebaseflutter/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Login'),
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
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '+1 234 3455 234',
                      // suffixIcon: Icon(Icons.email)),
                      // prefixIcon: Icon(Icons.alternate_email),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),
                  RoundButton(
                    title: 'Login',
                    loading: loading,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        // login();
                        setState(() {
                          loading = true;
                        });
                        // await AuthService().signin(
                        // email: emailController.text,
                        // password: passwordController.text,
                        // context: context);
                        _auth.verifyPhoneNumber(
                          phoneNumber: phoneNumberController.text,
                          verificationCompleted: (_) {},
                          verificationFailed: (e) {
                            Utils().toastMessgae(e.toString());
                          },
                          codeSent: (String verificationId, int? token) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VerifyCodeScreen(
                                          verificationId: verificationId,
                                        )));
                          },
                          codeAutoRetrievalTimeout: (e) {
                            Utils().toastMessgae(e.toString());
                          },
                        );
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
