import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/account_type_screen.dart';
import 'package:bp_track/screens/login_screen.dart';
import 'package:bp_track/screens/patient_signup_screen.dart';
import 'package:bp_track/widgets/common/rounded_button.dart';
import 'package:flutter/material.dart';

class WelcomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
              child: Column(
            children: [
              Image.asset(
                "assets/logo/nobg_logo.png",
                width: size.width * 0.9,
              ),
              RoundedButton(
                text: "LOGIN",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    }),
                  );
                },
              ),
              RoundedButton(
                  text: "SIGN UP",
                  color: primaryContainer,
                  textColor: onPrimaryContainer,
                  press: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AccountTypeScreen();
                    }));
                  }),
            ],
          )),
        ],
      ),
    );
  }
}
