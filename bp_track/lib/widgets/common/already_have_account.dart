import 'package:bp_track/constants.dart';
import 'package:flutter/material.dart';

class AlreadyHaveAccountCheck extends StatelessWidget {
  final bool login;
  final Function()? press;
  const AlreadyHaveAccountCheck({
    Key? key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Nu ai cont? " : "Ai deja un cont? ",
          style: TextStyle(color: primary),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Înregistrare" : "Autentificare",
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
