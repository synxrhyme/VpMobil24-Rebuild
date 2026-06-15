import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz1;
import 'package:timezone/data/latest.dart' as tz;

class TimeUtils {
  static final tz1.Location berlin = tz1.getLocation('Europe/Berlin');

  TimeUtils() {
    tz.initializeTimeZones();
  }
 
  tz1.TZDateTime nowBerlin() {
    return tz1.TZDateTime.now(berlin);
  }
}

const months = {
  "Januar": 1,
  "Februar": 2,
  "März": 3,
  "April": 4,
  "Mai": 5,
  "Juni": 6,
  "Juli": 7,
  "August": 8,
  "September": 9,
  "Oktober": 10,
  "November": 11,
  "Dezember": 12,
};

DateTime parseGermanDate(String input) {
  final cleaned = input.split(", ")[1];
  final parts = cleaned.split(" ");

  final day = int.parse(parts[0].replaceAll(".", ""));
  final month = months[parts[1]]!;
  final year = int.parse(parts[2]);

  return DateTime(year, month, day);
}

List<DateTime> getWeekdays(DateTime start, DateTime end) {
  List<DateTime> days = [];

  DateTime current = DateTime(start.year, start.month, start.day);
  DateTime last = DateTime(end.year, end.month, end.day);

  while (!current.isAfter(last)) {
    if (current.weekday >= DateTime.monday &&
        current.weekday <= DateTime.friday) {
      days.add(current);
    }

    current = current.add(Duration(days: 1));
  }

  return days;
}

TimeOfDay parseTimeOfDay(String input) {
  List<String> parts = input.split(":");
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);

  return TimeOfDay(hour: hour, minute: minute);
}