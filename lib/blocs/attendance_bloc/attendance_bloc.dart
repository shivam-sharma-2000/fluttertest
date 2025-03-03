import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertest/services/google_sheet_service.dart';
import '../../utils/constants.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GoogleSheetsService apiService;

  AttendanceBloc(this.apiService) : super(AttendanceInitial()) {
    on<FetchAttendance>((event, emit) async {
      emit(AttendanceLoading());
      try {
        final attendance = await apiService.getAttendanceData();
        emit(AttendanceLoaded(attendance));
      } catch (e) {
        emit(AttendanceError("Failed to fetch attendances"));
      }
    });

    on<PostAttendance>((event, emit) async {
      emit(AttendanceCreating());
      try {
        final success = await apiService.addAttendanceData(event.index, event.model);
        if (success) {
          emit(AttendanceCreated());
          add(FetchAttendance()); // Reload posts after successful creation
        }
      } catch (e) {
        emit(AttendanceError("Failed to create Attendance"));
      }
    });

    on<FilterAttendance>((event, emit) async {
      if (state is AttendanceLoaded) {
        final currentState = state as AttendanceLoaded;

        // Filter the list without modifying originalList
        final listOfAttendance = currentState.originalList.where((attendance) {
          return dateFormat.format(excelDateToDateTime(int.parse(attendance.date.toString()))) == event.selectedDate; // Filter by date
        }).toList();

        emit(AttendanceLoaded(currentState.originalList, listOfAttendance: listOfAttendance));
      }
    });
  }
}
