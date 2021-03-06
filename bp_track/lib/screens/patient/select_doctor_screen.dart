import 'package:bp_track/utilities/constants.dart';
import 'package:bp_track/services/patients_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final _patientsService = PatientsService();

class SelectDoctorScreen extends StatelessWidget {
  const SelectDoctorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text("Selectați medicul",
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          letterSpacing: 0.15,
        ),),
      ),
      body: Column(
        children: [
          Expanded(
              child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('doctors').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!.docs.map((doctor) {
                      return Center(
                        child: Card(
                          color: surface,
                          child: ListTile(
                            title: Text(
                              "${doctor['prenume'].toUpperCase()} ${doctor['nume'].toUpperCase()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              _selectDoctor(doctor.id, context);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(color: primary),
                  );
                }
              },
            ),
          ))
        ],
      ),
    );
  }

  _selectDoctor(String doctorUid, BuildContext context) {
    _patientsService.addDoctorToPatient(
        patientUid: FirebaseAuth.instance.currentUser!.uid,
        doctorUid: doctorUid,
        context: context);
  }
}
