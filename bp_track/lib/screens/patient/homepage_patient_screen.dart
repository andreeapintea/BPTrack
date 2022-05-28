import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bp_track/utilities/constants.dart';
import 'package:bp_track/models/logged_entry.dart';
import 'package:bp_track/screens/welcome_screen.dart';
import 'package:bp_track/services/bp_entries_service.dart';
import 'package:bp_track/services/medication_service.dart';
import 'package:bp_track/services/patients_service.dart';
import 'package:bp_track/utilities/utilities.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final _bpService = BPEntriesService();

class PatientHomepage extends StatefulWidget {
  const PatientHomepage({Key? key}) : super(key: key);

  @override
  State<PatientHomepage> createState() => _PatientHomepageState();
}

class _PatientHomepageState extends State<PatientHomepage> {
  final TextEditingController _systolic = TextEditingController();
  final TextEditingController _diastolic = TextEditingController();
  final TextEditingController _pulse = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _entriesService = BPEntriesService();

  @override
  void dispose() {
    _systolic.dispose();
    _diastolic.dispose();
    _pulse.dispose();
    super.dispose();
    
  }

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Permiteți notificări"),
                  content: const Text("Aplicația vrea să vă trimită notificări"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Nu")),
                    TextButton(
                        onPressed: () {
                          AwesomeNotifications()
                              .requestPermissionToSendNotifications()
                              .then((_) => Navigator.pop(context));
                        },
                        child: const Text("OK"))
                  ],
                ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 35, top: 48, bottom: 48),
            child: SizedBox(
                width: size.width,
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('patients')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: primary),
                      );
                    } else {
                      var output = snapshot.data;
                      var prenume = output!["prenume"];
                      var hour = DateTime.now().hour;
                      if (hour>=1 && hour <=12){
                        return Text(
                        "Bună dimineața,\n${prenume}!",
                        style: GoogleFonts.montserrat(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      );
                      }
                      else if (hour>=13 && hour <=16){
                        return Text(
                        "Bună ziua,\n${prenume}!",
                        style: GoogleFonts.montserrat(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      );
                      }
                      else {
                        return Text(
                        "Bună seara,\n${prenume}!",
                        style: GoogleFonts.montserrat(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      );
                      }
                    }
                  },
                )),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  _bpService.getEntries(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                List<FlSpot> systolic = [];
                List<FlSpot> diastolic = [];
                List<FlSpot> pulse = [];
                if (snapshot.hasData && snapshot.data != null) {
                  // var entries = snapshot.data!.docs.map((doc) {
                  //   LoggedEntry.fromDocumentSnapshot(doc);
                  // }).toList();
                  snapshot.data?.docs.forEach((doc) {
                    var date = doc.data()["time"].toDate();
                    if (date.year == DateTime.now().year &&
                        date.month == DateTime.now().month) {
                      systolic.add(FlSpot(date.day.toDouble(),
                          doc.data()["systolic"].toDouble()));
                      diastolic.add(FlSpot(date.day.toDouble(),
                          doc.data()["diastolic"].toDouble()));
                      pulse.add(FlSpot(
                          date.day.toDouble(), doc.data()["pulse"].toDouble()));
                    }
                  });
                }
                return SizedBox(
                    width: size.width * 0.9,
                    height: size.height * 0.4,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LineChart(LineChartData(
                          backgroundColor: surface,
                          minX: 1,
                          maxX: 31,
                          minY: 0,
                          maxY: 200,
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 24,
                                interval: 5,
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              )
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false
                              )
                            )
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: systolic,
                              color: Colors.red,
                              isCurved: true,
                            ),
                            LineChartBarData(
                              spots: diastolic,
                              color: Colors.blue,
                              isCurved: true,
                            ),
                            LineChartBarData(
                              spots: pulse,
                              color: Colors.green,
                              isCurved: true,
                            )
                          ],
                        ),
                        ),
                      ),
                    ));
              }),
          const Padding(padding: EdgeInsets.all(15)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(children: [
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    color: Colors.red,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text(
                    "Sistolică",
                    style: GoogleFonts.workSans(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            letterSpacing: 0.5,
                                          ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    color: Colors.blue,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text(
                    "Diastolică",
                    style: GoogleFonts.workSans(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            letterSpacing: 0.5,
                                          ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.circle,
                    color: Colors.green,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text(
                    "Puls",
                    style: GoogleFonts.workSans(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            letterSpacing: 0.5,
                                          ),
                  ),
                ],
              )
            ]),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddDialogue();
        },
        backgroundColor: primary,
      ),
    );
  }

  Future _showAddDialogue() async {
    Size size = MediaQuery.of(context).size;
    return await showDialog(
        context: context,
        builder: (context) => SingleChildScrollView(
              child: AlertDialog(
                title: Text(
                  "Introduceți valorile tensiunii",
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
                          TextFormField(
                            controller: _systolic,
                            decoration: InputDecoration(
                                labelText: "Sistolic",
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
                            controller: _diastolic,
                            decoration: InputDecoration(
                                labelText: "Diastolică",
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
                                  (int.parse(_systolic.text))) {
                                return "Valoarea tensiunii diastolică nu poate fi mai mare decât cea sistolică!";
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            controller: _pulse,
                            decoration: InputDecoration(
                                labelText: "Puls",
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
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _diastolic.clear();
                        _systolic.clear();
                        _pulse.clear();
                      },
                      child: Text(
                        "CANCEL",
                        style: GoogleFonts.workSans(
                          color: primary,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.25,

                        ),
                      )),
                  TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _entriesService.addEntry(
                              diastolic: int.parse(_diastolic.text),
                              systolic: int.parse(_systolic.text),
                              pulse: int.parse(_pulse.text),
                              dateTime: DateTime.now(),
                              context: context);
                          _diastolic.clear();
                          _systolic.clear();
                          _pulse.clear();
                        }
                      },
                      child: Text(
                        "SUBMIT",
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
