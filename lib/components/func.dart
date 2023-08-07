import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void openGoogleMaps(double latitude, double longitude) async {
  String url =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

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
