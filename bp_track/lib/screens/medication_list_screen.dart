import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/medication_screen.dart';
import 'package:bp_track/services/bp_entries_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicationListScreen extends StatelessWidget {
  final String patientUid;
  const MedicationListScreen({Key? key, required this.patientUid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('patients')
                  .doc(patientUid)
                  .collection('medication')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!.docs.map((entry) {
                      return Center(
                        child: ListTile(
                          title: Text(
                            entry['medication'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MedicationScreen(
                                isEdit: true,
                                patientUid:
                                    FirebaseAuth.instance.currentUser!.uid,
                                documentId: entry.id,
                              );
                            }));
                          },
                        ),
                      );
                    }).toList(),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(color: primary),
                );
              },
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: primary,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MedicationScreen(
              isEdit: false,
              patientUid: FirebaseAuth.instance.currentUser!.uid,
            );
          }));
        },
      ),
    );
  }
}
