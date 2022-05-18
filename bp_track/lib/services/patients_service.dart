import 'package:bp_track/screens/bottom_nav_patient_screen.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PatientsService {
  final _firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future? getPatient(String uid) async {
    final snapshot = await _firestoreInstance
        .collection('patients')
        .doc(_auth.currentUser?.uid)
        .get();
    return snapshot;
  }

  Future? checkPatientExists(String uid) async {
    final snapshot = await _firestoreInstance
        .collection('patients')
        .doc(_auth.currentUser?.uid)
        .get();

    if (snapshot == null || !snapshot.exists) {
      return false;
    } else
      return true;
  }

  void addPatient({
    required String nume,
    required String prenume,
    required String cnp,
    required String phone,
    required String dob,
    required BuildContext context,
  }) async {
    final snapshot = await _firestoreInstance
        .collection('patients')
        .doc(_auth.currentUser?.uid)
        .get();

    if (snapshot == null || !snapshot.exists) {
      try {
        _firestoreInstance
            .collection('patients')
            .doc(_auth.currentUser?.uid)
            .set({
          'nume': nume,
          'prenume': prenume,
          'cnp': cnp,
          'dob': dob,
          'role': "patient"
        });
      } on FirebaseException catch (e) {
        showSnackbar(context, e.message!);
      }
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PatientNavigation()));
      showSnackbar(context, "Infomațiile au fost adăugate!");
    }
  }
}
