import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/login_screen.dart';
import 'package:bp_track/widgets/common/already_have_account.dart';
import 'package:bp_track/widgets/common/rounded_button.dart';
import 'package:bp_track/widgets/common/rounded_input_field.dart';
import 'package:bp_track/widgets/common/rounded_password_field.dart';
import 'package:flutter/material.dart';

class PatientSignUpScreen extends StatefulWidget {
  const PatientSignUpScreen({Key? key}) : super(key: key);

  @override
  _PatientSignUpState createState() => _PatientSignUpState();
}

class _PatientSignUpState extends State<PatientSignUpScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController dob = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    dob.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: formKey,
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
                      hintText: "Personal Numeric Code",
                      onChanged: (value) {},
                    ),
                    RoundedInputField(
                      hintText: "Date of Birth",
                      icon: Icons.calendar_month,
                      controller: dob,
                      onChanged: (value) {},
                      tap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _selectDate(context);
                      },
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
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
