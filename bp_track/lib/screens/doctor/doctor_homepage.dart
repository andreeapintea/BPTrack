import 'package:bp_track/utilities/constants.dart';
import 'package:bp_track/screens/doctor/logged_entries_patient_doctor_screen.dart';
import 'package:bp_track/screens/doctor/logged_entries_patient_doctor_screen.dart';
import 'package:bp_track/screens/doctor/medication_list_doctor_screen.dart';
import 'package:bp_track/screens/welcome_screen.dart';
import 'package:bp_track/services/doctors_service.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

final _doctorService = DoctorsService();

class DoctorHomepageScreen extends StatelessWidget {
  const DoctorHomepageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text("Pacienți",
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          letterSpacing: 0.15,
        ),),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.only(top: 10)),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('patients')
                    .where('doctor_uid',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: snapshot.data!.docs.map((patient) {
                          return Card(
                            color: surface,
                            clipBehavior: Clip.antiAlias,
                            child: Theme(
                              data: ThemeData(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                  trailing: const SizedBox.shrink(),
                                  backgroundColor: surface,
                                  title: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Initicon(
                                          text:
                                              patient['prenume'].toUpperCase(),
                                          backgroundColor: secondaryColor,
                                          color: onSecondaryColor,
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "${patient['prenume'].toUpperCase()} ${patient['nume'].toUpperCase()}",
                                          style: GoogleFonts.workSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                letterSpacing: 0.5,
                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            launchUrlString("tel:${patient['phone']}");
                                          },
                                          child: Chip(
                                              backgroundColor: surface,
                                              shape: const StadiumBorder(
                                                  side: BorderSide(
                                                color: secondaryColor,
                                              )),
                                              label: Row(
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.0),
                                                    child: Icon(
                                                      Icons.phone,
                                                      color: secondaryColor,
                                                      size: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${patient['phone']}",
                                                    style: GoogleFonts.workSans(
                                                      color: secondaryColor,
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 13,
                                                      letterSpacing: 0.4,
                                                    )
                                                  )
                                                ],
                                              )),
                                        )
                                      ],
                                    ),
                                    ListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundColor: secondaryColor,
                                              child: IconButton(
                                                onPressed: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return MedicationListDoctorScreen(
                                                      patientUid: patient.id,
                                                    );
                                                  }));
                                                },
                                                icon: const FaIcon(
                                                    FontAwesomeIcons.pills),
                                                color: onPrimary,
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundColor: secondaryColor,
                                              child: IconButton(
                                                onPressed: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return LoggedEntriesDoctorScreen(
                                                      patientUid: patient.id,
                                                    );
                                                  }));
                                                },
                                                icon: const Icon(
                                                  Icons.history,
                                                  size: 30,
                                                ),
                                                color: onPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          );
                        }).toList());
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primary,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
