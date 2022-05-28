import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/login_screen.dart';
import 'package:bp_track/services/firebase_auth_methods.dart';
import 'package:bp_track/services/medication_service.dart';
import 'package:bp_track/services/patients_service.dart';
import 'package:bp_track/utilities/validators.dart';
import 'package:bp_track/widgets/common/already_have_account.dart';
import 'package:bp_track/widgets/common/or_divider.dart';
import 'package:bp_track/widgets/common/rounded_button.dart';
import 'package:bp_track/widgets/common/rounded_input_field.dart';
import 'package:bp_track/widgets/common/rounded_password_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';

final _medicationService = MedicationService();

class MedicationScreen extends StatefulWidget {
  final bool isEdit;
  final String? documentId;
  final String patientUid;
  bool mon, tue, wed, thu, fri, sat, sun;

  MedicationScreen({
    Key? key,
    required this.isEdit,
    this.documentId,
    this.mon = false,
    this.tue = false,
    this.wed = false,
    this.thu = false,
    this.fri = false,
    this.sat = false,
    this.sun = false,
    required this.patientUid,
  }) : super(key: key);

  @override
  _MedicationScreenState createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _time = TextEditingController();
  TextEditingController _medication = TextEditingController();
  TextEditingController _details = TextEditingController();
  final _patientsService = PatientsService();
  var days = [];
  var notificationId;

