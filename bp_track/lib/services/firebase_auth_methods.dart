import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/bottom_nav_patient_screen.dart';
import 'package:bp_track/screens/login_screen.dart';
import 'package:bp_track/screens/patient_details_screen.dart';
import 'package:bp_track/services/patients_service.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _patientsService = PatientsService();

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  Future<void> signUpWithEmailPatient({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => PatientDetailsScreen()), (Route<dynamic> route) => false);
        showSnackbar(context, "Contul a fost creat cu succes!");
      });
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
    bool _patientExists = await _patientsService.checkPatientExists(_auth.currentUser!.uid);
    //bool _doctorExists = await _doctorsService.checkDoctorExists(_auth.currentUser!.uid);
    //TODO
    if (_patientExists)
    {
      // Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => PatientNavigation()));
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => PatientNavigation()), (Route<dynamic> route) => false);
            showSnackbar(context, "Autentificat ca pacient");
    }
    else {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => PatientDetailsScreen()), (Route<dynamic> route) => false);
            showSnackbar(context, "Adăugați detaliile");
    }
  }
}
