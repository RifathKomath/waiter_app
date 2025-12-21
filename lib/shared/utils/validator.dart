import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String? validateRequired(String labelText, String? value) {
  if (value == null || value.trim().isEmpty) {
    return "$labelText is required";
  }
  return null;
}
TimeOfDay parseTime(String timeString) {
  final parts = timeString.split(':'); // ["09", "00", "00"]
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}
String timeOfDayToString(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute:00';
}
String formatDateTime(DateTime time) {
  return DateFormat("hh:mm:ss a").format(time);
}
String formatDateNTimeForAppointmentView(String dateTimeS){
  DateTime dateTime = DateTime.parse(dateTimeS);
  String formattedDate = DateFormat("d MMMM yyyy, hh:mm a").format(dateTime);
  return formattedDate;
}


String formatTimeToAmPm(String time24) {
  try {
    // Parse the 24-hour time string
    final parts = time24.split(':'); // ["17","09","19"]
    if (parts.length < 2) return time24;

    int hour = int.parse(parts[0]);
    final minute = parts[1];

    final amPm = hour >= 12 ? "PM" : "AM";
    hour = hour % 12;
    if (hour == 0) hour = 12;

    return "$hour:$minute $amPm";
  } catch (e) {
    return time24; // fallback if parsing fails
  }
}

extension StringExtension on String {
  String get upperFirst =>
      length > 1 ? "${this[0].toUpperCase()}${substring(1)}" : toUpperCase();
 
  String get getFirstLetter =>
      length > 1 ? this[0].toUpperCase() : toUpperCase();
}
 

