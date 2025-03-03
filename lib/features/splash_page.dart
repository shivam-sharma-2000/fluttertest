import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertest/blocs/attendance_bloc/attendance_bloc.dart';
import 'package:fluttertest/blocs/attendance_bloc/attendance_event.dart';
import 'package:fluttertest/blocs/employee_bloc/employee_bloc.dart';
import 'package:fluttertest/blocs/employee_bloc/employee_event.dart';
import 'package:fluttertest/features/manage_attendance_page.dart';

class SplashPage extends StatefulWidget {
  SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>  with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _colorAnimation2;

  @override
  void initState() {
    // TODO: implement initState

    // Create an AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Set the duration of the animation
      vsync: this,
    );

    // Create a Tween animation to change color from black to green
    _colorAnimation = ColorTween(begin: Colors.blue, end: Colors.green).animate(_controller);
    _colorAnimation2 = ColorTween(begin:Colors.blue, end: Colors.green).animate(_controller);

    // Start the animation when the widget is built
    _controller.repeat(reverse: true);

    BlocProvider.of<AttendanceBloc>(context).add(FetchAttendance());
    BlocProvider.of<EmployeeBloc>(context).add(FetchEmployee());

    Future.delayed(const Duration(seconds: 5)).then((onValue){
      _controller.dispose();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ManageAttendancePage(title: "Attendance Manager")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
                animation: _colorAnimation,
              builder: (context, child) {
                return Icon(Icons.check_circle, color: _colorAnimation.value, size: 100,);
              }
            ),
            const SizedBox(height: 20,),
            AnimatedBuilder(
                animation: _colorAnimation2,
              builder: (context, child) {
                return Text("Attendance Manager",style: TextStyle(fontSize: 20, color: _colorAnimation2.value, fontWeight: FontWeight.bold),);
              }
            )
          ],
        ),
      ),
    );
  }

}
