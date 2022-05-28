import 'package:bp_track/constants.dart';
import 'package:bp_track/services/bp_entries_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

final _bpService = BPEntriesService();

class LoggedEntriesPatientScreen extends StatelessWidget {
  const LoggedEntriesPatientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       appBar: AppBar(
        title: Text("Valori logate",
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          letterSpacing: 0.15,
        ),),
        backgroundColor: primary,
        automaticallyImplyLeading: false,
      ),
      body: Row(
        children: [
          Expanded(
              child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  _bpService.getEntries(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!.docs.map((entry) {
                      DateTime dt = (entry['time'] as Timestamp).toDate();
                      var tileColor = getTileColor(entry['category']);
                      var tagText = getTagText(entry['category']);
                      var formattedDay = dt.day.toString().padLeft(2, "0");
                      var formattedMonth = dt.month.toString().padLeft(2, "0");
                      var formattedHour= dt.hour.toString().padLeft(2, "0");
                      var formattedMinute = dt.minute.toString().padLeft(2, "0");
                      return Center(
                        child: Card(
                          color: tileColor,
                          child: ListTile(
                            title: Text(
                              "${formattedDay}.${formattedMonth}.${dt.year} ${formattedHour}:${formattedMinute}",
                              style: GoogleFonts.workSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                letterSpacing: 0.5,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size.height * 0.007,
                                ),
                                Text(
                                  "Sistolică: ${entry['systolic']} Diastolică: ${entry['diastolic']} Puls: ${entry['pulse']}",
                                  style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    letterSpacing: 0.25,
                                    color: onSurface,
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    tagText,
                                    style: GoogleFonts.workSans(
                                      color: onSurface,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                  backgroundColor: tileColor,
                                  shape: StadiumBorder(
                                      side: BorderSide(
                                    color: onSurface,
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(color: primary),
                );
              },
            ),
          ))
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

String getTagText(String category) {
  if (category == "hypo") {
    return "Hipotensiune";
  }
  if (category == "normal") {
    return "Normală";
  }
  if (category == "high") {
    return "Înaltă";
  }
  if (category == "stage1") {
    return "Hipertensiune grad 1";
  }
  if (category == "stage2") {
    return "Hipertensiune grad 2";
  }
  if (category == "stage3") {
    return "Hipertensiune grad 3";
  }
  return "Clasificarea a eșuat";
}
