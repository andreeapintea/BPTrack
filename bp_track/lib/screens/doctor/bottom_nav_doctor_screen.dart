import 'package:bp_track/utilities/constants.dart';
import 'package:bp_track/screens/doctor/account_screen_doctor.dart';
import 'package:bp_track/screens/doctor/doctor_homepage.dart';
import 'package:flutter/material.dart';

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
