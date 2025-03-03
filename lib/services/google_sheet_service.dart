import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:fluttertest/model/AttendanceDataModel.dart';
import 'package:fluttertest/model/EmployeeDataModel.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';

class GoogleSheetsService {
  static const _spreadSheetId = "1WMBWDLFw27ebpLSru6j-cGvT2yuxwpBhAAw6bh7FD9U";
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "swift-icon-311217",
  "private_key_id": "befb0c4fbdf43cb53b3c04ea3c1cad1c2f323fbc",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDBrj1PssPPX+Z2\n5fHPO+v1F/g22AUfByeyXNrBtEWj/846OQWKu0/sRFdaHNp7b4rG0B3NNOJ7COnV\ngvlFx09HN4zk07Usl1LB2FsrpmFjwgso//XA6ZV3hg8RXH77/uma8mayIAcqTDp2\niI9nKDB0FxaCYh8xc/PmNm6pxGrEgB6IxUU7Uk1r73BRkvZ0USgV4oGWObBWcaiR\nnInZ/xyVVHl2oAy2vTCxMAlX4ltHY9DsC/vuniKbYIC/il7HOzByuf6qf10i2zNZ\nnmktQ8xQFvDdyPMc08Wv5hNkn0VSUAOSZCgbvlON25hxqdgwZvOdYeaAADIiPHI7\nLO7T0GdPAgMBAAECggEABWFOMbMRDmcnE0Fy9KNA/Dd0vS1GAyUjPKioqP3Ve2dF\nNsfTuBVY9IK3fHjVtt0T2U75rPQdoHZQbI5tVztgn+VSpB6fZ0Qy19CnQ7Ck/uzq\ne3KUxI2Yic/vBjfwDRb5LUUzhhouqMWiUB2eAisTIX5ssSWBoVGLwmbbrxqWLqwl\n+iyC/mMh/F1RSmVKqGzkOO6rzuaiGs2idEUdte8vRotiD7t3P5yuZC5q3xpVWFj8\nXC1sFloshWgg4UG61CZqg4k0e/1CNAJrwgFpAR8dIR5IZBoA339+DmMgOdw4fLql\nHiqGKd5DXtplMQabj7rQ4Za9/riqvy/fSry+dvJNFQKBgQD5CO77CK+OHWPCGCPJ\n+MZMbgtLFZS7FeW2n6AGT4p/0beyjEW4u3rKlRSn0mPh6UGuEo1y4d2oUbuufioB\nN20rhJkhjgWcg28a3Jh4f+chG45Wh3xJ6P4GKPdUVMhpprSLz1TPPD8iZypWkPZO\nAp4AY5v9mOEGtBqO4r00R6rwlQKBgQDHGPl9497PaISOsgFFaYk4WXWomyjcBQfL\ntbh0xMHsmr1i2Pt7aiYQNboQYWVhb84WB7gDEesIg6D79y7+3t6W5rcLNR7QZ6YQ\nabwK5gP43ZJx7MdJKIiuLWbkDAzOvYSRc6jbzln22PZLu3cPgpizm7K0CNkTH5Q3\nNda0eVYLUwKBgC2E54G1HbmhP5m7pdcGBOD1gFTyFeR4ZSuTU8GzikJAyA33u8q/\nYftjcooWV7F0XFAADiDAji50+hQz9WORiP/aVc8fUYFBOO61AZ2M62dOzR6d1yb/\nUmc317VvZc6B7SBc/kh+359fMgrupkauDclOa7XX2tHJ28zgPusual1dAoGBAJa9\nVvA0nZZlKK+tH/9Axy7NtKJiT0491MgsHqrx6W1NPwRfChBHrufo9aW/R/W8o8jU\nMULJxyxcFH+Qh5lafia8KWwn3NunDfkxRLjvq6Q5hc4RmlTOhqVxJIyWfv/sRzmk\n2v0Iv96AKAHwvlUU6K5bvLJIXKn458vhTFy53SaXAoGAcXJnozsLXl+bE++CoLY3\nSt32TxprzPcvVA5s0DFJTN59vA/uuIRYf+i4Vkcb5R1YaDTMtyxXUu6UyUFkg5Wg\nESHuqO/bOKF3vNfDO1vvZDPgNZNatchFTDflfqBRg6cmI0HW4/prd8niWPFsdsFe\naeU6iXgao31mARL2Z5fbpOQ=\n-----END PRIVATE KEY-----\n",
  "client_email": "attendance-sheet@swift-icon-311217.iam.gserviceaccount.com",
  "client_id": "100341590343855525967",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/attendance-sheet%40swift-icon-311217.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

  ''';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _userSheet, _empSheet;
  Future init() async {
    final spreadSheet = await _gsheets.spreadsheet(_spreadSheetId);
    _userSheet = await _getWorkSheet(spreadSheet, title: "Attendance");
    _empSheet = await _getWorkSheet(spreadSheet, title: "Employee");
    try{
      _userSheet!.values.insertRow(1, ["Id", "Name", "Check In", "Check Out", "Over Time","Date", "Status"]);
      _empSheet!.values.insertRow(1, ["Id", "Name", "DOJ", "DOB", "Active"]);
    }catch(e){
      log("Issue with init $e");
    }
  }

  Future<Worksheet?> _getWorkSheet(Spreadsheet spreadSheet, {required String title}) async {
    try{
      return await spreadSheet.addWorksheet(title);
    }
    catch(e){
      return spreadSheet.worksheetByTitle(title);
    }
  }

  Future<List<AttendanceDataModel>> getAttendanceData() async{
    List<AttendanceDataModel> listOfAttendance = [];
    var list = await _userSheet!.values.allRows();
    list.skip(1).map((row){
      debugPrint(row.elementAt(1).toString());
      listOfAttendance.add(
        AttendanceDataModel(
          id: int.parse(row.elementAt(0)),
          name: row.elementAt(1),
          checkIn: row.elementAt(2),
          checkOut: row.elementAt(3),
          overtime: row.elementAt(4),
          date: row.elementAt(5),
          status: row.elementAt(6)
        )
      );
    }).toList();
    return listOfAttendance;
  }

  Future<List<EmployeeDataModel>> getEmployeeData() async{
    List<EmployeeDataModel> listOfEmployee = [];
    List<List<String>> list = await _empSheet!.values.allRows();
    list.skip(1).map((row){
      debugPrint(row.elementAt(1).toString());
      listOfEmployee.add(
          EmployeeDataModel(
              id: int.parse(row.elementAt(0)),
              name: row.elementAt(1),
              doj: row.elementAt(2),
              dob: row.elementAt(3),
              active: row.elementAt(4),
          )
      );
    }).toList();
    return listOfEmployee;
  }

  Future<bool> addEmployeeData(int index, EmployeeDataModel model) async{
    await _empSheet!.values.insertRow(index, [
      model.id,
      model.name,
      model.doj,
      model.dob,
      model.active
    ]);
    return true;
  }

  Future<bool> addAttendanceData(int index, AttendanceDataModel model) async{
    await _userSheet!.values.insertRow(index,  [
      model.id, //ID
      model.name,//Name
      model.checkIn,// Check In Time
      model.checkOut,// Check Out Time
      model.overtime,// Over Time
      model.date,
      model.status
    ]);
    return true;
  }


}
