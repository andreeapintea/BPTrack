import 'package:bp_track/constants.dart';
import 'package:flutter/material.dart';

import 'text_field_container.dart';

class RoundedPasswordInput extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  const RoundedPasswordInput({
    Key? key,
    this.onChanged,
    this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: onPrimaryContainer,
          ),
          border: InputBorder.none,
        ),
        controller: controller,
      ),
    );
  }
}
