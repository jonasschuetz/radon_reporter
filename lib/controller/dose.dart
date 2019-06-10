import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radon_reporter/controller/QRScanner.dart' as QRScanner;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:radon_reporter/model/stay.dart' as stay;
import 'package:radon_reporter/main.dart' as main;
import 'dart:convert';

// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

void getStay() async {
  var url = 'http://86.119.40.8:8008/stays';

  var data = new stay.Stay(id: 20, dose: 123);
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

Future<List<Stay>> fetchAndParseStays() async {

  var jsonEndpoint = 'http://86.119.40.8:8008/stays';

  var res = await http.get(jsonEndpoint);
  var jsonStr = res.body;
  var parsedStayList = jsonDecode(jsonStr);
  var stayList = <Stay>[];
  parsedStayList.forEach((parsedStay) {
    stayList.add(
        new Stay.fromJsonMap(parsedStay)
    );
  });
  return stayList;
}

class Stay {
  final int id;
  final int dose;

  Stay.fromJsonMap(Map jsonMap) :
        id = jsonMap['id'],
        dose = jsonMap['dose'];

//  String toString() {
//    return 'name: $name\nuser name: $userName\naddress: $address';
//  }
}


