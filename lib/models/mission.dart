import 'package:chick_chack_beta/models/category.dart';
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

const uuid = Uuid();

final formatDate = DateFormat.yMd(); // year.month.day
final formatHour = DateFormat.Hm(); // hour: minute : second

class Mission {
  Mission({
    required this.title,
    required this.date,
    required this.time,
    required this.category,
    required this.comment,
  }) : id = uuid.v4();

   String id;
  final String title;
  final DateTime date;
  final TimeOfDay time; 
  // final Loop? loops; //check
  //final NOTIFICATION sound; //check
  final CategoryList category;
  final String comment; //הערות
  
  String get formattedDate {
    return formatDate.format(date);
  }

  String get formattedHour {
    return time.minute < 10 // אם יש אפס בדקות בצד שמאל
        ? '${time.hour} : 0${time.minute}'
        : '${time.hour} : ${time.minute}';
  }
}
