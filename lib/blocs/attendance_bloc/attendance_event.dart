import 'package:fluttertest/model/AttendanceDataModel.dart';

abstract class AttendanceEvent {}

class FetchAttendance extends AttendanceEvent {}

class PostAttendance extends AttendanceEvent {
  final int index;
  final AttendanceDataModel model;
  PostAttendance(this.index, this.model);
}

class FilterAttendance extends AttendanceEvent {
  final String selectedDate;
  FilterAttendance(this.selectedDate);
}