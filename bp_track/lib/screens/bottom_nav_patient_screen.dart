import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/account_screen_patient.dart';
import 'package:bp_track/screens/homepage_patient_screen.dart';
import 'package:bp_track/screens/logged_entries_patient_screen.dart';
import 'package:bp_track/screens/medication_list_screen.dart';
import 'package:bp_track/screens/medication_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const TextStyle _textStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
  fontStyle: FontStyle.italic,
);

class PatientNavigation extends StatefulWidget {
  int currentIndex;
  String patientUid;
  PatientNavigation({Key? key, this.currentIndex = 0, required this.patientUid})
      : super(key: key);

  @override
  State<PatientNavigation> createState() => _PatientNavigationState();
}

class _PatientNavigationState extends State<PatientNavigation> {
  late List<Widget> pages = [
    const PatientHomepage(),
    MedicationListScreen(
      patientUid: widget.patientUid,
    ),
    LoggedEntriesPatientScreen(),
    PatientSettingsScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages[widget.currentIndex],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: onSecondaryColor,
        ),
        child: NavigationBar(
          backgroundColor: secondaryContainer,
          selectedIndex: widget.currentIndex,
          onDestinationSelected: (int newIndex) {
            setState(() {
              widget.currentIndex = newIndex;
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
