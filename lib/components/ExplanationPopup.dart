import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExplanationPopup {
  // This method shows an explanation popup if it's set to be shown.
  static Future<void> show({
    required BuildContext context,
    required String pageName,
    dynamic message,
    required String prefsKey,
  }) async {
    // Get an instance of SharedPreferences to manage user preferences.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the flag for showing the explanation, defaulting to true if not set.
    bool showExplanation = prefs.getBool(prefsKey) ?? true;

    // Display the explanation popup if the flag is set to true.
    if (showExplanation) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          // Build and return an AlertDialog
          return AlertDialog(
            title: Text('ברוכים הבאים ל$pageName'),
            content: _buildContent(message),
            actions: [
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      prefs.setBool(prefsKey, false); // Set the flag to false.
                      Navigator.of(context).pop(); // Close the popup.
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
    // This method builds the content based on the type of message provided.
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
      // This method builds the content for a list of icon-text pairs
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

// This method builds an icon based on the provided IconData.
  static Widget _buildIcon(IconData icon) {
    return Icon(icon, size: 35);
  }

  // This method resets the flags for showing explanations for all pages.
  static Future<void> resetFlags() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Reset the flags for all pages
    prefs.setBool('showExplanation_HomePage', true);
    prefs.setBool('showExplanation_SchoolPage', true);
    prefs.setBool('showExplanation_SpotsPage', true);
  }
}
