import 'package:flutter/material.dart';

class WindPage extends StatelessWidget {
  static const String id = 'wind_page';

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
          child: Text('wind page'),
        ),
      ),
    );
  }
}
