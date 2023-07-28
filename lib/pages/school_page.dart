import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SchoolPage extends StatelessWidget {
  static const String id = 'school_page';

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
          child: Text('school page'),
        ),
      ),
    );
  }
}
