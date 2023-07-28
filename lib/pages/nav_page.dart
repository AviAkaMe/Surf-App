// import 'package:b_surf/pages/school_page.dart';
// import 'package:b_surf/pages/spots_page.dart';
// import 'package:b_surf/pages/wind_page.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'home_page.dart';
// import 'kite_page.dart';
//
// class NavPage extends StatefulWidget {
//   static const String id = 'nav_page';
//
//   @override
//   _NavPageState createState() => _NavPageState();
// }
//
// class _NavPageState extends State<NavPage> {
//   int _currentIndex = 2;
//
//   final List<Widget> _pages = [
//     WindPage(),
//     KitePage(),
//     HomePage(),
//     SpotsPage(),
//     SchoolPage(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Colors.blue, Colors.white],
//               ),
//             ),
//             child: Center(
//               child: _pages[_currentIndex],
//             ),
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: CurvedNavigationBar(
//               color: Colors.white38,
//               backgroundColor: Colors.transparent,
//               index: _currentIndex,
//               onTap: (index) {
//                 setState(() {
//                   _currentIndex = index;
//                 });
//               },
//               items: [
//                 Icon(Icons.wind_power, size: 30),
//                 Icon(Icons.kitesurfing, size: 30),
//                 Icon(Icons.home, size: 30),
//                 Icon(Icons.beach_access, size: 30),
//                 Icon(Icons.school, size: 30),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:b_surf/pages/school_page.dart';
import 'package:b_surf/pages/settings_page.dart';
import 'package:b_surf/pages/spots_page.dart';
import 'package:b_surf/pages/wind_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'kite_page.dart';
import 'login_page.dart';

class NavPage extends StatefulWidget {
  static const String id = 'nav_page';

  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _currentIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    WindPage(),
    KitePage(),
    HomePage(),
    SpotsPage(),
    SchoolPage(),
  ];

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Your App Title"), // Add your app title here
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
        backgroundColor:
            Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the shadow from the AppBar
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.white],
            ),
          ),
        ),
        // Add any other properties you want for the AppBar
      ),
      drawer: Drawer(
        // Add your drawer content here
        child: Container(
          color: Colors.white70,
          child: ListView(
            children: [
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.surfing,
                    size: 100,
                  ),
                  // child: Text(
                  //   "M E N U",
                  //   style: TextStyle(fontSize: 40),
                  // ),
                ),
              ),
              ListTile(
                title: Text(
                  "Settings Page",
                  style: TextStyle(fontSize: 20),
                ),
                leading: Icon(Icons.settings),
                onTap: () {
                  Navigator.pushNamed(context, SettingsPage.id);
                },
              ),
              ListTile(
                title: Text(
                  "Info Page",
                  style: TextStyle(fontSize: 20),
                ),
                leading: Icon(Icons.info),
                onTap: () {
                  Navigator.pushNamed(context, SettingsPage.id);
                },
              ),
              ListTile(
                title: Text(
                  "Sign out",
                  style: TextStyle(fontSize: 20),
                ),
                leading: Icon(Icons.logout),
                onTap: () {
                  _signOut();
                  Navigator.pushNamed(context, LoginPage.id);
                },
              ),
              // Add more ListTiles for other navigation options
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Removed the Container with gradient from here
                Center(
                  child: _pages[_currentIndex],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CurvedNavigationBar(
                    color: Colors.white38,
                    backgroundColor: Colors.transparent,
                    index: _currentIndex,
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    items: [
                      Icon(Icons.wind_power, size: 30),
                      Icon(Icons.kitesurfing, size: 30),
                      Icon(Icons.home, size: 30),
                      Icon(Icons.beach_access, size: 30),
                      Icon(Icons.school, size: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    // You can also add additional code here if needed after signing out
  } catch (e) {
    print("Error signing out: $e");
  }
}
