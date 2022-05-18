import 'package:bp_track/constants.dart';
import 'package:bp_track/widgets/common/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final Function()? tap;
  final FormFieldValidator<String>? validator;
  const RoundedInputField(
      {Key? key,
      this.hintText,
      this.icon = Icons.person,
      this.onChanged,
      this.controller,
      this.tap,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
            hintText: hintText,
            icon: Icon(
              icon,
              color: onPrimaryContainer,
            ),
            border: InputBorder.none),
        controller: controller,
        onTap: tap,
        validator: validator,
      ),
    );
  }
}
