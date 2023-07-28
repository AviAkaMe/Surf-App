import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home_page';

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
        body: Center(
          child: Container(
            width: 50,
            child: Text(''' General information about the field of kite surfing:
 Kitesurfing \ KiteSurfing is an extreme marine sport,
 where the surfer is connected to a large kite and generates power with the help of the wind,
 which is used for surfing on the water using a special surfboard.
 It is one of the most developed water sports today.
 The surfer generates gravity with the help of the kite which is attached to the surfer's body
 using a special harness called a trapeze.
 Kite surfing is considered a relatively easy sport from a physical point of view
 Since the control of the kite is technical and does not require much effort.
 The technique is acquired in the Kite Surfing course which is taught in addition to the theory
 and safety instructions also the correct control of the kite.'''),
          ),
        ),
      ),
    );
  }
}
