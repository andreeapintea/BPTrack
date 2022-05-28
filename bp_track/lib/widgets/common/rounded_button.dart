import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? press;
  final Color color, textColor;

  const RoundedButton({
    Key? key,
    this.text = "default",
    this.press,
    this.color = primary,
    this.textColor = onPrimary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: TextButton(
          onPressed: press,
          child: Text(
            text,
            style: GoogleFonts.workSans(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: 15,
              letterSpacing: 1.25,
            ),
          ),
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
              backgroundColor: MaterialStateProperty.all<Color>(color)),
        ),
      ),
    );
  }
}
