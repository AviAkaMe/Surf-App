import 'package:flutter/material.dart';
import '../components/ExplanationPopup.dart';
import '../components/func.dart';
import 'info_page.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home_page';

  void _showExplanation(BuildContext context) {
    ExplanationPopup.show(
      context: context,
      pageName: 'עמוד הבית',
      message: [
        {Icons.wind_power: 'עמוד חיפוש רוח'},
        {Icons.kitesurfing: 'עמוד התאמת קייט'},
        {Icons.home: 'עמוד הבית'},
        {Icons.beach_access: 'עמוד החופים'},
        {Icons.school: 'עמוד בתי הספר'},
      ],
      prefsKey: 'showExplanation_HomePage',
    );
  }

  @override
  Widget build(BuildContext context) {
    _showExplanation(context); // Call the explanation method
    return Container(
      decoration: gradientBoxDecoration, // Apply the gradientBoxDecoration
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Stack(children: [
          SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  height: 150,
                  child: Image.asset('lib/images/BBB.png'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    '''
קייט סרפינג הוא ספורט אקסטרים ימי שבו הגולש מחובר לעפיפון גדול ומייצר כוח בעזרת הרוח מדובר באחד מענפי הספורט הימי המפותחים ביותר כיום
קייט סרפינג נחשב לספורט קל יחסית מבחינה פיזית מאחר והשליטה בעפיפון היא טכנית ולא דורשת מאמץ רב
את הטכניקה רוכשים בקורס קייט סרפינג אשר מלמד בנוסף לתאוריה והוראות בטיחות גם את השליטה הנכונה בקייט''',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, InfoPage.id); // nav to the info page
                  },
                  child: Text(
                    'למידע נוסף וסרטונים לחץ כאן',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    ExplanationPopup.resetFlags();
                  },
                  child: Text(
                    'לאתחול הוראות שימוש',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              onPressed: () {
                signOut();
                Navigator.pushNamed(context, LoginPage.id);
              },
              icon: Icon(Icons.logout, size: 30, color: Color(0xFF214C94)),
            ),
          ),
        ])),
      ),
    );
  }
}
