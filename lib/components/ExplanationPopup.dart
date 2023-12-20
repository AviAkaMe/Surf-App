import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExplanationPopup {
  static Future<void> show({
    required BuildContext context,
    required String pageName,
    dynamic message,
    required String prefsKey,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showExplanation = prefs.getBool(prefsKey) ?? true;

    if (showExplanation) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ברוכים הבאים ל$pageName'),
            content: _buildContent(message),
            actions: [
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      prefs.setBool(prefsKey, false);
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  )
                ],
              ),
            ],
          );
        },
      );
    }
  }

  static Widget _buildContent(dynamic message) {
    if (message is String) {
      return Text(message);
    } else if (message is List<Map<IconData, String>>) {
      return _buildIconTextPairsContent(message);
    } else {
      throw ArgumentError(
          'Invalid message type. Must be String or List<Map<IconData, String>>.');
    }
  }

  static Widget _buildIconTextPairsContent(
      List<Map<IconData, String>> messages) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: messages
          .map(
            (message) => Row(
              children: [
                _buildIcon(message.keys.first),
                SizedBox(width: 10),
                Expanded(
                  child: Text(message.values.first),
                ),
                SizedBox(
                    height: 50), // Adjust the space between lines as needed
              ],
            ),
          )
          .toList(),
    );
  }

  static Widget _buildIcon(IconData icon) {
    return Icon(icon, size: 35);
  }

  static Future<void> resetFlags() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Reset the flags for all pages
    prefs.setBool('showExplanation_HomePage', true);
    prefs.setBool('showExplanation_SchoolPage', true);
    prefs.setBool('showExplanation_SpotsPage', true);
  }
}
