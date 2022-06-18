import 'package:bp_track/screens/patient/bottom_nav_patient_screen.dart';
import 'package:bp_track/utilities/utilities.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MedicationService {
  final _firestoreInstance = FirebaseFirestore.instance;

  void addMedicationPatient({
    required String medication,
    String? details,
    required String time,
    required List days,
    required String patientUid,
    required BuildContext context,
  }) async {
    try {
      int id = createUniqueId();
      _firestoreInstance
          .collection('patients')
          .doc(patientUid)
          .collection('medication')
          .add({
        'medication': medication,
        'details': details,
        'time': time,
        'days': days,
        'notification_id': id
      });
      createMedsReminder(medication, days, time, id);
    } on FirebaseException catch (e) {
      showSnackbar(context, e.message!);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PatientNavigation(
                  currentIndex: 1,
                  patientUid: patientUid,
                )));
    showSnackbar(context, "Infomațiile au fost adăugate!");
  }

  void addMedicationDoctor({
    required String medication,
    String? details,
    required String patientUid,
    required BuildContext context,
  }) async {
    try {
      _firestoreInstance
          .collection('patients')
          .doc(patientUid)
          .collection('medication')
          .add({
        'medication': medication,
        'details': details,
        'time': "",
        'days': "",
        'notification_id': null
      });
    } on FirebaseException catch (e) {
      showSnackbar(context, e.message!);
    }
    Navigator.pop(context);
    showSnackbar(context, "Infomațiile au fost adăugate!");
  }

  void updateMedicationPatient({
    required String medication,
    String? details,
    required String time,
    required List days,
    required String patientUid,
    required String docId,
    required BuildContext context,
    int? notificationId,
  }) async {
    try {
      if (notificationId != null) {
        cancelNotification(notificationId);
      } else {
        notificationId = createUniqueId();
      }
      _firestoreInstance
          .collection('patients')
          .doc(patientUid)
          .collection('medication')
          .doc(docId)
          .update({
        'medication': medication,
        'details': details,
        'time': time,
        'days': days,
        'notification_id': notificationId,
      });
      await createMedsReminder(medication, days, time, notificationId);
    } on FirebaseException catch (e) {
      showSnackbar(context, e.message!);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PatientNavigation(
                  currentIndex: 1,
                  patientUid: patientUid,
                )));
    showSnackbar(context, "Infomațiile au fost salvate!");
  }

  void updateMedicationDoctor({
    required String medication,
    String? details,
    required String patientUid,
    required String docId,
    required BuildContext context,
  }) async {
    try {
      await _firestoreInstance
          .collection('patients')
          .doc(patientUid)
          .collection('medication')
          .doc(docId)
          .update({
        'medication': medication,
        'details': details,
      });
    } on FirebaseException catch (e) {
      showSnackbar(context, e.message!);
    }
    Navigator.pop(context);
    showSnackbar(context, "Infomațiile au fost salvate!");
  }

  void deleteMedicationPatient({
    required String patientUid,
    required String docId,
    required BuildContext context,
    required int notificationId,
  }) async {
    try {
      await _firestoreInstance
          .collection('patients')
          .doc(patientUid)
          .collection('medication')
          .doc(docId)
          .delete();
      cancelNotification(notificationId);
    } on FirebaseException catch (e) {
      showSnackbar(context, e.message!);
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => PatientNavigation(
                  patientUid: patientUid,
                  currentIndex: 1,
                )),
        (Route<dynamic> route) => false);
    showSnackbar(context, "Medicamentul a fost șters!");
  }

  void deleteMedicationDoctor({
    required String patientUid,
    required String docId,
    required BuildContext context,
  }) async {
    try {
      await _firestoreInstance
          .collection('patients')
          .doc(patientUid)
          .collection('medication')
          .doc(docId)
          .delete();
    } on FirebaseException catch (e) {
      showSnackbar(context, e.message!);
    }
    Navigator.pop(context);
    showSnackbar(context, "Medicamentul a fost șters!");
  }

  void createNotifications(String patientUid) async {
    QuerySnapshot snapshot = await _firestoreInstance
        .collection('patients')
        .doc(patientUid)
        .collection('medication')
        .get();
    snapshot.docs.map((entry) {
      if (entry['days'] != null && entry['time'].exists && entry['notification_id']!=null) {
        createMedsReminder(entry['medicine'], entry['days'], entry['time'],
            entry['notification_id']);
      }
    });
  }
}
