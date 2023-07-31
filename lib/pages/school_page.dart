// import 'package:flutter/material.dart';
//
// class SchoolPage extends StatelessWidget {
//   static const String id = 'school_page';
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.blue, Colors.white]),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: const Center(
//           child: Text('school page'),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SchoolPage extends StatelessWidget {
  static const String id = 'school_page';
  static const String address = 'Israel Tel Aviv Rabi Meir 12';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.white],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title Text
              Text(
                'School Page',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              // Address Text
              Text(
                'Address: $address',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              // Open Google Maps Button
              ElevatedButton(
                onPressed: () => openMap(),
                child: Text('Open Google Maps'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openMap() async {
    double latitude =
        32.0853; // Replace with the actual latitude of the location
    double longitude =
        34.7818; // Replace with the actual longitude of the location
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
