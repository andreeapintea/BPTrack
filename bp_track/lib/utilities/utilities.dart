import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bp_track/models/searched_doctor.dart';
import 'package:bp_track/utilities/show_snackbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(10);
}

Future<void> createMedsReminder(
    String medicine, List days, String time, int id) async {
  String daysString = days.join(',');
  print(daysString);
  var split = time.split(':');
  String cronExpression = "0 ${split[1]} ${split[0]} ? * ${daysString}";
  print(cronExpression);
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'scheduled_channel',
        title: medicine,
        body: "E timpul pentru medicamente!",
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationAndroidCrontab(
        repeats: true,
        preciseAlarm: true,
        allowWhileIdle: true,
        initialDateTime: DateTime.now(),
        crontabExpression: cronExpression,
      ));
}

Future<void> cancelAllNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}

Future<void> cancelNotification(int notificationId) async {
  await AwesomeNotifications().cancel(notificationId);
}

Future<bool> checkDoctorExists(
    String nume, String prenume, String department, String county) async {
  try {
    var doctors = await getDoctors(nume, prenume, department, county);
    bool found = false;
    doctors.forEach((element) {
      if (element != null && element.specializare != null) {
        var eNume = element.nume!
            .replaceAll('Ă', 'A')
            .replaceAll('Â', 'A')
            .replaceAll('Î', 'I')
            .replaceAll('Ș', 'S')
            .replaceAll('Ț', 'T');
        var ePrenume = element.prenume!
            .replaceAll('Ă', 'A')
            .replaceAll('Â', 'A')
            .replaceAll('Î', 'I')
            .replaceAll('Ș', 'S')
            .replaceAll('Ț', 'T');
        if (eNume == nume.toUpperCase() &&
            ePrenume == prenume.toUpperCase() &&
            element.county == county &&
            element.specializare != null) {
          bool dep = false;
          element.specializare!.forEach((e) {
            if (e != null && e.name == department) {
              dep = true;
            }
          });
          if (element.status == 'Activ' && dep) {
            found = true;
          }
        }
      }
    });
    return found;
  } on Exception catch (e) {
    return false;
  }
}

Future<List<SearchedDoctor>> getDoctors(
    String nume, String prenume, String department, String county) async {
  var url = 'https://regmed.cmr.ro/api/v2/public/medic/cautare/$nume';
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['data']['results'] as List;
    return jsonResults
        .map((doctor) => SearchedDoctor.fromJson(doctor))
        .toList();
  } else {
    throw Exception("HOPA");
  }
}
