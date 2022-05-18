import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/homepage_patient_screen.dart';
import 'package:flutter/material.dart';

const TextStyle _textStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
  fontStyle: FontStyle.italic,
);

class PatientNavigation extends StatefulWidget {
  const PatientNavigation({Key? key}) : super(key: key);

  @override
  State<PatientNavigation> createState() => _PatientNavigationState();
}

class _PatientNavigationState extends State<PatientNavigation> {
  int _currentIndex = 0;
  List<Widget> pages = [
   PatientHomepage(),
    Text(
      "Medication",
      style: _textStyle,
    ),
    Text(
      "History",
      style: _textStyle,
    ),
    Text(
      "Account",
      style: _textStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: onSecondaryColor,
        ),
        child: NavigationBar(
          backgroundColor: secondaryContainer,
          selectedIndex: _currentIndex,
          onDestinationSelected: (int newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.medication),
              icon: Icon(Icons.medication_outlined),
              label: "Medication",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.history),
              icon: Icon(Icons.history_outlined),
              label: "History",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.account_circle),
              icon: Icon(Icons.account_circle_outlined),
              label: "Account",
            )
          ],
        ),
      ),
    );
  }
}
