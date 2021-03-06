import 'package:bp_track/screens/doctor/bottom_nav_doctor_screen.dart';
import 'package:bp_track/screens/patient/bottom_nav_patient_screen.dart';
import 'package:bp_track/screens/patient/patient_details_screen.dart';
import 'package:bp_track/services/doctors_service.dart';
import 'package:bp_track/services/medication_service.dart';
import 'package:bp_track/services/patients_service.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
          .then((value) {});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showSnackbar(context, "Un cont cu această adresă de email există deja");
      }
      else {
        showSnackbar(context, e.message!);
      }
    }
  }

  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
    showSnackbar(context, "Un email de restare a fost trimis!");
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
      bool _patientExists =
          await _patientsService.checkPatientExists(_auth.currentUser!.uid);
      bool _doctorExists =
          await _doctorsService.checkDoctorExists(_auth.currentUser!.uid);
      if (_patientExists) {
        _medicineService.createNotifications(_auth.currentUser!.uid);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => PatientNavigation(
                      currentIndex: 0,
                      patientUid: _auth.currentUser!.uid,
                    )),
            (Route<dynamic> route) => false);
        showSnackbar(context, "Autentificat ca pacient");
      } else if (!_patientExists && !_doctorExists) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => PatientDetailsScreen()),
            (Route<dynamic> route) => false);
        showSnackbar(context, "Adăugați detaliile");
      } else if (_doctorExists) {
        var token = await FirebaseMessaging.instance.getToken();
        if (token == null) {
          token = "";
        }
        _doctorsService.updateDoctorToken(
            token: token, context: context, doctorUid: _auth.currentUser!.uid);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => DoctorNavigation(
                      doctorUid: _auth.currentUser!.uid,
                    )),
            (Route<dynamic> route) => false);
        showSnackbar(context, "Autentificat ca doctor");
      } else {
        showSnackbar(context, "Eroare");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        showSnackbar(context, "Utilizatorul nu există!");
      } else if (e.code == "wrong-password") {
        showSnackbar(context, "Parola este greșită!");
      } else if (e.code == "invalid-email") {
        showSnackbar(context, "Adresa de email nu este validă!");
      } else {
        showSnackbar(context, e.message!);
      }
    }
  }
}
