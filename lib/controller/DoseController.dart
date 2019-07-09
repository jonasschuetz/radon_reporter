import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:radon_reporter/model/Employee.dart' as Employee;
import 'package:radon_reporter/controller/QRController.dart' as QRController;
import 'package:radon_reporter/controller/StayController.dart' as StayController;

var currentEmp = new Employee.Employee();

//Future<StayController.StayParse> getLastStay (int id) async {
//  var stay = await StayController.fetchAndParseStay(id);
//  return stay.first;
//}

Future getEmpDetails() async {
  var empList = await fetchAndParseEmps();
  empList.sort((a,b) => a.id.compareTo(b.id));
  currentEmp.dosis  = empList.last.dosis;
  currentEmp.firstName = empList.last.firstName;
  currentEmp.lastName = empList.last.lastName;
  print(empList.last.lastName);
}

void setDose(Employee.Employee emp) async {
  var url = 'https://radonweb.herokuapp.com/api/employee/create';
  var jsonData = emp.toJson(emp);

  var client = new HttpClient();
  client.findProxy = null;

  Future<http.Response> foo(url, body) async{
    var response = await http.post(Uri.parse(url), body: body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response;
  }

  foo(url, jsonData);
}


Future<List<EmpParse>> fetchAndParseEmps() async {

  var jsonEndpoint = 'https://radonweb.herokuapp.com/api/employee';

  var res = await http.get(jsonEndpoint);
  var jsonStr = res.body;
  var parsedEmpList = jsonDecode(jsonStr);
  var empList = <EmpParse>[];
  print(empList);
  parsedEmpList.forEach((parsedEmp) {
    empList.add(
        new EmpParse.fromJsonMap(parsedEmp)
    );
  });
  return empList;
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
