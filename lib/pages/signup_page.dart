import 'package:b_surf/components/func.dart';
import 'package:b_surf/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:b_surf/components/text_box.dart';
import 'package:b_surf/components/button.dart';

class SignupPage extends StatefulWidget {
  static const String id = 'signup_page';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confController = TextEditingController();

  bool isPasswordStrong(String password) {
    return password.length >= 6 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }

  void signUp() async {
    if (passController.text != confController.text) {
      showDialog(
          context: context,
          builder: (context) {
            return Container(
              child: AlertDialog(
                title: Text('Password Mismatch'),
              ),
            );
          });
    } else if (!isPasswordStrong(passController.text)) {
      showDialog(
        context: context,
        builder: (context) {
          return Container(
            child: AlertDialog(
              title: Text(
                  'The Password needs to be atleast 6 letters length with numbers capital letters and small letters'),
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      //     try {
      //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //         email: emailController.text,
      //         password: passController.text,
      //       );
      //
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => LoginPage()),
      //       );
      //     } on FirebaseAuthException catch (e) {
      //       Navigator.pop(context);
      //       errorMessage(context, e.code);
      //     }
      //   }
      // }
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passController.text,
        );

        // Create a user document in the "users" collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'favoriteSpot': 'none', // Initialize with null or empty
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        errorMessage(context, e.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.white]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome new Surfer! ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextBox(
                      controller: emailController,
                      hint: ' Email Address',
                      secret: false,
                    ),
                    const SizedBox(height: 10),
                    TextBox(
                      controller: passController,
                      hint: ' Password',
                      secret: true,
                    ),
                    const SizedBox(height: 10),
                    TextBox(
                      controller: confController,
                      hint: ' Confirm Password',
                      secret: true,
                    ),
                    const SizedBox(height: 10),
                    Button(
                      text: 'Sign-Up',
                      onTap: signUp,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginPage.id);
                      },
                      child: Text(
                        'Already have an account? ',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
