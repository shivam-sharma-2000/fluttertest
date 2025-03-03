import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertest/blocs/employee_bloc/employee_bloc.dart';
import 'package:fluttertest/model/EmployeeDataModel.dart';
import 'package:fluttertest/utils/constants.dart';

import '../blocs/attendance_bloc/attendance_bloc.dart';
import '../blocs/attendance_bloc/attendance_state.dart';
import '../blocs/employee_bloc/employee_event.dart';
import '../blocs/employee_bloc/employee_state.dart';

class ManageEmployeePage extends StatefulWidget {
  const ManageEmployeePage({super.key, required this.title});

  final String title;

  @override
  State<ManageEmployeePage> createState() => _ManageEmployeePageState();
}

class _ManageEmployeePageState extends State<ManageEmployeePage> {

  TextEditingController nameCtr = TextEditingController();
  TextEditingController dojCtr = TextEditingController();
  TextEditingController dobCtr = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, state) {
                if (state is EmployeeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EmployeeLoaded) {
                  return SingleChildScrollView(
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
                                    width: 150,
                                    child: Text(
                                      "Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      "DOJ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      "DOB",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      "Active",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                  Icon(Icons.delete, color: Colors.transparent,)
                                ],
                              ),
                            ),
                            ...state.listOfEmployee.map((e) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        e.name.toString(),
                                        style:
                                        const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        (e.doj != null && e.doj.toString().isNotEmpty) ? dateFormat.format(excelDateToDateTime(int.parse(e.doj.toString()))) : "N/A",
                                        style:
                                        const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        (e.dob != null && e.dob.toString().isNotEmpty) ? dateFormat.format(excelDateToDateTime(int.parse(e.dob.toString()))) : "N/A",
                                        style:
                                        const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        e.active.toString(),
                                        style: TextStyle(fontSize: 15, color:  e.active ==  "Y" ? Colors.green : Colors.red),
                                      ),
                                    ),
                                    const Icon(Icons.delete, color: Colors.black,)

                                  ],
                                ),
                              );
                            }
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state is EmployeeError) {
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

  void openDialog() {
    int index = (context.read<EmployeeBloc>().state is EmployeeLoaded)
        ? (context.read<EmployeeBloc>().state as EmployeeLoaded).listOfEmployee.length
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
                    "Add Employee",
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
                    "DOJ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  TextField(
                    controller: dojCtr,
                    decoration:
                        const InputDecoration(hintText: "Enter Employee DOJ"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "DOB",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  TextField(
                    controller: dobCtr,
                    decoration:
                        const InputDecoration(hintText: "Enter Employee DOB"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        // await GoogleSheetsService.addEmpData(list.length + 1, [
                        //   "${list.length}",
                        //   nameCtr.text,
                        //   dojCtr.text,
                        //   dobCtr.text,
                        //   "Y"
                        // ]);
                        // getData();
                        EmployeeDataModel model = EmployeeDataModel(
                            id: index + 1,
                            name: nameCtr.text,
                            doj: dojCtr.text,
                            dob: dobCtr.text,
                            active: "${getOvertime(dojCtr.text, dobCtr.text)}h",
                        );
                        BlocProvider.of<EmployeeBloc>(context).add(PostEmployee(index + 2, model));
                        Navigator.pop(context);
                      },
                      child: const Text("ADD EMPLOYEE"))
                ],
              ),
            ),
          );
        });
  }


}

