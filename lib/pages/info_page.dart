import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  static const String id = 'info_page';

  void singUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: singUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: const Center(
        child: Text('info page'),
      ),
    );
  }
}
