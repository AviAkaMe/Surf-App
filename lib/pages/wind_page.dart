import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WindPage extends StatefulWidget {
  static const String id = 'wind_page';

  @override
  _WindPageState createState() => _WindPageState();
}

class _WindPageState extends State<WindPage> {
  String _selectedValue = '0:30';
  List<String> _windLines = []; // Declare _helloLines here
  Position? _userLocation; // Add this variable to store user's location

  Future<void> checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.deniedForever) {
        // The user has permanently denied location permissions.
        // Handle this case gracefully, possibly by displaying a dialog.
      } else if (permission == LocationPermission.denied) {
        // The user denied location permissions.
        // You can display a message or request permissions again.
      } else {
        // Permission granted. You can proceed to get the user's location.
        Position position = await Geolocator.getCurrentPosition();
        // Now you can send this location to your cloud app.
        setState(() {
          _userLocation = position;
        });
      }
    } else if (permission == LocationPermission.deniedForever) {
      // The user has permanently denied location permissions.
      // Handle this case gracefully, possibly by displaying a dialog.
    } else {
      // Permission already granted. You can proceed to get the user's location.
      Position position = await Geolocator.getCurrentPosition();
      // Now you can send this location to your cloud app.
      setState(() {
        _userLocation = position;
      });
    }
  }

  Future<void> fetchSpotsWind(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        final List<String> windLines = jsonResponse.cast<String>();

        print('Wind Lines:');
        print(windLines);

        setState(() {
          _windLines = windLines;
        });
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('lib/images/windy.jpg'),
                    radius: 120,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Please select Max Drive Time: ',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: _selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedValue = newValue!;
                    });
                  },
                  items: <String>[
                    '0:30',
                    '1:00',
                    '1:30',
                    '2:00',
                    '2:30',
                    '3:00',
                    '3:30',
                    '4:00',
                    '4:30',
                    '5:00',
                    '5:30',
                    '6:00',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(200, 60), // Set the minimum size of the button
                    // You can customize other properties here as well, such as background color, etc.
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    await checkAndRequestLocationPermission();
                    final latitude = _userLocation?.latitude;
                    final longitude = _userLocation?.longitude;
                    // Get the current user
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final uid =
                          user.uid; // Get the UID of the authenticated user
                      final url =
                          'https://us-central1-b-surf.cloudfunctions.net/findSpotsWind?value=$_selectedValue&latitude=$latitude&longitude=$longitude&uid=$uid';
                      await fetchSpotsWind(url);
                    } else {
                      // Handle the case where the user is not authenticated
                      // You may want to show an error message or navigate to a login screen
                    }
                    Navigator.pop(context); // Close the loading dialog
                  },
                  child: Text(
                    'Find The Wind',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.blueAccent)),
                  child: Column(
                    children: _windLines
                        .map(
                          (line) => Text(
                            line,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
