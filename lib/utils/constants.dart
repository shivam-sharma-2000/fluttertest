import 'package:flutter/material.dart';
import 'package:fluttertest/model/AttendanceDataModel.dart';
import 'package:intl/intl.dart';

import '../model/EmployeeDataModel.dart';


DateFormat dateFormat  = DateFormat("yyyy-MM-dd");

DateTime excelDateToDateTime(int excelDate) {
  // Excel uses a base date of 1900-01-01, but Excel considers 1900 as a leap year.
  // Thus, we need to adjust for this error by subtracting 1 day for Excel date before 1900.
  int excelEpochAdjustment = 25569; // 25569 is the number of days between 1900-01-01 and 1970-01-01
  // Convert Excel date to DateTime
  DateTime date = DateTime.fromMillisecondsSinceEpoch(
    (excelDate - excelEpochAdjustment) * 86400000.toInt(), // Multiply by number of milliseconds per day
    isUtc: true,
  );
  return date;
}


String convertExcelTimeToTimeOfDay(context, String excelTime) {
  // Convert Excel time to total minutes in the day
  int totalMinutes = (double.parse(excelTime.toString()) * 24 * 60).round();

  // Calculate hours and minutes
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;

  return TimeOfDay(hour: hours, minute: minutes).format(context);
}

Future<void> selectDate(
    BuildContext context, {
      DateTime? selectedDate,
      required void Function(DateTime? selectedDate) onChange,
    }) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime.now(),
    initialDatePickerMode: DatePickerMode.day,
    firstDate: DateTime(1950),
    lastDate: DateTime.now(),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Theme.of(context).primaryColor),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontSize: 8,
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    onChange(picked);
    FocusScope.of(context).unfocus();
  }
}

// Function to display time picker
Future<void> selectTime(BuildContext context, {TimeOfDay? time,  required void Function(TimeOfDay? selectedTime) onChange, }) async {
  // Show time picker and get the selected time
  TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: time ?? TimeOfDay.now(),
  );

  // If a time was picked, update the state
  if (picked != null) {
    onChange(picked);
    FocusScope.of(context).unfocus();
  }
}

int getOvertime(String startTimeStr, String endTimeStr) {
  // Parsing the start and end times from strings
  TimeOfDay startTime = _parseTime(startTimeStr);
  TimeOfDay endTime = _parseTime(endTimeStr);

  // Convert TimeOfDay to DateTime objects (using a common date for both times)
  DateTime startDateTime = DateTime(2022, 1, 1, startTime.hour, startTime.minute);
  DateTime endDateTime = DateTime(2022, 1, 1, endTime.hour, endTime.minute);

  // If end time is before start time, assume the end time is on the next day
  if (endDateTime.isBefore(startDateTime)) {
    endDateTime = endDateTime.add(Duration(days: 1));
  }

  // Calculate the difference in hours
  Duration workDuration = endDateTime.difference(startDateTime);
  int totalHours = workDuration.inHours;

  // If the total working hours exceed 9, calculate overtime
  if (totalHours > 9) {
    return totalHours - 9; // Overtime is the total hours minus 9
  } else {
    return 0; // No overtime if working hours are 9 or less
  }
}

TimeOfDay _parseTime(String timeStr) {
  List<String> parts = timeStr.split(':');
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1].substring(0, 2));

  // If time is in "AM/PM" format (like "6:00 AM" or "9:00 PM"), we need to handle that
  bool isPM = timeStr.contains("PM");
  if (isPM && hour != 12) {
    hour += 12; // Convert PM hours to 24-hour format
  } else if (!isPM && hour == 12) {
    hour = 0; // Convert 12 AM to 00:00 hours
  }

  return TimeOfDay(hour: hour, minute: minute);
}