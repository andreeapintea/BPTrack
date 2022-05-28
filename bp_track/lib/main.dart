import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bp_track/screens/account_type_screen.dart';
import 'package:bp_track/screens/doctor/bottom_nav_doctor_screen.dart';
import 'package:bp_track/screens/patient/bottom_nav_patient_screen.dart';
import 'package:bp_track/screens/patient/homepage_patient_screen.dart';
import 'package:bp_track/screens/patient/medication_list_screen.dart';
import 'package:bp_track/screens/patient/patient_details_screen.dart';
import 'package:bp_track/services/doctors_service.dart';
import 'package:bp_track/services/medication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bp_track/screens/welcome_screen.dart';
import 'package:bp_track/utilities/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bp_track/services/patients_service.dart';
import 'package:bp_track/utilities/utilities.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications',
    description:
        'This channel is used for important notifications.', // title // description
    importance: Importance.high,
  );
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/notification_icon');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) {
    if (payload != null) {
      OpenFile.open(payload);
    }
  });

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {

    if (message.notification != null) {
      flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification!.title,
        message.notification!.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
          ),
        ),
      );
    }
  });
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'scheduled_channel',
      channelName: 'Scheduled Notifications',
      channelDescription: 'Medicine reminders',
      defaultColor: primary,
      importance: NotificationImportance.High,
      locked: true,
    )
  ]);
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  final _patientsService = PatientsService();
  final _doctorsService = DoctorsService();
  final _medicineService = MedicationService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BPTrack',
        theme: ThemeData(
          primaryColor: primary,
          scaffoldBackgroundColor: background,
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: primary,
                ));
              } else if (snapshot.hasData) {
                return FutureBuilder(
                    future: checkIsPatient(),
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return FutureBuilder(
                          future: _patientsService.getPatient(
                              FirebaseAuth.instance.currentUser!.uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child:
                                    CircularProgressIndicator(color: primary),
                              );
                            } else if (snapshot.hasData) {
                              cancelAllNotifications();
                              _medicineService.createNotifications(
                                  FirebaseAuth.instance.currentUser!.uid);
                              return PatientNavigation(
                                currentIndex: 0,
                                patientUid:
                                    FirebaseAuth.instance.currentUser!.uid,
                              );
                            } else {
                              return PatientDetailsScreen();
                            }
                          },
                        );
                      } else {
                        return FutureBuilder(
                          future: _doctorsService.getDoctor(
                              FirebaseAuth.instance.currentUser!.uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child:
                                    CircularProgressIndicator(color: primary),
                              );
                            } else {
                              return DoctorNavigation(
                                  doctorUid:
                                      FirebaseAuth.instance.currentUser!.uid);
                            }
                          },
                        );
                      }
                    });
              } else if (snapshot.hasError) {
                return Center(child: Text('Something went wrong!'));
              } else {
                return WelcomeScreen();
              }
            }));
  }

  Future<bool> checkIsPatient() async {
    bool patient = await _patientsService
        .checkPatientExists(FirebaseAuth.instance.currentUser!.uid);
    return patient;
  }
}
