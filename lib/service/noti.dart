// import 'package:flutter/material.dart';
//import 'package:chick_chack_beta/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzData;

class Noti {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        new AndroidInitializationSettings('@mipmap/ic_launcher'); // check this
    // var iOSInitialize = new IOSInitializationSettings();
    var initializationsSettings =
        new InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    // payload = scheduleNotification();
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      "2",
      "ronaldo",
      playSound: true,
      //sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );
    var not = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    // tzData.initializeTimeZones();
    await fln.show(0, title, body, not);
    // await fln.zonedSchedule(
    //     0,
    //     title,
    //     body,
    //     // tz.TZDateTime.now(tz.UTC).add(const Duration(seconds: 5))
    //     // tz.TZDateTime.parse(tz.local, "2023-12-14 14:07:00"),
    //     not,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     androidAllowWhileIdle: true); // --------succes!!!!
  }

  static Future showScheduleNotification( // התראה לפי תאריך מדויק
      {var id = 0,
      required String title,
      required String body,
      required tz.TZDateTime time,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      "2",
      "ronaldo",
      playSound: true,
      //sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );
    var not = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    //await fln.show(0, title, body, not);
    // tzData.initializeTimeZones();
    await fln.zonedSchedule(
        0,
        title,
        body,
        // tz.TZDateTime.now(tz.UTC).add(const Duration(seconds: 5)) 
        time, //this the time of noti!!!!!!!!!
        not,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true); // --------succes!!!!
  }
  //--------------------------------------------------------------------
  // static Future<void> scheduleNotification() async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     "5",
  //     'Scheduled notifications',
  //   );
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   await gotFNLP.zonedSchedule(
  //     0,
  //     'Scheduled Title',
  //     'Scheduled Body',
  //     tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
  //     platformChannelSpecifics,
  //     androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //   );
  // }
}
