import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:radon_reporter/model/Stay.dart' as Stay;
import 'dart:convert';

// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

void getStay() async {
  var url = 'http://86.119.40.8:8008/stays';

  var data = new Stay.Stay(id: 20, dose: 123);
  var jsonData = data.toJson(data);


  var client = new HttpClient();
  client.findProxy = null;

  Future<http.Response> foo(url, body) async {
    var response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response;
  }

  foo(url, jsonData);
}

Future<List<StayParse>> fetchAndParseStays() async {

  var jsonEndpoint = 'http://86.119.40.8:8008/stays';

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

class StayParse {
  final int id;
  final int dose;

  StayParse.fromJsonMap(Map jsonMap) :
        id = jsonMap['id'],
        dose = jsonMap['dose'];

//  String toString() {
//    return 'name: $name\nuser name: $userName\naddress: $address';
//  }
}


