import 'package:bp_track/utilities/constants.dart';
import 'package:bp_track/widgets/common/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final Function()? tap;
  final FormFieldValidator<String>? validator;
  final bool? isEditable;
  final String? value;
  const RoundedInputField(
      {Key? key,
      this.hintText,
      this.icon = Icons.person,
      this.onChanged,
      this.controller,
      this.tap,
      this.validator,
      this.isEditable = true,
      this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        maxLines: null,
        decoration: InputDecoration(
            labelText: hintText,
            labelStyle: GoogleFonts.workSans(
              color: onPrimaryContainer,
            ),
            icon: Icon(
              icon,
              color: onPrimaryContainer,
            ),
            border: InputBorder.none),
        controller: controller,
        onTap: tap,
        validator: validator,
        enabled: isEditable,
        initialValue: value,
        style: GoogleFonts.workSans(),
      ),
    );
  }
}
