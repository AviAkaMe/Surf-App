import 'package:flutter/material.dart';

import '../components/func.dart';

class KitePage extends StatefulWidget {
  static const String id = 'kite_page';
  @override
  _KitePageState createState() => _KitePageState();
}

class _KitePageState extends State<KitePage> {
  int inputNumber = 0;
  String result = '';
  String dropdownValue = '10'; // Set the default value here

  List<Map<String, dynamic>> table = [
    {'number': 40, 'value': '6'},
    {'number': 50, 'value': '8'},
    {'number': 60, 'value': '9'},
    {'number': 70, 'value': '10'},
    {'number': 80, 'value': '12'},
    {'number': 90, 'value': '14'},
    {'number': 100, 'value': '16'},
  ];

  int _currentNumber = 10; // Set the initial number to the default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradientBoxDecoration, // Apply the gradientBoxDecoration
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Icon(
                Icons.calculate,
                size: 190,
              ),
              Text(
                'Kite Size Calculator',
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Please select your weight: ',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              Container(
                height: 75,
                child: Center(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    onChanged: (newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        // Look up the corresponding value from the table
                        result = findValueInTable(newValue);
                        _currentNumber = int.parse(newValue);
                      });
                    },
                    items: table.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry['value'].toString(),
                        child: Text(entry['number'].toString()),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Center(
                // Center the DropdownButton
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 125.0,
                  height: 125.0,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$_currentNumber',
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String findValueInTable(String value) {
    for (var entry in table) {
      if (value == entry['value'].toString()) {
        return entry['value'].toString();
      }
    }
    return '';
  }
}
