/// Id : 1
/// Name : "Shivam"
/// Check In : ""
/// Check Out : ""
/// Overtime : ""
/// Date : ""
/// Status : ""

class AttendanceDataModel {
  AttendanceDataModel({
      num? id, 
      String? name, 
      String? checkIn, 
      String? checkOut, 
      String? overtime, 
      String? date, 
      String? status,}){
    _id = id;
    _name = name;
    _checkIn = checkIn;
    _checkOut = checkOut;
    _overtime = overtime;
    _date = date;
    _status = status;
}

  AttendanceDataModel.fromJson(dynamic json) {
    _id = json['Id'];
    _name = json['Name'];
    _checkIn = json['Check In'];
    _checkOut = json['Check Out'];
    _overtime = json['Overtime'];
    _date = json['Date'];
    _status = json['Status'];
  }
  num? _id;
  String? _name;
  String? _checkIn;
  String? _checkOut;
  String? _overtime;
  String? _date;
  String? _status;
AttendanceDataModel copyWith({  num? id,
  String? name,
  String? checkIn,
  String? checkOut,
  String? overtime,
  String? date,
  String? status,
}) => AttendanceDataModel(  id: id ?? _id,
  name: name ?? _name,
  checkIn: checkIn ?? _checkIn,
  checkOut: checkOut ?? _checkOut,
  overtime: overtime ?? _overtime,
  date: date ?? _date,
  status: status ?? _status,
);
  num? get id => _id;
  String? get name => _name;
  String? get checkIn => _checkIn;
  String? get checkOut => _checkOut;
  String? get overtime => _overtime;
  String? get date => _date;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['Name'] = _name;
    map['Check In'] = _checkIn;
    map['Check Out'] = _checkOut;
    map['Overtime'] = _overtime;
    map['Date'] = _date;
    map['Status'] = _status;
    return map;
  }

}