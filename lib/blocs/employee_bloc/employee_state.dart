import 'package:fluttertest/model/AttendanceDataModel.dart';
import 'package:fluttertest/model/EmployeeDataModel.dart';

abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<EmployeeDataModel> listOfEmployee;
  EmployeeLoaded(this.listOfEmployee);
}

class EmployeeError extends EmployeeState {
  final String message;
  EmployeeError(this.message);
}

class EmployeeCreating extends EmployeeState {} // Indicates API call in progress

class EmployeeCreated extends EmployeeState {}
