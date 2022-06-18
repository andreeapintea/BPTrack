import 'package:bp_track/utilities/constants.dart';
import 'package:bp_track/services/medication_service.dart';
import 'package:bp_track/utilities/validators.dart';
import 'package:bp_track/widgets/common/rounded_button.dart';
import 'package:bp_track/widgets/common/rounded_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final _medicationService = MedicationService();

class MedicationScreenDoctor extends StatefulWidget {
  final bool isEdit;
  final String? documentId;
  final String patientUid;

  MedicationScreenDoctor({
    Key? key,
    required this.isEdit,
    this.documentId,
    required this.patientUid,
  }) : super(key: key);

  @override
  _MedicationScreenDoctorState createState() => _MedicationScreenDoctorState();
}

class _MedicationScreenDoctorState extends State<MedicationScreenDoctor> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _medication = TextEditingController();
  TextEditingController _details = TextEditingController();

  @override
  void dispose() {
    super.dispose();
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
        title: widget.isEdit
            ? Text(
                "Modifică medicament",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  letterSpacing: 0.15,
                ),
              )
            : Text(
                "Adaugă medicament",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  letterSpacing: 0.15,
                ),
              ),
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

  void _addMedication() {
    _medicationService.addMedicationDoctor(
      medication: _medication.text,
      patientUid: widget.patientUid,
      details: _details.text,
      context: context,
    );
  }

  void _updateMedication() {
    _medicationService.updateMedicationDoctor(
      medication: _medication.text,
      patientUid: widget.patientUid,
      docId: widget.documentId!,
      details: _details.text,
      context: context,
    );
  }

  void _deleteMedication() {
    _medicationService.deleteMedicationDoctor(
      patientUid: widget.patientUid,
      docId: widget.documentId!,
      context: context,
    );
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
        if (medication.data()!['details'] != null) {
          _details.text = medication.data()!['details'];
        }
      });
    }
  }
}
