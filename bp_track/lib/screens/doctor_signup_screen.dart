import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/login_screen.dart';
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
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
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
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: primary),
                      ),
                    ),
                    RoundedInputField(
                      hintText: "First Name",
                      onChanged: (value) {},
                    ),
                    RoundedInputField(
                      hintText: "Last Name",
                      onChanged: (value) {},
                    ),
                    RoundedInputField(
                      hintText: "County",
                      icon: Icons.location_city,
                      onChanged: (value) {},
                    ),
                    RoundedInputField(
                      hintText: "Department",
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
                    ),
                    RoundedButton(
                      text: "SIGN UP",
                      press: () {},
                    ),
                    AlreadyHaveAccountCheck(
                      press: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }));
                      },
                      login: false,
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
}


