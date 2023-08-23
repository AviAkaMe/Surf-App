// import 'package:flutter/material.dart';
//
// class WindPage extends StatefulWidget {
//   static const String id = 'wind_page';
//
//   @override
//   _WindPageState createState() => _WindPageState();
// }
//
// class _WindPageState extends State<WindPage> {
//   String _selectedValue = '0:30';
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Colors.blue, Colors.white],
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.wind_power,
//                 size: 125,
//                 color: Colors.black,
//               ),
//               SizedBox(height: 30),
//               Text(
//                 'Please select Max Drive Time: ',
//                 style: TextStyle(fontSize: 15),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 10),
//               DropdownButton<String>(
//                 value: _selectedValue,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedValue = newValue!;
//                   });
//                 },
//                 items: <String>[
//                   '0:30',
//                   '1:00',
//                   '1:30',
//                   '2:00',
//                   '2:30',
//                   '3:00',
//                   '3:30',
//                   '4:00',
//                   '4:30',
//                   '5:00',
//                   '5:30',
//                   '6:00',
//                 ].map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   // Add your logic here for the button press
//                 },
//                 style: ElevatedButton.styleFrom(
//                   minimumSize:
//                       Size(200, 60), // Set the minimum size of the button
//                   // You can customize other properties here as well, such as background color, etc.
//                 ),
//                 child: Text(
//                   'Find The Wind',
//                   style:
//                       TextStyle(fontSize: 20), // Adjust the font size if needed
//                 ),
//               ),
//               SizedBox(height: 20),
//               Container(
//                 width: 350,
//                 height: 125,
//                 color: Colors.deepOrange,
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class WindPage extends StatefulWidget {
  static const String id = 'wind_page';

  @override
  _WindPageState createState() => _WindPageState();
}

class _WindPageState extends State<WindPage> {
  String _selectedValue = '0:30';

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
      }
    } else if (permission == LocationPermission.deniedForever) {
      // The user has permanently denied location permissions.
      // Handle this case gracefully, possibly by displaying a dialog.
    } else {
      // Permission already granted. You can proceed to get the user's location.
      Position position = await Geolocator.getCurrentPosition();
      // Now you can send this location to your cloud app.
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.wind_power,
                size: 125,
                color: Colors.black,
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
                  await checkAndRequestLocationPermission();
                },
                child: Text(
                  'Find The Wind',
                  style:
                      TextStyle(fontSize: 20), // Adjust the font size if needed
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 350,
                height: 125,
                color: Colors.deepOrange,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
