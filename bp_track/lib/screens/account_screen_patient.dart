import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/welcome_screen.dart';
import 'package:bp_track/services/bp_entries_service.dart';
import 'package:bp_track/services/patients_service.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:bp_track/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _patientsService = PatientsService();

class PatientSettingsScreen extends StatelessWidget {
  const PatientSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('patients')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var output = snapshot.data;
                      String doctorUid = output!['doctor_uid'];
                      return ListView(
                        children: [
                          Visibility(
                            visible: doctorUid == null || doctorUid.isEmpty,
                            child: ListTile(
                              title: Text(
                                "Selectează doctor",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              "Deconectare",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              FirebaseAuth.instance.signOut().then((value) {
                                cancelAllNotifications();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => WelcomeScreen()),
                                    (Route<dynamic> route) => false);
                              });
                              showSnackbar(
                                  context, "V-ați deconectat cu succes");
                            },
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(color: primary),
                      );
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}
