import 'package:b_surf/pages/settings_page.dart';
import 'package:b_surf/pages/info_page.dart';
import 'package:b_surf/pages/kite_page.dart';
import 'package:b_surf/pages/nav_page.dart';
import 'package:b_surf/pages/school_page.dart';
import 'package:b_surf/pages/spots_page.dart';
import 'package:b_surf/pages/wind_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:b_surf/pages/login_page.dart';
import 'package:b_surf/pages/home_page.dart';
import 'package:b_surf/pages/signup_page.dart';
import 'package:b_surf/pages/reset_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        HomePage.id: (context) => HomePage(),
        SignupPage.id: (context) => SignupPage(),
        ResetPage.id: (context) => ResetPage(),
        SpotsPage.id: (context) => SpotsPage(),
        KitePage.id: (context) => KitePage(),
        InfoPage.id: (context) => InfoPage(),
        WindPage.id: (context) => WindPage(),
        SchoolPage.id: (context) => SchoolPage(),
        NavPage.id: (context) => NavPage(),
        SettingsPage.id: (context) => SettingsPage(),
      },
    );
  }
}
