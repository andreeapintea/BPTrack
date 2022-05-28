import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/account_type_screen.dart';
import 'package:bp_track/screens/forgot_password_screen.dart';
import 'package:bp_track/services/firebase_auth_methods.dart';
import 'package:bp_track/widgets/common/already_have_account.dart';
import 'package:bp_track/widgets/common/or_divider.dart';
import 'package:bp_track/widgets/common/rounded_button.dart';
import 'package:bp_track/widgets/common/rounded_input_field.dart';
import 'package:bp_track/widgets/common/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
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
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        "AUTENTIFICARE",
                        style: GoogleFonts.montserrat(
                                color: primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                letterSpacing: 0,
                              ),
                      ),
                    ),
                    RoundedInputField(
                      hintText: "Email",
                      onChanged: (value) {},
                      controller: _emailController,
                    ),
                    RoundedPasswordInput(
                      onChanged: (value) {},
                      controller: _passwordController,
                      hintText: "Parolă",
                    ),
                    RoundedButton(
                      text: "AUTENTIFICARE",
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(1)),
                    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const ForgotPasswordScreen();
                          }),
                        );
          },
          child: Text(
            "Mi-am uitat parola",
            style: GoogleFonts.workSans(
            color: primary,
          ),
          ),
        ),
      ],
    ),
    Padding(padding: EdgeInsets.all(5)),
                    AlreadyHaveAccountCheck(
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return AccountTypeScreen();
                          }),
                        );
                      },
                    ),
                    OrDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SignInButton(
                          Buttons.Google,
                          onPressed: () {
                            _googleLogin();
                          },
                          text: "Autentificare cu Google",
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

  void _login() async {
    FirebaseAuthMethods(FirebaseAuth.instance).loginWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
        context: context);
  }

  void _googleLogin() async {
    FirebaseAuthMethods(FirebaseAuth.instance).signInWithGoogle(context);
  }
}
