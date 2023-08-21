import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  static const String id = 'settings_page';

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
          backgroundColor: Colors.grey[300],
          elevation: 0,
          title: Text(
            'A B O U T',
            style: TextStyle(color: Colors.grey[800]),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: const Center(
          child: Text('Settings page'),
        ),
      ),
    );
  }
}
