import 'package:fluttertest/model/EmployeeDataModel.dart';

abstract class EmployeeEvent {}

class FetchEmployee extends EmployeeEvent {}

class PostEmployee extends EmployeeEvent {
  final int index;
  final EmployeeDataModel model;
  PostEmployee(this.index, this.model);
}