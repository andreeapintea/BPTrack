import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/login_screen.dart';
import 'package:bp_track/services/doctors_service.dart';
import 'package:bp_track/services/firebase_auth_methods.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:bp_track/utilities/utilities.dart';
import 'package:bp_track/utilities/validators.dart';
import 'package:bp_track/widgets/common/already_have_account.dart';
import 'package:bp_track/widgets/common/rounded_button.dart';
import 'package:bp_track/widgets/common/rounded_input_field.dart';
import 'package:bp_track/widgets/common/rounded_password_field.dart';
import 'package:bp_track/widgets/common/text_field_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final _doctorsService = DoctorsService();

class DoctorSignUpScreen extends StatefulWidget {
  const DoctorSignUpScreen({Key? key}) : super(key: key);

  @override
  _DoctorSignUpState createState() => _DoctorSignUpState();
}

class _DoctorSignUpState extends State<DoctorSignUpScreen> {
  //add controllers here
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  TextEditingController _nume = TextEditingController();
  TextEditingController _prenume = TextEditingController();
  TextEditingController _department = TextEditingController();
  TextEditingController _phone = TextEditingController();
  var _selectedCounty = counties[0];
  var _selectedDepartment = departments[0];

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
                    const Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Text(
                        "ÎNREGISTRARE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: primary),
                      ),
                    ),
                    RoundedInputField(
                      hintText: "Nume",
                      onChanged: (value) {},
                      controller: _nume,
                      validator: validateName,
                    ),
                    RoundedInputField(
                      hintText: "Prenume",
                      onChanged: (value) {},
                      controller: _prenume,
                      validator: validateName,
                    ),
                    // RoundedInputField(
                    //   hintText: "Județ",
                    //   icon: Icons.location_city,
                    //   onChanged: (value) {},
                    // ),
                    TextFieldContainer(
                      child: DropdownButtonFormField(
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCounty = newValue!;
                          });
                        },
                        value: _selectedCounty,
                        items: counties.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                            icon: Icon(
                              Icons.location_city,
                              color: onPrimaryContainer,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    TextFieldContainer(
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDepartment = newValue!;
                          });
                        },
                        value: _selectedDepartment,
                        items: departments.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                            icon: Icon(
                              Icons.medical_services,
                              color: onPrimaryContainer,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    // RoundedInputField(
                    //   hintText: "Specialitate",
                    //   icon: Icons.medical_services,
                    //   onChanged: (value) {},
                    //   controller: _department,
                    // ),
                    RoundedInputField(
                      hintText: "Telefon",
                      icon: Icons.phone,
                      onChanged: (value) {},
                      controller: _phone,
                      validator: validatePhoneNumber,
                    ),
                    RoundedInputField(
                      hintText: "Email",
                      icon: Icons.email,
                      onChanged: (value) {},
                      controller: _email,
                      validator: validateEmail,
                    ),
                    RoundedPasswordInput(
                      onChanged: (value) {},
                      hintText: "Parolă",
                      controller: _password,
                      validator: validatePassword,
                    ),
                    RoundedPasswordInput(
                      onChanged: (value) {},
                      hintText: "Confirmare parolă",
                      controller: _confirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Reintroduceți parola";
                        }
                        if (value != _password.text) {
                          return "Parolele nu se potrivesc!";
                        }
                        return null;
                      },
                    ),
                    RoundedButton(
                      text: "ÎNREGISTRARE",
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          _signUpDoctor();
                        }
                      },
                    ),
                    AlreadyHaveAccountCheck(
                      press: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }));
                      },
                      login: false,
                    ),
                    const Padding(padding: EdgeInsets.all(10.0))
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUpDoctor() async {
    var ok = await checkDoctorExists(
        _nume.text, _prenume.text, _selectedDepartment, _selectedCounty);
    if (ok) {
      FirebaseAuthMethods(FirebaseAuth.instance).signUpDoctor(
          email: _email.text, password: _password.text, context: context);
      var token = await FirebaseMessaging.instance.getToken();
      _doctorsService.addDoctor(
          nume: _nume.text,
          prenume: _prenume.text,
          county: _selectedCounty,
          phone: _phone.text,
          department: _selectedDepartment,
          token: token,
          context: context);
    } else {
      showSnackbar(context, "Doctorul nu a fost găsit în baza de date!");
    }
  }
}
