import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:radon_reporter/model/Employee.dart' as Employee;

var currentEmp = new Employee.Employee();

Future getEmpDose(int id) async {
  var empList = await fetchAndParseEmps(id);
  currentEmp.dosis  = empList.dosis;
  currentEmp.firstName = empList.firstName;
  currentEmp.lastName = empList.lastName;
  return empList.dosis;
}

Future getEmpDetails(int id) async {
  var empList = await fetchAndParseEmps(id);
  currentEmp.dosis  = empList.dosis;
  currentEmp.firstName = empList.firstName;
  currentEmp.lastName = empList.lastName;
  print(empList.lastName);
}

Future<EmpParse> fetchAndParseEmps(int id) async {

  var jsonEndpoint = 'https://radonweb.herokuapp.com/api/employee/'+id.toString();

  var res = await http.get(jsonEndpoint);
  var jsonStr = res.body;
  var parsedRoomsList = jsonDecode(jsonStr);
  print(parsedRoomsList);
  var roomList = <EmpParse>[];
  var room  = new EmpParse.fromJsonMap(parsedRoomsList);
  print(roomList);
  return room;

//  var res = await http.get(jsonEndpoint);
//  var jsonStr = res.body;
//  var parsedEmpList = jsonDecode(jsonStr);
//  var empList = <EmpParse>[];
//  print(empList);
//  parsedEmpList.forEach((parsedEmp) {
//    empList.add(
//        new EmpParse.fromJsonMap(parsedEmp)
//    );
//  });
//  return empList;
}

class EmpParse {
  final int id;
  final String firstName;
  final String lastName;
  final double dosis;

  EmpParse.fromJsonMap(Map jsonMap) :
        id = jsonMap['id'],
        dosis = jsonMap['dosis'],
        lastName = jsonMap['lastName'],
        firstName = jsonMap['firstName']
  ;
}
