import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:radon_reporter/model/Stay.dart' as Stay;
import 'package:radon_reporter/controller/doseCalculation.dart' as doseCalc;


var currentStay = new Stay.Stay();

void setStay(Stay.Stay currentStay) async {
  var url = 'http://86.119.40.8:8008/stay/create';
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
  //int dose = 456;
  doseCalc.doseCalculation();
  setStay(currentStay);
}