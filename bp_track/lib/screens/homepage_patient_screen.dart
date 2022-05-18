import 'package:bp_track/constants.dart';
import 'package:bp_track/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PatientHomepage extends StatefulWidget {
  const PatientHomepage({Key? key}) : super(key: key);

  @override
  State<PatientHomepage> createState() => _PatientHomepageState();
}

class _PatientHomepageState extends State<PatientHomepage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 35, top: 48, bottom: 48),
          child: SizedBox(
            width: size.width,
            child: const Text(
              "Hello\n<name>!",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        SizedBox(
          width: size.width * 0.8,
          height: size.height * 0.3,
          child: Container(
            color: primary,
          ),
        ),
        ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => WelcomeScreen()), (Route<dynamic> route) => false);
              });
            },
            child: Text("LOGOUT")),
      ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddDialogue();
        },
        backgroundColor: primary,
      ),
    );
  }

  Future _showAddDialogue() async {
    Size size = MediaQuery.of(context).size;
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Add blood pressure reading"),
              content: SizedBox(
                height: size.height * 0.3,
                child: Form(
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Systolic",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: primary, width: 2.0),
                            )),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Dyastolic",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: primary, width: 2.0),
                            )),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Pulse",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: primary, width: 2.0),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(color: primary),
                    ))
              ],
            ));
  }
}
