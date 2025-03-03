import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertest/services/google_sheet_service.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GoogleSheetsService apiService;

  EmployeeBloc(this.apiService) : super(EmployeeInitial()) {
    on<FetchEmployee>((event, emit) async {
      emit(EmployeeLoading());
      try {
        final employee = await apiService.getEmployeeData();
        emit(EmployeeLoaded(employee));
      } catch (e) {
        emit(EmployeeError("Failed to fetch Employee"));
      }
    });

    on<PostEmployee>((event, emit) async {
      emit(EmployeeCreating());
      try {
        final success = await apiService.addEmployeeData(event.index, event.model);
        if (success) {
          emit(EmployeeCreated());
          add(FetchEmployee()); // Reload posts after successful creation
        }
      } catch (e) {
        emit(EmployeeError("Failed to create Employee"));
      }
    });

  }
}
