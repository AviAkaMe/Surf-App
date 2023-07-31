import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  static const String id = 'info_page';

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
        appBar: AppBar(
          title: Text(
            'A B O U T',
          ),
          backgroundColor: Colors.white70,
        ),
        backgroundColor: Colors.transparent,
        body: const Center(
          child: Text('Info page'),
        ),
      ),
    );
  }
}
