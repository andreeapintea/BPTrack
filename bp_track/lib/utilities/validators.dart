import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return "Te rog introdu o adresă validă de email!";
  }
  if (!EmailValidator.validate(email)) return "Adresa de email nu este validă!";
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Introduceți parola';
  } else {
    if (password.length < 8) {
      return 'Parola trebuie să aiba minim 8 caractere!';
    } else {
      return null;
    }
  }
}

String? validateName(String? name) {
  RegExp nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9]');

  if (name == null || name.isEmpty) {
    return "Introduceți numele";
  } else if (name.length < 2) {
    return "Numele nu poate avea doar un caracter!";
  } else if (nameRegExp.hasMatch(name)) {
    return "Numele trebuie să conțină doar litere!";
  } else {
    return null;
  }
}

String? validateMedication(String? name) {

  if (name == null || name.isEmpty) {
    return "Introduceți medicamentul";
  } else if (name.length < 2) {
    return "Medicamentul nu poate avea doar un caracter!";
  }  else {
    return null;
  }
}

String? validateDepartment(String? name) {
  RegExp nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');

  if (name == null || name.isEmpty) {
    return "Introduceți numele";
  } else if (name.length < 2) {
    return "Județul nu poate avea doar un caracter!";
  } else if (nameRegExp.hasMatch(name)) {
    return "Numele trebuie să conțină doar litere!";
  } else {
    return null;
  }
}

String? validateCNP(String? cnp) {
  RegExp cnpRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-]');
  if (cnp == null || cnp.isEmpty) {
    return "Introduceți CNP-ul";
  } else if (cnp.length != 13) {
    return "CNP-ul nu este corect";
  } else if (cnpRegExp.hasMatch(cnp)) {
    return "CNP-ul nu poate conține doar cifre";
  } else {
    return null;
  }
}

String? validatePhoneNumber(String? number) {
  RegExp numberRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-]');
  if (number == null || number.isEmpty) {
    return "Introduceți numărul de telefon";
  } else if (number.length != 10) {
    return "Numărul de telefon nu este corect";
  } else if (numberRegExp.hasMatch(number)) {
    return "Numărul nu poate conține doar cifre";
  } else {
    return null;
  }
}
