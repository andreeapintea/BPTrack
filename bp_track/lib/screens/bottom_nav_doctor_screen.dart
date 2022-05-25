import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/account_screen_doctor.dart';
import 'package:bp_track/screens/doctor_homepage.dart';
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

class DoctorNavigation extends StatefulWidget {
  int currentIndex;
  String doctorUid;
  DoctorNavigation({Key? key, this.currentIndex = 0, required this.doctorUid})
      : super(key: key);

  @override
  State<DoctorNavigation> createState() => _DoctorNavigationState();
}

class _DoctorNavigationState extends State<DoctorNavigation> {
  late List<Widget> pages = [
    const DoctorHomepageScreen(),
    const AccountScreenDoctor(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages[widget.currentIndex],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
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
              label: "Acasă",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.account_circle),
              icon: Icon(Icons.account_circle_outlined),
              label: "Cont",
            )
          ],
        ),
      ),
    );
  }
}
