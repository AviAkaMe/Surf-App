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

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class SettingsPage extends StatefulWidget {
//   static const String id = 'settings_page';
//
//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }
//
// class _SettingsPageState extends State<SettingsPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String? selectedLocation;
//   List<String> locationNames = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchLocationNames();
//   }
//
//   Future<void> fetchLocationNames() async {
//     QuerySnapshot querySnapshot =
//         await _firestore.collection('locations').get();
//     setState(() {
//       locationNames =
//           querySnapshot.docs.map((doc) => doc['name'] as String).toList();
//     });
//   }
//
//   void saveFavoriteSpot() async {
//     if (selectedLocation != null) {
//       String userUid =
//           FirebaseAuth.instance.currentUser!.uid; // Get the current user's UID
//
//       // Check if the user already exists in the 'users' collection
//       DocumentSnapshot userSnapshot =
//           await _firestore.collection('users').doc(userUid).get();
//
//       if (userSnapshot.exists) {
//         // Update the favorite spot for an existing user
//         await _firestore.collection('users').doc(userUid).update({
//           'favoriteSpot': selectedLocation,
//         });
//       } else {
//         // Create a new document for a new user
//         await _firestore.collection('users').doc(userUid).set({
//           'favoriteSpot': selectedLocation,
//         });
//       }
//
//       // Show a success message or perform any other action you want
//
//       // Clear the selected location after saving
//       setState(() {
//         selectedLocation = null;
//       });
//     }
//   }
//
//   Future<void> removeUser() async {
//     String userUid = FirebaseAuth.instance.currentUser!.uid;
//
//     // Delete the user's document from the "users" collection
//     await _firestore.collection('users').doc(userUid).delete();
//
//     // Show a success message or perform any other action you want
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text('User removed.'),
//     ));
//   }
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
//         appBar: AppBar(
//           backgroundColor: Colors.grey[300],
//           elevation: 0,
//           title: Text(
//             'A B O U T',
//             style: TextStyle(color: Colors.grey[800]),
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Selected Location: ${selectedLocation ?? 'None'}',
//                 style: TextStyle(fontSize: 18),
//               ),
//               const SizedBox(height: 20),
//               DropdownButton<String>(
//                 value: selectedLocation,
//                 onChanged: (newValue) {
//                   setState(() {
//                     selectedLocation = newValue;
//                   });
//                 },
//                 items: locationNames.map((locationName) {
//                   return DropdownMenuItem<String>(
//                     value: locationName,
//                     child: Text(locationName),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: saveFavoriteSpot,
//                 child: Text('Save Favorite Spot'),
//               ),
//               // Inside the build method, after the save button
//               ElevatedButton(
//                 onPressed: removeUser,
//                 style: ElevatedButton.styleFrom(primary: Colors.red),
//                 child: Text('Remove User'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
