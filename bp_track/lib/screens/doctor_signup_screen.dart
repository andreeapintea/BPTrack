import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/login_screen.dart';
import 'package:bp_track/utilities/validators.dart';
import 'package:bp_track/widgets/common/already_have_account.dart';
import 'package:bp_track/widgets/common/rounded_button.dart';
import 'package:bp_track/widgets/common/rounded_input_field.dart';
import 'package:bp_track/widgets/common/rounded_password_field.dart';
import 'package:flutter/material.dart';

class DoctorSignUpScreen extends StatefulWidget {
  const DoctorSignUpScreen({Key? key}) : super(key: key);

  @override
  _DoctorSignUpState createState() => _DoctorSignUpState();
}

class _DoctorSignUpState extends State<DoctorSignUpScreen> {
  //add controllers here
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  
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
                    ),
                    RoundedInputField(
                      hintText: "Prenume",
                      onChanged: (value) {},
                    ),
                    RoundedInputField(
                      hintText: "Județ",
                      icon: Icons.location_city,
                      onChanged: (value) {},
                    ),
                    RoundedInputField(
                      hintText: "Departament",
                      icon: Icons.medical_services,
                      onChanged: (value) {},
                    ),
                    RoundedInputField(
                      hintText: "Email",
                      icon: Icons.email,
                      onChanged: (value) {},
                    ),
                    RoundedPasswordInput(
                      onChanged: (value) {},
                      hintText: "Parolă",
                    ),
                     RoundedPasswordInput(
                      onChanged: (value) {},
                      hintText: "Confirmare parolă",
                    ),
                    RoundedButton(
                      text: "ÎNREGISTRARE",
                      press: () {
                        if (_formKey.currentState!.validate()) {
                        }
                      },
                    ),
                    AlreadyHaveAccountCheck(
                      press: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
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
}


