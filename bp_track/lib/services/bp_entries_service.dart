import 'package:bp_track/screens/bottom_nav_patient_screen.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BPEntriesService {
  final _firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void addEntry({
    required int diastolic,
    required int systolic,
    required int pulse,
    required DateTime dateTime,
    required BuildContext context,
  }) async {
    var category = getBloodPressureCategory(diastolic, systolic);
    try {
      _firestoreInstance
          .collection('patients')
          .doc(_auth.currentUser?.uid)
          .collection('tracker_entries')
          .add({
        'diastolic': diastolic,
        'systolic': systolic,
        'pulse': pulse,
        'time': dateTime,
        'category': category,
      });
    } on FirebaseException catch (e) {
      showSnackbar(context, e.message!);
    }
     Navigator.push(
         context, MaterialPageRoute(builder: (context) => PatientNavigation(currentIndex: 0, patientUid: _auth.currentUser!.uid,)));
    showSnackbar(context, "Infomațiile au fost adăugate!");
  }

  String getBloodPressureCategory(int diastolic, int systolic) {
    if (systolic < 100 && diastolic < 60) {
      return "hypo";
    } else if (systolic < 120 && diastolic < 80) {
      return "normal";
    } else if ((119 < systolic && systolic < 130) && diastolic < 80) {
      return "high";
    } else if ((129 < systolic && systolic < 140) ||
        (79 < diastolic && diastolic < 90)) {
      return "stage1";
    } else if ((139 < systolic && systolic < 180) ||
        (89 < diastolic && diastolic < 120)) {
      return "stage2";
    } else if (systolic > 179 || diastolic > 119) {
      return "stage3";
    } else {
      return "error";
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getEntries(String patientUid) {
    return _firestoreInstance
        .collection('patients')
        .doc(patientUid)
        .collection('tracker_entries')
        .snapshots();
  }
}
