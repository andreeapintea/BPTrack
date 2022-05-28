import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorsService {
  final _firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future? getDoctor(String uid) async {
    final snapshot = await _firestoreInstance
        .collection('doctors')
        .doc(_auth.currentUser?.uid)
        .get();
    return snapshot;
  }

  Future? checkDoctorExists(String uid) async {
    final snapshot = await _firestoreInstance
        .collection('doctors')
        .doc(_auth.currentUser?.uid)
        .get();

    if (snapshot == null || !snapshot.exists) {
      return false;
    } else
      return true;
  }

  updateDoctorToken({
    required String token,
    required BuildContext context,
    required String doctorUid,
  }) async {
    try {
      await _firestoreInstance.collection('doctors').doc(doctorUid).update({
        'token': token,
      });
    } on FirebaseException catch (e) {
      showSnackbar(context, e.message!);
      return false;
    }
    return true;
  }

  void addDoctor({
    required String nume,
    required String prenume,
    required String county,
    required String phone,
    required String department,
    required String? token,
    required BuildContext context,
  }) async {
    final snapshot = await _firestoreInstance
        .collection('doctors')
        .doc(_auth.currentUser?.uid)
        .get();

    if (snapshot == null || !snapshot.exists) {
      try {
        await _firestoreInstance
            .collection('doctors')
            .doc(_auth.currentUser?.uid)
            .set({
          'nume': nume,
          'prenume': prenume,
          'conty': county,
          'department': department,
          'role': "doctor",
          'phone': phone,
          'token': token,
        });
      } on FirebaseException catch (e) {
        showSnackbar(context, e.message!);
      }
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => PatientNavigation(currentIndex: 0,
      //     patientUid: _auth.currentUser!.uid,)));
      showSnackbar(context, "Infomațiile au fost adăugate!");
    }
  }
}
