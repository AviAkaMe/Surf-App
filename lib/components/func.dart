import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void errorMessage(BuildContext context, String error) {
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
