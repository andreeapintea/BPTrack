import 'package:bp_track/utilities/constants.dart';
import 'package:bp_track/screens/doctor/doctor_signup_screen.dart';
import 'package:bp_track/screens/patient/patient_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountTypeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 50,
            child: Column(
             children: [
               Padding(
                 padding: const EdgeInsets.symmetric(vertical: 10),
                 child: Text("ALEGE TIPUL CONTULUI",
                 style: GoogleFonts.montserrat(
                                color: primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                letterSpacing: 0,
                              ),),
               ),
               Padding(
                 padding: EdgeInsets.symmetric(vertical: 20),
                 child: SizedBox(
                   height: size.height * 0.3,
                   width: size.height * 0.3,
                   child: OutlinedButton(
                     onPressed:  () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DoctorSignUpScreen();
                    }));
                  },
                     style: ButtonStyle(
                       overlayColor: MaterialStateProperty.all<Color>(primaryContainer),
                       side: MaterialStateProperty.all<BorderSide>(BorderSide(color: primaryContainer, width: 2.0)),
                     ),
                     child: Stack(
                       children: [
                         SvgPicture.asset('assets/icons/doctor.svg'),
                       ],
                     ),
                     ),
                 ),
               ),
               Text("Medic",
               style: GoogleFonts.workSans(
                 color: secondaryColor,
                 fontWeight: FontWeight.normal,
                 fontSize: 17,
                 letterSpacing: 0.5,
               )),
               Padding(
                 padding: EdgeInsets.symmetric(vertical: 20),
                 child: SizedBox(
                   height: size.height * 0.3,
                   width: size.height * 0.3,
                   child: OutlinedButton(
                     onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PatientSignUpScreen();
                    }));
                  },
                     style: ButtonStyle(
                       overlayColor: MaterialStateProperty.all<Color>(primaryContainer),
                       side: MaterialStateProperty.all<BorderSide>(BorderSide(color: primaryContainer, width: 2.0)),
                     ),
                     child: Stack(
                       children: [
                         SvgPicture.asset('assets/icons/patient.svg'),
                       ],
                     ),
                     ),
                 ),
               ),
               Text("Pacient",
               style:GoogleFonts.workSans(
                 color: secondaryColor,
                 fontWeight: FontWeight.normal,
                 fontSize: 17,
                 letterSpacing: 0.5,
               )
               ),
             ],
          ),
          ),
        ],),
    );
  }
}
