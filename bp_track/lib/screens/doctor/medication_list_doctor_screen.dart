import 'package:bp_track/utilities/constants.dart';
import 'package:bp_track/screens/doctor/medication_screen_doctor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MedicationListDoctorScreen extends StatelessWidget {
  final String patientUid;
  const MedicationListDoctorScreen({Key? key, required this.patientUid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medicamente"
        , style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          letterSpacing: 0.15,
        ),),
        backgroundColor: primary,
      ),
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
                  .orderBy('medication')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!.docs.map((entry) {
                      return Center(
                        child: Card(
                          color: surface,
                          child: ListTile(
                            title: Text(
                              entry['medication'],
                              style: GoogleFonts.workSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                letterSpacing: 0.5,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MedicationScreenDoctor(
                                  isEdit: true,
                                  patientUid:
                                      patientUid,
                                  documentId: entry.id,
                                );
                              }));
                            },
                          ),
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
        child: const Icon(Icons.add),
        backgroundColor: primary,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MedicationScreenDoctor(
              isEdit: false,
              patientUid: patientUid,
            );
          }));
        },
      ),
    );
  }
}
