import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:b_surf/components/text_box.dart';
import 'package:b_surf/components/button.dart';

class SignupPage extends StatefulWidget {
  final Function()? onTap;
  const SignupPage({super.key, required this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confController = TextEditingController();

  void signUp() async {
    if (passController.text != confController.text) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Password Mismatch'),
            content: Text(
                'The passwords you entered do not match. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
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
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passController.text,
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        errorMessage(e.code);
      }
    }
  }

  void errorMessage(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(error),
          ),
        );
      },
    );
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Login Now',
                            style: TextStyle(
                              color: Colors.pink,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
