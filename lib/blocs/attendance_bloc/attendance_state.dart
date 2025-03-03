import 'package:fluttertest/model/AttendanceDataModel.dart';

abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<AttendanceDataModel> listOfAttendance;
  final List<AttendanceDataModel> originalList;
  AttendanceLoaded(this.originalList, {List<AttendanceDataModel>? listOfAttendance})
      : listOfAttendance = listOfAttendance ?? originalList; // Default to original list

}

class AttendanceError extends AttendanceState {
  final String message;
  AttendanceError(this.message);
}

class AttendanceCreating extends AttendanceState {} // Indicates API call in progress

class AttendanceCreated extends AttendanceState {}
