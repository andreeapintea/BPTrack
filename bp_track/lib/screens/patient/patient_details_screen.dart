import 'package:bp_track/utilities/constants.dart';
import 'package:bp_track/services/patients_service.dart';
import 'package:bp_track/utilities/validators.dart';
import 'package:bp_track/widgets/common/rounded_button.dart';
import 'package:bp_track/widgets/common/rounded_input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientDetailsScreen extends StatefulWidget {
  const PatientDetailsScreen({Key? key}) : super(key: key);

  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetailsScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dob = TextEditingController();
  TextEditingController _nume = TextEditingController();
  TextEditingController _prenume = TextEditingController();
  TextEditingController _cnp = TextEditingController();
  TextEditingController _phone = TextEditingController();
  final _patientsService = PatientsService();

  @override
  void dispose() {
    super.dispose();
    dob.dispose();
    _nume.dispose();
    _prenume.dispose();
    _cnp.dispose();
    _phone.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
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
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        "DETALII PACIENT",
                        style: GoogleFonts.montserrat(
                                color: primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                letterSpacing: 0,
                              ),
                      ),
                    ),
                    RoundedInputField(
                      hintText: "Nume",
                      onChanged: (value) {},
                      validator: validateName,
                      controller: _nume,
                    ),
                    RoundedInputField(
                      hintText: "Prenume",
                      onChanged: (value) {},
                      validator: validateName,
                      controller: _prenume,
                    ),
                    RoundedInputField(
                      hintText: "CNP",
                      onChanged: (value) {},
                      validator: validateCNP,
                      controller: _cnp,
                    ),
                    RoundedInputField(
                      hintText: "Telefon",
                      onChanged: (value) {},
                      icon: Icons.phone,
                      validator: validatePhoneNumber,
                      controller: _phone,
                    ),
                    RoundedInputField(
                      hintText: "Data nașterii",
                      icon: Icons.calendar_month,
                      controller: dob,
                      onChanged: (value) {},
                      tap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _selectDate(context);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Introduceți data nașterii";
                        } else {
                          return null;
                        }
                      },
                    ),
                    RoundedButton(
                      text: "SALVEAZĂ",
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          _patientsService.addPatient(
                              nume: _nume.text,
                              prenume: _prenume.text,
                              cnp: _cnp.text,
                              phone: _phone.text,
                              dob: dob.text,
                              context: context);
                        }
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1930),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      dob.text = '${picked.day}-${picked.month}-${picked.year}';
    }
  }
}
