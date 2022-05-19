import 'package:bp_track/constants.dart';
import 'package:bp_track/models/logged_entry.dart';
import 'package:bp_track/screens/welcome_screen.dart';
import 'package:bp_track/services/bp_entries_service.dart';
import 'package:bp_track/services/patients_service.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

final _patientsService = PatientsService();

class PatientHomepage extends StatefulWidget {
  const PatientHomepage({Key? key}) : super(key: key);

  @override
  State<PatientHomepage> createState() => _PatientHomepageState();
}

class _PatientHomepageState extends State<PatientHomepage> {
  TextEditingController _systolic = TextEditingController();
  TextEditingController _diastolic = TextEditingController();
  TextEditingController _pulse = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _entriesService = BPEntriesService();

  @override
  void dispose() {
    super.dispose();
    _systolic.dispose();
    _diastolic.dispose();
    _pulse.dispose();
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
                      return Text(
                        "Hello\n${prenume}!",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      );
                    }
                  },
                )),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('tracker_entries')
                  .where("patient_uid",
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
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
                    if (date.year == DateTime.now().year && date.month == DateTime.now().month)
                    {
                      systolic.add(FlSpot(
                        date.month.toDouble(),
                        doc.data()["systolic"].toDouble()));
                        diastolic.add(FlSpot(
                        date.month.toDouble(),
                        doc.data()["diastolic"].toDouble()));
                        pulse.add(FlSpot(
                        date.month.toDouble(),
                        doc.data()["pulse"].toDouble()));
                    }
                  });
                }
                return SizedBox(
                    width: size.width * 0.8,
                    height: size.height * 0.3,
                    child: LineChart(LineChartData(
                      backgroundColor: surface,
                      minX: 1,
                      maxX: 31,
                      minY: 0,
                      maxY: 190,
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
                    )));
              }),
          Padding(padding: EdgeInsets.all(15)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(children: [
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.red,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text(
                    "Sistolică",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.blue,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text(
                    "Diastolică",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.green,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text(
                    "Puls",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              )
            ]),
          ),
          ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      (Route<dynamic> route) => false);
                });
                showSnackbar(context, "V-ați deconectat cu succes");
              },
              child: const Text("LOGOUT")),
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
                title: const Text(
                  "Introduceți valorile tensiunii",
                  style: TextStyle(color: primary),
                ),
                content: SizedBox(
                  height: size.height * 0.4,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _systolic,
                            decoration: const InputDecoration(
                                labelText: "Sistolic",
                                labelStyle: TextStyle(color: secondaryColor),
                                focusedBorder: OutlineInputBorder(
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
                            decoration: const InputDecoration(
                                labelText: "Diastolică",
                                labelStyle: TextStyle(color: secondaryColor),
                                focusedBorder: OutlineInputBorder(
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
                            decoration: const InputDecoration(
                                labelText: "Puls",
                                labelStyle: TextStyle(color: secondaryColor),
                                focusedBorder: OutlineInputBorder(
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
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(color: primary),
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
                      child: const Text(
                        "SUBMIT",
                        style: TextStyle(color: primary),
                      )),
                ],
              ),
            ));
  }
}