  @override
  void dispose() {
    super.dispose();
    _time.dispose();
    _medication.dispose();
    _details.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _setFields(widget.patientUid, widget.documentId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: widget.isEdit ? Text("Modifică medicament",
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          letterSpacing: 0.15,
        ),) : Text("Adaugă medicament",
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          letterSpacing: 0.15,
        ),),
      ),
      body: Form(
        key: _formKey,
        child: !widget.isEdit
            ? Container(
                height: size.height,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Positioned(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              "MEDICAMENT",
                              style: GoogleFonts.montserrat(
                                color: primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          RoundedInputField(
                            hintText: "Medicament",
                            onChanged: (value) {},
                            validator: validateMedication,
                            controller: _medication,
                            icon: Icons.medication,
                          ),
                          RoundedInputField(
                            hintText: "Ora",
                            icon: Icons.alarm,
                            controller: _time,
                            onChanged: (value) {},
                            tap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              _selectTime(context);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Introduceți ora";
                              } else {
                                return null;
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: Row(
                              children: [
                                FilterChip(
                                  label: Text("LU"),
                                  selected: widget.mon,
                                  onSelected: (value) {
                                    widget.mon = value;
                                    if (widget.mon) {
                                      days.add("MON");
                                    } else {
                                      days.remove("MON");
                                    }
                                    setState(() {});
                                  },
                                  selectedColor: primaryContainer,
                                  showCheckmark: false,
                                ),
                                FilterChip(
                                  label: Text("MA"),
                                  selected: widget.tue,
                                  onSelected: (value) {
                                    widget.tue = value;
                                    if (widget.tue) {
                                      days.add("TUE");
                                    } else {
                                      days.remove("TUE");
                                    }
                                    setState(() {});
                                  },
                                  selectedColor: primaryContainer,
                                  showCheckmark: false,
                                ),
                                FilterChip(
                                  label: Text("MI"),
                                  selected: widget.wed,
                                  onSelected: (value) {
                                    widget.wed = value;
                                    if (widget.wed) {
                                      days.add("WED");
                                    } else {
                                      days.remove("WED");
                                    }
                                    setState(() {});
                                  },
                                  selectedColor: primaryContainer,
                                  showCheckmark: false,
                                ),
                                FilterChip(
                                  label: Text("JO"),
                                  selected: widget.thu,
                                  onSelected: (value) {
                                    widget.thu = value;
                                    if (widget.thu) {
                                      days.add("THU");
                                    } else {
                                      days.remove("THU");
                                    }
                                    setState(() {});
                                  },
                                  selectedColor: primaryContainer,
                                  showCheckmark: false,
                                ),
                                FilterChip(
                                  label: Text("VI"),
                                  selected: widget.fri,
                                  onSelected: (value) {
                                    widget.fri = value;
                                    if (widget.fri) {
                                      days.add("FRI");
                                    } else {
                                      days.remove("FRI");
                                    }
                                    setState(() {});
                                  },
                                  selectedColor: primaryContainer,
                                  showCheckmark: false,
                                ),
                                FilterChip(
                                  label: Text("SA"),
                                  selected: widget.sat,
                                  onSelected: (value) {
                                    widget.sat = value;
                                    if (widget.sat) {
                                      days.add("SAT");
                                    } else {
                                      days.remove("SAT");
                                    }
                                    setState(() {});
                                  },
                                  selectedColor: primaryContainer,
                                  showCheckmark: false,
                                ),
                                FilterChip(
                                  label: Text("DU"),
                                  selected: widget.sun,
                                  onSelected: (value) {
                                    widget.sun = value;
                                    if (widget.sun) {
                                      days.add("SUN");
                                    } else {
                                      days.remove("SUN");
                                    }
                                    setState(() {});
                                  },
                                  selectedColor: primaryContainer,
                                  showCheckmark: false,
                                )
                              ],
                            ),
                          ),
                          RoundedInputField(
                            hintText: "Detalii",
                            icon: Icons.note,
                            onChanged: (value) {},
                            controller: _details,
                          ),
                          RoundedButton(
                            text: "SALVEAZĂ",
                            press: () {
                              if (_formKey.currentState!.validate()) {
                                _addMedication();
                              }
                            },
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              )
            : Container(
                height: size.height,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Positioned(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              "MEDICAMENT",
                              style: GoogleFonts.montserrat(
                                color: primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          RoundedInputField(
                            hintText: "Medicament",
                            onChanged: (value) {},
                            validator: validateMedication,
                            controller: _medication,
                            icon: Icons.medication,
                          ),
                          RoundedInputField(
                            hintText: "Ora",
                            icon: Icons.alarm,
                            controller: _time,
                            onChanged: (value) {},
                            tap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              _selectTime(context);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Introduceți ora";
                              } else {
                                return null;
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: Row(
                              children: [
                                FilterChip(
                                  label: Text("LU"),
                                  selected: widget.mon,
                                  onSelected: (value) {
                                    widget.mon = value;
                                    if (widget.mon) {
                                      days.add("MON");
                                    } else {
                                      days.remove("MON");
                                    }
                                    setState(() {});
                                  },
                                  selectedColor: primaryContainer,
                                  showCheckmark: false,
                                ),
                                FilterChip(
                                  label: Text("MA"),
                                  selected: widget.tue,
                                  onSelected: (value) {
                                    widget.tue = value;
                                    if (widget.tue) {
                                      days.add("TUE");
                                    } else {
                                      days.remove("TUE");
                                    }
                                    setState(() {});
                                  },
                                  selectedColor: primaryContainer,
                                  showCheckmark: false,
                                ),
                                FilterChip(
                                  label: Text("MI"),
                                  selected: widget.wed,
                                  onSelected: (value) {
                                    widget.wed = value;
                                    if (widget.wed) {
                                      days.add("WED");
                                    } else {
                                      days.remove("WED");
                                    }
                                    setState(() {});
                                  },
                                  selectedColor: primaryContainer,
                                  showCheckmark: false,
                                ),
                                FilterChip(
                                  label: Text("JO"),
                                  selected: widget.thu,
                                  onSelected: (value) {
                                    widget.thu = value;
                                    if (widget.thu) {
                                      days.add("THU");
                                    } else {
                                      days.remove("THU");
                                    }
                                    setState(() {});
                                  },
                                  selectedColor: primaryContainer,
                                  showCheckmark: false,
                                ),
                                FilterChip(
                                  label: Text("VI"),
                                  selected: widget.fri,
                                  onSelected: (value) {
                                    widget.fri = value;
                                    if (widget.fri) {
                                      days.add("FRI");
                                    } else {
                                      days.remove("FRI");
                                    }
                                    setState(() {});
                                  },
                                  selectedColor: primaryContainer,
                                  showCheckmark: false,
                                ),
                                FilterChip(
                                  label: Text("SA"),
                                  selected: widget.sat,
                                  onSelected: (value) {
                                    widget.sat = value;
                                    if (widget.sat) {
                                      days.add("SAT");
                                    } else {
                                      days.remove("SAT");
                                    }
                                    setState(() {});
                                  },
                                  selectedColor: primaryContainer,
                                  showCheckmark: false,
                                ),
                                FilterChip(
                                  label: Text("DU"),
                                  selected: widget.sun,
                                  onSelected: (value) {
                                    widget.sun = value;
                                    if (widget.sun) {
                                      days.add("SUN");
                                    } else {
                                      days.remove("SUN");
                                    }
                                    setState(() {});
                                  },
                                  selectedColor: primaryContainer,
                                  showCheckmark: false,
                                )
                              ],
                            ),
                          ),
                          RoundedInputField(
                            hintText: "Detalii",
                            icon: Icons.note,
                            onChanged: (value) {},
                            controller: _details,
                          ),
                          RoundedButton(
                            text: "SALVEAZĂ",
                            press: () {
                              if (_formKey.currentState!.validate()) {
                                _updateMedication();
                              }
                            },
                          ),
                          RoundedButton(
                            text: "ȘTERGE",
                            press: () {
                              _deleteMedication();
                            },
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (picked != null) {
      _time.text = '${picked.hour}:${picked.minute}';
    }
  }

  void _addMedication() {
    _medicationService.addMedicationPatient(
      medication: _medication.text,
      time: _time.text,
      days: days,
      patientUid: widget.patientUid,
      details: _details.text,
      context: context,
    );
  }

  void _updateMedication() {
    _medicationService.updateMedicationPatient(
      medication: _medication.text,
      time: _time.text,
      days: days,
      patientUid: widget.patientUid,
      docId: widget.documentId!,
      details: _details.text,
      context: context,
      notificationId: notificationId,
    );
  }

  void _deleteMedication() {
    _medicationService.deleteMedicationPatient(
        patientUid: widget.patientUid,
        docId: widget.documentId!,
        context: context,
        notificationId: notificationId);
  }

  _setFields(String patientUid, String docId) async {
    DocumentSnapshot<Map<String, dynamic>> medication = await FirebaseFirestore
        .instance
        .collection('patients')
        .doc(patientUid)
        .collection('medication')
        .doc(docId)
        .get();
    if (medication.exists) {
      setState(() {
        _medication.text = medication.data()!['medication'];
        _time.text = medication.data()!['time'];
        notificationId = medication.data()!['notification_id'];
        if (medication.data()!['details'] != null)
          _details.text = medication.data()!['details'];
        List selectedDays = medication.data()!['days'];
        if (selectedDays.contains("MON")) {
          widget.mon = true;
          days.add('MON');
        }
        if (selectedDays.contains("TUE")) {
          widget.tue = true;
          days.add('TUE');
        }
        if (selectedDays.contains("WED")) {
          widget.wed = true;
          days.add("WED");
        }
        if (selectedDays.contains("THU")) {
          widget.thu = true;
          days.add("THU");
        }
        if (selectedDays.contains("FRI")) {
          widget.fri = true;
          days.add("FRI");
        }
        if (selectedDays.contains("SAT")) {
          widget.sat = true;
          days.add("SAT");
        }
        if (selectedDays.contains("SUN")) {
          widget.sun = true;
          days.add("SUN");
        }

        days = days.toSet().toList();
      });
    }
  }
}
