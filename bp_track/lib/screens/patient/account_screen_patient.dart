import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bp_track/utilities/constants.dart';
import 'package:bp_track/screens/patient/select_doctor_screen.dart';
import 'package:bp_track/screens/welcome_screen.dart';
import 'package:bp_track/services/bp_entries_service.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:bp_track/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

final _bpService = BPEntriesService();

class PatientSettingsScreen extends StatefulWidget {
  const PatientSettingsScreen({Key? key}) : super(key: key);

  @override
  State<PatientSettingsScreen> createState() => _PatientSettingsScreenState();
}

class _PatientSettingsScreenState extends State<PatientSettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primary,
        title: Text("Profil",
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          letterSpacing: 0.15,
        ),),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: const Text("Exportă ca CSV"),
                onTap: () {
                  generateCsvFile(context, FirebaseAuth.instance.currentUser!.uid);
                },
              )
            ];
          })
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseAuth.instance.currentUser != null
            ? FirebaseFirestore.instance
                .collection('patients')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots()
            : null,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: primary),
            );
          }
          return FirebaseAuth.instance.currentUser == null
              ? const Center()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        SizedBox(
                          height: size.height * 0.335,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: size.height * 0.25,
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.elliptical(25, 10),
                                    bottomRight: Radius.elliptical(25, 10)),
                                color: secondaryColor),
                          ),
                        ),
                        Positioned(
                          top: size.height * 0.18,
                          child: SizedBox(
                            height: size.width * 0.25,
                            width: size.width * 0.25,
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 5, color: Colors.white),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: FadeInImage(
                                  placeholder: const AssetImage(
                                      'assets/images/placeholder.png'),
                                  image: FirebaseAuth
                                              .instance.currentUser!.photoURL !=
                                          null
                                      ? NetworkImage(FirebaseAuth
                                          .instance.currentUser!.photoURL!)
                                      : const AssetImage(
                                              'assets/images/placeholder.png')
                                          as ImageProvider,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.12,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(size.height * 0.009)),
                              Text(
                                "${snapshot.data!['nume'].toUpperCase()} ${snapshot.data!['prenume'].toUpperCase()}",
                                style: GoogleFonts.montserrat(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(size.height * 0.008)),
                              snapshot.data!['doctor_uid'] == null ||
                                      snapshot.data!['doctor_uid'].isEmpty
                                  ? const SizedBox.shrink()
                                  : StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection('doctors')
                                          .doc(snapshot.data!['doctor_uid'])
                                          .snapshots(),
                                      builder: (context, snapshot2) {
                                        if (snapshot2.hasData) {
                                          return GestureDetector(
                                            onTap: () {
                                              launchUrlString(
                                                  "tel:${snapshot2.data!['phone']}");
                                            },
                                            child: Text(
                                              "Medic: ${snapshot2.data!['nume'].toUpperCase()} ${snapshot2.data!['prenume'].toUpperCase()}",
                                              style: GoogleFonts.workSans(),
                                            ),
                                          );
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                                color: primary),
                                          );
                                        }
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: _bpService
                              .getEntries(FirebaseAuth.instance.currentUser!.uid),
                          builder: (context, snapshot3) {
                            if (snapshot3.hasData) {
                              double avgSys = 0.0;
                              double avgDias = 0.0;
                              double avgPulse = 0.0;
                              snapshot3.data!.docs.forEach((entry) {
                                avgSys += entry['systolic'].toDouble();
                                avgDias += entry['diastolic'].toDouble();
                                avgPulse += entry['pulse'].toDouble();
                              });
                              avgSys =
                                  avgSys / snapshot3.data!.docs.length.toDouble();
                              avgDias = avgDias /
                                  snapshot3.data!.docs.length.toDouble();
                              avgPulse = avgPulse /
                                  snapshot3.data!.docs.length.toDouble();
                                  
                              return SizedBox(
                                height: size.height * 0.16,
                                width: double.infinity,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "SISTOLICĂ\nMEDIE",
                                            style: GoogleFonts.workSans(
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          AnimatedTextKit(
                                            animatedTexts: [
                                              WavyAnimatedText(
                                                avgSys.toStringAsFixed(0),
                                                textStyle: GoogleFonts.montserrat(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 1.2,
                                                    color: Colors.red),
                                              ),
                      
                                            ],
                                            isRepeatingAnimation: false,
                                          ),
                                          Text("mmHg",  style: GoogleFonts.workSans(
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1.2,
                                            ),)
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "DIASTOLICĂ\nMEDIE",
                                            style: GoogleFonts.workSans(
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          AnimatedTextKit(
                                            animatedTexts: [
                                              WavyAnimatedText(
                                                avgDias.toStringAsFixed(0),
                                                textStyle: GoogleFonts.montserrat(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 1.2,
                                                    color: Colors.blue),
                                              ),
                                            ],
                                            isRepeatingAnimation: false,
                                          ),
                                          Text("mmHg",  style: GoogleFonts.workSans(
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1.2,
                                            ),)
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "PULS\nMEDIU",
                                            style: GoogleFonts.workSans(
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          AnimatedTextKit(
                                            animatedTexts: [
                                              WavyAnimatedText(
                                                avgPulse.toStringAsFixed(0),
                                                textStyle: GoogleFonts.montserrat(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 1.2,
                                                    color: Colors.green),
                                              ),
                                            ],
                                            isRepeatingAnimation: false,
                                          ),
                                          Text("bpm",  style: GoogleFonts.workSans(
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1.2,
                                            ),)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(color: primary),
                            );
                          }),
                    ),
                    const Spacer(),
                    Visibility(
                      visible: snapshot.data!['doctor_uid'] == null ||
                          snapshot.data!['doctor_uid'].isEmpty,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 0),
                        width: size.width * 0.8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const SelectDoctorScreen();
                              }));
                            },
                            child:  Text(
                              "Selectează medic",
                              style: GoogleFonts.workSans(
              color: onPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 15,
              letterSpacing: 1.25,
                        ),
                            ),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 40)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(primary)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: size.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: TextButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut().then((value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => WelcomeScreen()),
                                  (Route<dynamic> route) => false);
                            });
                            showSnackbar(context, "V-ați deconectat cu succes");
                          },
                          child: Text(
                            "DECONECTARE",
                            style: GoogleFonts.workSans(
              color: onPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 15,
              letterSpacing: 1.25,
                        ),
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 40)),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(primary)),
                        ),
                      ),
                    )
                  ],
                );
        },
      ),
    );
  }
}
