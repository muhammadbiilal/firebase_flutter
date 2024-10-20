// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutter/ui/auth/login_screen.dart';
import 'package:firebaseflutter/utils/utils.dart';
import 'package:firebaseflutter/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signUp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      _auth
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((result) {
        print('User registered successfully: ${result.user?.uid}');
        Fluttertoast.showToast(
          msg: 'User registered successfully: ${result.user?.uid}',
          backgroundColor: Colors.green,
        );
        // Navigator.pop(context);
        setState(() {
          loading = false;
        });
      }).catchError((error) {
        if (error is FirebaseAuthException) {
          print('Error code: ${error.code}');
          print('Error message: ${error.toString()}');
          Utils().toastMessgae(error.toString());
          // Fluttertoast.showToast(
          // msg: 'Error: ${error.message}',
          // backgroundColor: Colors.red,
          // );
        } else {
          print('Unexpected error: ${error.toString()}');
          // Fluttertoast.showToast(
          // msg: 'Unexpected error: ${error.toString()}',
          // backgroundColor: Colors.red,
          // );
          Utils().toastMessgae(error.toString());
        }
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        // suffixIcon: Icon(Icons.email)),
                        prefixIcon: Icon(Icons.alternate_email),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        // suffixIcon: Icon(Icons.email)),
                        prefixIcon: Icon(Icons.password_outlined),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                  ],
                )),
            const SizedBox(height: 50),
            RoundButton(
              title: 'Sign Up',
              loading: loading,
              onTap: () {
                signUp();
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  // style: TextStyle(color: Colors.deepPurple),
                ),
                // const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
