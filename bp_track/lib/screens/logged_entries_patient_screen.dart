import 'package:bp_track/constants.dart';
import 'package:bp_track/services/bp_entries_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _bpService = BPEntriesService();

class LoggedEntriesPatientScreen extends StatelessWidget {
  const LoggedEntriesPatientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      return Center(
                        child: ListTile(
                          title: Text(
                            "${dt.day}.${dt.month}.${dt.year} ${dt.hour}:${dt.minute}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Sistolică: ${entry['systolic']} Diastolică: ${entry['diastolic']} Puls: ${entry['pulse']}",
                            style: TextStyle(fontSize: 15),
                          ),
                          tileColor: tileColor,
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
