import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showSnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text,
    style: GoogleFonts.workSans(
      fontWeight: FontWeight.normal,
      fontSize: 11,
      letterSpacing: 0.4,
    ),))
  );
}
