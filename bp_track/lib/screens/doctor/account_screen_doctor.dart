import 'package:bp_track/utilities/constants.dart';
import 'package:bp_track/screens/welcome_screen.dart';
import 'package:bp_track/services/doctors_service.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:bp_track/widgets/common/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final _doctorService = DoctorsService();

class AccountScreenDoctor extends StatefulWidget {
  const AccountScreenDoctor({Key? key}) : super(key: key);

  @override
  State<AccountScreenDoctor> createState() => _AccountScreenDoctorState();
}

class _AccountScreenDoctorState extends State<AccountScreenDoctor> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primary,
        title: Text("Profil",
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          letterSpacing: 0.15,
        ),),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseAuth.instance.currentUser != null ? FirebaseFirestore.instance
            .collection('doctors')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots() : null,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: primary),
            );
          }
          return FirebaseAuth.instance.currentUser == null ? Center() : Column(
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
                          border: Border.all(width: 5, color: Colors.white),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: FadeInImage(
                          placeholder:
                              const AssetImage('assets/images/placeholder.png'),
                          image: FirebaseAuth.instance.currentUser!.photoURL !=
                                  null
                              ? NetworkImage(
                                  FirebaseAuth.instance.currentUser!.photoURL!)
                              : AssetImage('assets/images/placeholder.png')
                                  as ImageProvider,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.16,
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.all(size.height * 0.009)),
                      Text(
                        "${snapshot.data!['nume'].toUpperCase()} ${snapshot.data!['prenume'].toUpperCase()}",
                        style: GoogleFonts.montserrat(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(size.height * 0.008)),
                      Text(
                        "${snapshot.data!['department']}",
                        style: GoogleFonts.workSans(),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: TextButton(
          onPressed: () async {
            await _doctorService.updateDoctorToken(
        token: "",
        context: context,
        doctorUid: FirebaseAuth.instance.currentUser!.uid);
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
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
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
              backgroundColor: MaterialStateProperty.all<Color>(primary)),
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
