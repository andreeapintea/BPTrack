import 'package:bp_track/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'text_field_container.dart';

class RoundedPasswordInput extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final Function()? tap;
  const RoundedPasswordInput({Key? key, this.onChanged, this.controller, this.hintText, this.validator, this.tap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          hintText: hintText,
          icon: const Icon(
            Icons.lock,
            color: onPrimaryContainer,
          ),
          border: InputBorder.none,
        ),
        controller: controller,
        validator: validator,
        onTap: tap,
        autocorrect: false,
        enableSuggestions: false,
        style: GoogleFonts.workSans(),
      ),
    );
  }
}
