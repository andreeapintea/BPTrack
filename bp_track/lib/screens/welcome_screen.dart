import 'package:bp_track/components/welcome_screen_body.dart';
import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/bottom_nav_patient_screen.dart';
import 'package:bp_track/screens/homepage_patient_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  WelcomeBody(),);
      }
  }