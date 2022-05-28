import 'package:bp_track/constants.dart';
import 'package:bp_track/services/firebase_auth_methods.dart';
import 'package:bp_track/widgets/common/rounded_button.dart';
import 'package:bp_track/widgets/common/rounded_input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       appBar: AppBar(
        title: Text("Resetează parola",
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          letterSpacing: 0.15,
        ),),
        backgroundColor: primary,
      ),
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
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        "RESETEAZĂ PAROLA",
                        style: GoogleFonts.montserrat(
                                color: primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                letterSpacing: 0,
                              ),
                      ),
                    ),
                    Text("Introdu adresa de email pentru a reseta parola",
                    style: GoogleFonts.workSans(
                      color: primary,
                    ),),
                    const Padding(padding: EdgeInsets.all(10)),
                    RoundedInputField(
                      hintText: "Email",
                      onChanged: (value) {},
                      controller: _emailController,
                    ),
                    RoundedButton(
                      text: "RESERTARE PAROLĂ",
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          _resetPassword();
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

  void _resetPassword() async {
    FirebaseAuthMethods(FirebaseAuth.instance).resetPassword(
        email: _emailController.text,
        context: context);
  }
}
