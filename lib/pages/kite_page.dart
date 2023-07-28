import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class KitePage extends StatelessWidget {
  static const String id = 'kite_page';

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
        body: const Center(
          child: Text('kite page'),
        ),
      ),
    );
  }
}
