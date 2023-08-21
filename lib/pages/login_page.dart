import 'package:b_surf/components/func.dart';
import 'package:b_surf/pages/reset_page.dart';
import 'package:b_surf/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:b_surf/components/text_box.dart';
import 'package:b_surf/components/button.dart';
import 'nav_page.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  void signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );

      Navigator.pop(context);
      Navigator.pushNamed(context, NavPage.id);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close the CircularProgressIndicator dialog
      errorMessage(context, e.code);
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
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      height: 150,
                      child: Image.asset('lib/images/BB.png'),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Image.asset('lib/images/BBB.png'),
                    ),
                    const SizedBox(height: 10),
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
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ResetPage.id);
                      },
                      child: Text(
                        'Forgot your password?',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Button(
                      text: 'Sign-In',
                      onTap: signIn,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignupPage.id);
                      },
                      child: Text(
                        'New to B-surf? ',
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
