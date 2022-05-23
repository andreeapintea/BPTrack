import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/welcome_screen.dart';
import 'package:bp_track/services/bp_entries_service.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _bpService = BPEntriesService();

class DoctorHomepageScreen extends StatelessWidget {
  const DoctorHomepageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((value) {

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => WelcomeScreen()),
                          (Route<dynamic> route) => false);
                    });
                    showSnackbar(context, "V-ați deconectat cu succes");
                  },
                  child: const Text("LOGOUT")),
          ),
        ],
      ),
    );
  }
}

Color getTileColor(String category) {
  if (category == "hypo") {
    return Color(0xFF9dbdd4);
  }
  if (category == "normal") {
    return Color(0xFF78c1a3);
  }
  if (category == "high") {
    return Color(0xFFc1cbb1);
  }
  if (category == "stage1") {
    return Color(0xFFffdbc2);
  }
  if (category == "stage2") {
    return Color(0xFFf2b4a3);
  }
  if (category == "stage3") {
    return Color(0xFFf38989);
  }
  return Colors.white;
}
