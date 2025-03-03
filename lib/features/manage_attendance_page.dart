import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertest/blocs/attendance_bloc/attendance_bloc.dart';
import 'package:fluttertest/model/AttendanceDataModel.dart';
import 'package:fluttertest/utils/constants.dart';
import '../blocs/attendance_bloc/attendance_event.dart';
import '../blocs/attendance_bloc/attendance_state.dart';
import '../services/google_sheet_service.dart';
import 'manage_employee_page.dart';

class ManageAttendancePage extends StatefulWidget {
  const ManageAttendancePage({super.key, required this.title});

  final String title;

  @override
  State<ManageAttendancePage> createState() => _ManageAttendancePageState();
}

class _ManageAttendancePageState extends State<ManageAttendancePage> {
  TextEditingController nameCtr = TextEditingController();
  TextEditingController checkIn = TextEditingController();
  TextEditingController checkOut = TextEditingController();
  var selectedDate;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = dateFormat.format(DateTime.now());
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Admin",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ManageEmployeePage(
                            title: "Manage Employee")));
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Manage Employee",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Manage Attendance",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<AttendanceBloc, AttendanceState>(
          builder: (context, state) {
            if (state is AttendanceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AttendanceLoaded) {

              return Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Date:",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          selectedDate,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const Spacer(),
                        InkWell(
                            onTap: () {
                              selectDate(context,
                                  selectedDate: DateTime.parse(selectedDate),
                                  onChange: (val) {
                                    setState(() {
                                      selectedDate = dateFormat.format(val!);
                                      BlocProvider.of<AttendanceBloc>(context).add(
                                        FilterAttendance(selectedDate),
                                      );
                                    });
                                  });
                            },
                            child: Icon(
                              Icons.date_range_rounded,
                              color: Theme.of(context).hintColor,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // List Of Attendance
                    state.listOfAttendance.isNotEmpty
                        ? Expanded(
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          "ID",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          "Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          "Status",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Check In",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Check Out",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Overtime",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...state.listOfAttendance.map((e) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            e.id.toString(),
                                            style:
                                            const TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            dateFormat.format(excelDateToDateTime(int.parse(e.date.toString()))),
                                            style:
                                            const TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            e.name.toString(),
                                            style:
                                            const TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            e.status ==  "P" ? "Present" : "Absent",
                                            style: TextStyle(fontSize: 15, color:  e.status ==  "P" ? Colors.green : Colors.red),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            (e.checkIn == null || e.checkIn!.isEmpty) ? "6:00 AM"
                                                : convertExcelTimeToTimeOfDay(context, e.checkIn.toString()),
                                            style:
                                            const TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            ( e.checkOut == null || e.checkOut!.isEmpty) ? "9:00 PM"
                                                : convertExcelTimeToTimeOfDay(context, e.checkOut.toString()),
                                            style:
                                            const TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            e.overtime.toString(),
                                            style:
                                            const TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                        : const Expanded(
                      child: Center(
                        child: Text("Attendance Data Not Available"),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is AttendanceError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No data available'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  // Attendance Add Dialog
  void openDialog() {
    int index = (context.read<AttendanceBloc>().state is AttendanceLoaded)
        ? (context.read<AttendanceBloc>().state as AttendanceLoaded).originalList.length
        : 0;
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Attendance",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  TextField(
                    controller: nameCtr,
                    decoration:
                        const InputDecoration(hintText: "Enter Employee Name"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Check In Time",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  TextField(
                    controller: checkIn,
                    readOnly: true,
                    onTap: (){
                      selectTime(context, time: TimeOfDay.now(),
                          onChange: (TimeOfDay? selectedTime) {
                            checkIn.text = selectedTime!.format(context);
                          });
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.more_time_rounded),
                        hintText: "Select Check In Time"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Check Out Time",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  TextField(
                    controller: checkOut,
                    readOnly: true,
                    onTap: (){
                      selectTime(context, time: TimeOfDay.now(),
                          onChange: (TimeOfDay? selectedTime) {
                            checkOut.text = selectedTime!.format(context);
                          });
                    },
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.more_time_rounded),
                        hintText: "Select Check Out Time"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        AttendanceDataModel model = AttendanceDataModel(
                            id: index + 1,
                            name: nameCtr.text,
                            date: dateFormat.format(DateTime.now()),
                            checkIn: checkIn.text,
                            checkOut: checkOut.text,
                            overtime: "${getOvertime(checkIn.text, checkOut.text)}h",
                            status: "P"
                        );
                        BlocProvider.of<AttendanceBloc>(context).add(PostAttendance(index + 2, model));
                        Navigator.pop(context);
                      },
                      child: const Text("ADD ATTENDANCE"))
                ],
              ),
            ),
          );
        });
  }
}
