import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/bottom_nav_patient_screen.dart';
import 'package:bp_track/screens/login_screen.dart';
import 'package:bp_track/screens/patient_details_screen.dart';
import 'package:bp_track/services/doctors_service.dart';
import 'package:bp_track/services/medication_service.dart';
import 'package:bp_track/services/patients_service.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _patientsService = PatientsService();
final _medicineService = MedicationService();
final _doctorsService = DoctorsService();

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
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => PatientDetailsScreen()),
            (Route<dynamic> route) => false);
        showSnackbar(context, "Contul a fost creat cu succes!");
      });
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
  }

  Future<void> signUpDoctor({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => PatientDetailsScreen()),
        //     (Route<dynamic> route) => false);

        //showSnackbar(context, "Contul a fost creat cu succes!");
      });
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => PatientDetailsScreen()),
                (Route<dynamic> route) => false);
            showSnackbar(context, "Adăugați detaliile");
          } else {
            _medicineService.createNotifications(userCredential.user!.uid);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => PatientNavigation(
                          currentIndex: 0,
                          patientUid: userCredential.user!.uid,
                        )),
                (Route<dynamic> route) => false);
            showSnackbar(context, "Autentificat ca pacient");
          }
        }
      }
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
    bool _patientExists =
        await _patientsService.checkPatientExists(_auth.currentUser!.uid);
    //bool _doctorExists = await _doctorsService.checkDoctorExists(_auth.currentUser!.uid);
    //TODO
    if (_patientExists) {
      // Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => PatientNavigation()));
      _medicineService.createNotifications(_auth.currentUser!.uid);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => PatientNavigation(
                    currentIndex: 0,
                    patientUid: _auth.currentUser!.uid,
                  )),
          (Route<dynamic> route) => false);
      showSnackbar(context, "Autentificat ca pacient");
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => PatientDetailsScreen()),
          (Route<dynamic> route) => false);
      showSnackbar(context, "Adăugați detaliile");
    }
  }
}
