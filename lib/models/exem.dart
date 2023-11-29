
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

final formatDate = DateFormat.yMd(); // year.month.day
final formatHour = DateFormat.Hm(); // hour: minute : second

class Exem {
  Exem({
    required this.title,
    required this.date,
    required this.comment,
  }) : id = uuid.v4();

   String id;
  final String title;
  final DateTime date;
  final String comment; //הערות

  String get formattedDate {
    return formatDate.format(date);
  }
}
