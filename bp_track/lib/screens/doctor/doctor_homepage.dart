import 'package:bp_track/services/bp_entries_service.dart';
import 'package:bp_track/services/patients_service.dart';
import 'package:bp_track/utilities/constants.dart';
import 'package:bp_track/screens/doctor/logged_entries_patient_doctor_screen.dart';
import 'package:bp_track/screens/doctor/medication_list_doctor_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DoctorHomepageScreen extends StatefulWidget {
  const DoctorHomepageScreen({Key? key}) : super(key: key);

  @override
  State<DoctorHomepageScreen> createState() => _DoctorHomepageState();
}

class _DoctorHomepageState extends State<DoctorHomepageScreen> {


  final TextEditingController _systolicLimit = TextEditingController();
  final TextEditingController _diastolicLimit = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _entriesService = BPEntriesService();
  final _patientsService = PatientsService();

  @override
  void dispose() {
    _systolicLimit.dispose();
    _diastolicLimit.dispose();
    super.dispose();
    
  }

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
                                          // color: onSecondaryColor,
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
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundColor: secondaryColor,
                                              child: IconButton(
                                                onPressed: () {
                                                  _showLimitDialogue(patient.id);
                                                },
                                                icon: const Icon(
                                                  Icons.notifications,
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

  Future _showLimitDialogue(String patientUid) async {
    Size size = MediaQuery.of(context).size;
    var limits;
    await _patientsService.getLimits(patientUid: patientUid).then((result){
      setState(() {
        limits = result;
      });
    });
    String dialogMessage;
    if (limits.key == 0 || limits.value == 0)
    {
      dialogMessage = "Nu au fost setate limite pentru acest pacient!";
    }
    else
    {
      dialogMessage = "Limitele setate sunt:\n Sistolica: ${limits.key}\n Diastolica: ${limits.value}";
    }
    // ignore: use_build_context_synchronously
    return await showDialog(
        context: context,
        builder: (context) => SingleChildScrollView(
              child: AlertDialog(
                title: Text(
                  "Introduceți valorile tensiunii pentru alerte",
                  style: GoogleFonts.montserrat(
                    color: primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    letterSpacing: 0.15,
                  ),
                ),
                content: SizedBox(
                  height: size.height * 0.3,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(dialogMessage,
                          style: GoogleFonts.workSans(
                                )),
                          TextFormField(
                            controller: _systolicLimit,
                            maxLines: null,
                            decoration: InputDecoration(
                                labelText: "Limita sistolică",
                                labelStyle: GoogleFonts.workSans(
                                  color: secondaryColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13,
                                  letterSpacing: 0.4,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: secondaryColor, width: 2.0),
                                )),
                            validator: (value) {
                              RegExp numberRegExp = RegExp(r'^-?[0-9]+$');
                              if (value == null || value.isEmpty) {
                                return "Introduceți o valoare";
                              } else if (!numberRegExp.hasMatch(value)) {
                                return "Valoarea poate fi doar numerică";
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            controller: _diastolicLimit,
                            maxLines: null,
                            decoration: InputDecoration(
                                labelText: "Limita diastolică",
                                labelStyle: GoogleFonts.workSans(
                                  color: secondaryColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13,
                                  letterSpacing: 0.4,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: secondaryColor, width: 2.0),
                                )),
                            validator: (value) {
                              RegExp numberRegExp = RegExp(r'^-?[0-9]+$');
                              if (value == null || value.isEmpty) {
                                return "Introduceți o valoare";
                              } else if (!numberRegExp.hasMatch(value)) {
                                return "Valoarea poate fi doar numerică";
                              } else if ((int.parse(value)) >=
                                  (int.parse(_systolicLimit.text))) {
                                return "Diastolica nu poate fi mai mare decât sistolica!";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _diastolicLimit.clear();
                        _systolicLimit.clear();
                      },
                      child: Text(
                        "RENUNȚĂ",
                        style: GoogleFonts.workSans(
                          color: primary,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.25,

                        ),
                      )),
                  TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _patientsService.addBPLimitsToPatient(
                            patientUid: patientUid,
                              diastolicLimit: int.parse(_diastolicLimit.text),
                              systolicLimit: int.parse(_systolicLimit.text),
                              context: context);
                          _diastolicLimit.clear();
                          _systolicLimit.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "SETEAZĂ",
                        style: GoogleFonts.workSans(
                          color: primary,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.25,

                        ),
                      )),
                ],
              ),
            ));
  }
}
