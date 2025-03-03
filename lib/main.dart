import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertest/blocs/employee_bloc/employee_bloc.dart';
import 'package:fluttertest/features/splash_page.dart';
import 'blocs/attendance_bloc/attendance_bloc.dart';
import 'services/google_sheet_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleSheetsService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AttendanceBloc(GoogleSheetsService())),
        BlocProvider(create: (context) => EmployeeBloc(GoogleSheetsService())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: false,
        ),
        home: SplashPage(),
        // home: const ManageAttendancePage(title: 'Attendance Manager'),
      ),
    );
  }
}


