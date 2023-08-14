import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> locate(String collectionName, String documentId) async {
  GeoPoint? cords = await getCoordinates(collectionName, documentId);
  if (cords != null) {
    double latitude = cords.latitude;
    double longitude = cords.longitude;
    openGoogleMaps(latitude, longitude);
  } else {
    // Handle case when coordinates are not available
  }
}

Future<GeoPoint?> getCoordinates(
    String collectionName, String documentId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(collectionName)
        .doc(documentId)
        .get();

    if (snapshot.exists) {
      GeoPoint? cords = snapshot.data()?['cords'] as GeoPoint?;
      return cords;
    }
    return null;
  } catch (error) {
    print("Error retrieving coordinates: $error");
    return null;
  }
}

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
