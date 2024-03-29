// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:bp_track/screens/patient/bottom_nav_patient_screen.dart';
import 'package:bp_track/utilities/constants.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      await _firestoreInstance
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

    var patientSnapshot = await _firestoreInstance
          .collection('patients')
          .doc(_auth.currentUser?.uid)
          .get();

    if (patientSnapshot.data() != null)
    {
      var systolicLimit = patientSnapshot.data()!['systolic_limit'];
      var diastolicLimit = patientSnapshot.data()!['diastolic_limt'];
      if (systolicLimit != 0 && diastolicLimit != 0)
      {
        if (systolic > systolicLimit || diastolic > diastolicLimit)
        {
          _notifyDoctor(patientSnapshot, context);
        }
      }
      else if (category == 'stage3')
      {
        _notifyDoctor(patientSnapshot, context);
      }
      else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PatientNavigation(
                    currentIndex: 0,
                    patientUid: _auth.currentUser!.uid,
                  )));
      showSnackbar(context, "Infomațiile au fost adăugate!");
      }
    }
    else
    {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PatientNavigation(
                    currentIndex: 0,
                    patientUid: _auth.currentUser!.uid,
                  )));
      showSnackbar(context, "Nu s-a putut gasi pacientul");
    }
  }

  
  void _notifyDoctor(DocumentSnapshot<Map<String, dynamic>> patientSnapshot, BuildContext context) async {
    var numePacient = patientSnapshot.data()!['nume'];
    var prenumePacient = patientSnapshot.data()!['prenume'];
    if (patientSnapshot.data()!['doctor_uid'] != null) {
      var doctorSnapshot = await _firestoreInstance
              .collection('doctors')
              .doc(patientSnapshot.data()!['doctor_uid'])
              .get();
      if (doctorSnapshot.data() != null &&
              !doctorSnapshot.data()!['token'].isEmpty) {
                sendPushMessage(
                "Tensiunea pacientului ${prenumePacient} ${numePacient} e foarte mare!",
                "Tensiune mare",
                doctorSnapshot.data()!['token']);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PatientNavigation(
                          currentIndex: 0,
                          patientUid: _auth.currentUser!.uid,
                        )));
            showSnackbar(context, "Tensiune mare! Doctorul a fost alertat!");
              }
              else
              {
                Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PatientNavigation(
                          currentIndex: 0,
                          patientUid: _auth.currentUser!.uid,
                        )));
            showSnackbar(context, "Atenție! Tensiunea ta este foarte mare!");
              }
    }
    else
    {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PatientNavigation(
                        currentIndex: 0,
                        patientUid: _auth.currentUser!.uid,
                      )));
          showSnackbar(context, "Atenție! Tensiunea ta este foarte mare!");
    }
  }
  
  String getBloodPressureCategory(int diastolic, int systolic) {
    if (systolic >= 180 || diastolic >= 110) {
      return 'stage3';
    } else if ((160 <= systolic && systolic < 180) ||
        (100 <= diastolic && diastolic < 110)) {
      return 'stage2';
    } else if ((140 <= systolic && systolic < 160) ||
        (90 <= diastolic && diastolic < 100)) {
      return 'stage1';
    } else if ((130 <= systolic && systolic < 140) ||
        (85 <= diastolic && diastolic < 90)) {
      return 'high';
    } else if ((120 <= systolic && systolic < 130) ||
        (80 <= diastolic && diastolic < 85)) {
      return 'normal';
    } else if (systolic < 120 && diastolic < 80) {
      return 'optimal';
    } else {
      return 'error';
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getEntries(String patientUid) {
    return _firestoreInstance
        .collection('patients')
        .doc(patientUid)
        .collection('tracker_entries')
        .orderBy('time', descending: true)
        .snapshots();
  }

  void sendPushMessage(String body, String title, String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': MESSAGING_KEY,
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<List<dynamic>> getAssociateEntriesList(String patientUid) async {
    List<dynamic> list = [];
    var entries = await _firestoreInstance
        .collection('patients')
        .doc(patientUid)
        .collection('tracker_entries')
        .orderBy('time', descending: true)
        .get();
    var count = 1;
    entries.docs.forEach((element) {
      list.add({
        "Nr.": count,
        "Sistolica": element['systolic'],
        "Diastolica": element['diastolic'],
        "Puls": element['pulse'],
        "Categorie": element['category'],
        "Data": (element['time'] as Timestamp).toDate(),
      });
      count++;
    });
    return list;
  }
}
