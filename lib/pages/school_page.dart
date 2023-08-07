import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/func.dart';

class SchoolPage extends StatefulWidget {
  static const String id = 'school_page';
  @override
  State<SchoolPage> createState() => _SchoolPage();
}

class _SchoolPage extends State<SchoolPage> {
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.fromLTRB(8.0, 4.0, 0, 0.0),
          child: Container(
            margin: EdgeInsets.fromLTRB(50, 10, 50, 0),
            child: Column(
              children: [
                InkWell(
                  onTap: () =>
                      openGoogleMaps(32.16983071870699, 34.798568690029846),
                  child: Container(
                    height: 200,
                    width: 300,
                    child: Image.asset(
                      'lib/images/asabro.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'אקסטרים - האחים אסא  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: בית ינאי, אילת  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: בית ינאי, אילת  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                CallButton(phoneNumber: '1700555170'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      openGoogleMaps(32.16983071870699, 34.798568690029846),
                  child: Container(
                    height: 100,
                    width: 300,
                    child: Image.asset('lib/images/surfcenter.png',
                        fit: BoxFit.fill),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'סרף סנטר \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: חוף הריף-רף אילת\n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: אילת \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                CallButton(phoneNumber: '086371602'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      openGoogleMaps(32.16983071870699, 34.798568690029846),
                  child: Container(
                    height: 200,
                    width: 300,
                    child: Image.asset(
                      'lib/images/sunshine.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'סאנשיין  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: עתלית  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: עתלית, מעיין צבי  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                CallButton(phoneNumber: '0525526111'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      openGoogleMaps(32.16983071870699, 34.798568690029846),
                  child: Container(
                    height: 200,
                    width: 300,
                    child: Image.asset(
                      'lib/images/IKS.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'IKS -עידן קפלן  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: חוף פולג  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: חוף פולג  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                CallButton(phoneNumber: '0506544450'),
                SizedBox(height: 30),
                InkWell(
                  child: Container(
                    height: 200,
                    width: 300,
                    child: Image.asset(
                      'lib/images/kitelab.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'קייט לאב \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: הפרחים 41, מושב רשפון  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                'אזורי לימוד: הרצליה, פולג, מכמורת, בית ינאי, שדות ים, חיפה, כנרת  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                CallButton(phoneNumber: '097733894'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      openGoogleMaps(32.16983071870699, 34.798568690029846),
                  child: Container(
                    height: 200,
                    width: 300,
                    child: Image.asset(
                      'lib/images/surfshack.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'מועדון הגלישה ניצנים \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: חוף ניצנים  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: אשדוד, אשקלון ועד זיקים \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                CallButton(phoneNumber: '0547438295'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      openGoogleMaps(32.16983071870699, 34.798568690029846),
                  child: Container(
                    height: 100,
                    width: 300,
                    child: Image.asset(
                      'lib/images/kitesurfeilat.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'קייט סרף אילת\n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: אילת  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: אילת \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                CallButton(phoneNumber: '0515860870'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      openGoogleMaps(32.16983071870699, 34.798568690029846),
                  child: Container(
                    height: 100,
                    width: 300,
                    child: Image.asset(
                      'lib/images/core.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'קייטים -קור \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: קיבוץ גלויות 5, עכו  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                'אזורי לימוד: עכו, נהריה, קריות, חיפה, עתלית, שדות ים \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                CallButton(phoneNumber: '0522865997'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      openGoogleMaps(32.16983071870699, 34.798568690029846),
                  child: Container(
                    height: 100,
                    width: 300,
                    child: Image.asset(
                      'lib/images/freegull.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'פריגל\n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום: מרכז ימי קיסרייה  \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: שדות ים \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                CallButton(phoneNumber: '0757012930'),
                SizedBox(height: 30),
                InkWell(
                  onTap: () =>
                      openGoogleMaps(32.16983071870699, 34.798568690029846),
                  child: Container(
                    height: 100,
                    width: 300,
                    child: Image.asset(
                      'lib/images/mypoint.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'מאי פויינט \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'מיקום:שלמה בן יוסף 6, הרצליה\n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'אזורי לימוד: חוף פולג, הרצליה \n',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                CallButton(phoneNumber: '0524856419'),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CallButton extends StatelessWidget {
  final String phoneNumber;

  CallButton({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _launchPhoneCall(),
      child: Text('Call $phoneNumber'),
    );
  }

  _launchPhoneCall() async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
