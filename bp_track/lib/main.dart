import 'package:bp_track/screens/account_type_screen.dart';
import 'package:flutter/material.dart';
import 'package:bp_track/screens/welcome_screen.dart';
import 'package:bp_track/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BPTrack',
      theme: ThemeData(
        primaryColor: primary,
        scaffoldBackgroundColor: background,
      ),
      home: WelcomeScreen(),
    );
  }
}
