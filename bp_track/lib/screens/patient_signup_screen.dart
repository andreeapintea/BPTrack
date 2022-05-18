import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/login_screen.dart';
import 'package:bp_track/services/firebase_auth_methods.dart';
import 'package:bp_track/utilities/validators.dart';
import 'package:bp_track/widgets/common/already_have_account.dart';
import 'package:bp_track/widgets/common/or_divider.dart';
import 'package:bp_track/widgets/common/rounded_button.dart';
import 'package:bp_track/widgets/common/rounded_input_field.dart';
import 'package:bp_track/widgets/common/rounded_password_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class PatientSignUpScreen extends StatefulWidget {
  const PatientSignUpScreen({Key? key}) : super(key: key);

  @override
  _PatientSignUpState createState() => _PatientSignUpState();
}

class _PatientSignUpState extends State<PatientSignUpScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dob = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
    //dob.dispose();
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        "ÎNREGISTRARE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: primary),
                      ),
                    ),
                    // RoundedInputField(
                    //   hintText: "Nume",
                    //   onChanged: (value) {},
                    // ),
                    // RoundedInputField(
                    //   hintText: "Prenume",
                    //   onChanged: (value) {},
                    // ),
                    // RoundedInputField(
                    //   hintText: "CNP",
                    //   onChanged: (value) {},
                    // ),
                    // RoundedInputField(
                    //   hintText: "Data nașterii",
                    //   icon: Icons.calendar_month,
                    //   controller: dob,
                    //   onChanged: (value) {},
                    //   tap: () {
                    //     FocusScope.of(context).requestFocus(new FocusNode());
                    //     _selectDate(context);
                    //   },
                    // ),
                    RoundedInputField(
                      hintText: "Email",
                      icon: Icons.email,
                      controller: _email,
                      onChanged: (value) {},
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
                      hintText: "Confirmă parola",
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
                          _signUpPatient();
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
                    OrDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SignInButton(
                          Buttons.Google,
                          onPressed: () {},
                          text: "Înregistrare cu Google",
                        )
                      ],
                    )
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUpPatient() async {
    FirebaseAuthMethods(FirebaseAuth.instance).signUpWithEmailPatient(
        email: _email.text, password: _password.text, context: context);
  }
}
