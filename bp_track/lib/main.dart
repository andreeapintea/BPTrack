import 'package:bp_track/screens/account_type_screen.dart';
import 'package:bp_track/screens/bottom_nav_patient_screen.dart';
import 'package:bp_track/screens/patient_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bp_track/screens/welcome_screen.dart';
import 'package:bp_track/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bp_track/services/patients_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  final _patientsService = PatientsService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BPTrack',
        theme: ThemeData(
          primaryColor: primary,
          scaffoldBackgroundColor: background,
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: primary,
                ));
              } else if (snapshot.hasData) {
                //TODO daca e pacient sau medic
                return FutureBuilder(
                  future: _patientsService
                      .getPatient(FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: primary),
                      );
                    } else if (snapshot.hasData) {
                      return PatientNavigation();
                    } else {
                      return PatientDetailsScreen();
                    }
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Something went wrong!'));
              } else {
                return WelcomeScreen();
              }
            }));
  }
}
