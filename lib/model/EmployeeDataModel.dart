/// Id : 1
/// Name : "Shivam"
/// DOJ : ""
/// DOB : ""
/// Active : ""

class EmployeeDataModel {
  EmployeeDataModel({
      num? id, 
      String? name, 
      String? doj, 
      String? dob, 
      String? active,}){
    _id = id;
    _name = name;
    _doj = doj;
    _dob = dob;
    _active = active;
}

  EmployeeDataModel.fromJson(dynamic json) {
    _id = json['Id'];
    _name = json['Name'];
    _doj = json['DOJ'];
    _dob = json['DOB'];
    _active = json['Active'];
  }
  num? _id;
  String? _name;
  String? _doj;
  String? _dob;
  String? _active;
EmployeeDataModel copyWith({  num? id,
  String? name,
  String? doj,
  String? dob,
  String? active,
}) => EmployeeDataModel(  id: id ?? _id,
  name: name ?? _name,
  doj: doj ?? _doj,
  dob: dob ?? _dob,
  active: active ?? _active,
);
  num? get id => _id;
  String? get name => _name;
  String? get doj => _doj;
  String? get dob => _dob;
  String? get active => _active;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['Name'] = _name;
    map['DOJ'] = _doj;
    map['DOB'] = _dob;
    map['Active'] = _active;
    return map;
  }

}