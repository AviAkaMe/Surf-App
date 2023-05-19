import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//TODO everything :)

//TODO everything else :)

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Center(
          child: Column(children: [
            Text(
              'B-Surf',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ]),
        ),
      ),
    );
  }
}
