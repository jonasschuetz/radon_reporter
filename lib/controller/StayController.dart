import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:radon_reporter/model/Stay.dart' as Stay;
import 'dart:convert';
import 'package:radon_reporter/main.dart' as Main;
import 'package:radon_reporter/controller/DoseCalculation.dart' as doseCalc;

var currentStay = new Stay.Stay();

// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

Future<List<StayParse>> fetchAndParseStays() async {

  var jsonEndpoint = 'https://radonweb.herokuapp.com/api/stay/employee/'+Main.currentEmpId.toString();

  var res = await http.get(jsonEndpoint);
  var jsonStr = res.body;
  var parsedStayList = jsonDecode(jsonStr);
  var stayList = <StayParse>[];
  parsedStayList.forEach((parsedStay) {
    stayList.add(
        new StayParse.fromJsonMap(parsedStay)
    );
  });
  return stayList;
}

void setStay(Stay.Stay currentStay) async {
  var url = 'https://radonweb.herokuapp.com/api/stay/create';
  var jsonData = currentStay.toJson(currentStay);

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

void stopStay() async{
  currentStay.endTime = DateTime.now();
  currentStay.employeeId = Main.currentEmpId;
  doseCalc.doseCalculation();
  setStay(currentStay);
}

class StayParse {
  final int id;
  final double dose;
  final DateTime startTime;
  final DateTime endTime;
  final int roomId;
  final int employeeId;

  StayParse.fromJsonMap(Map jsonMap) :
        id = jsonMap['id'],
        dose = jsonMap['dose'],
        startTime = DateTime.parse(jsonMap['startTime'].toString()),
        endTime = DateTime.parse(jsonMap['endTime'].toString()),
        roomId = jsonMap['roomId'],
        employeeId = jsonMap['employeeId']
  ;
}
