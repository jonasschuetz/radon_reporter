import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radon_reporter/controller/QRScanner.dart' as QRScanner;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:radon_reporter/model/stay.dart' as stay;
import 'package:radon_reporter/main.dart' as main;
import 'dart:convert';


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

class DoseScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => DoseScreenState();
}


class DoseScreenState extends State<DoseScreen>{

  var stayWidgets = <Widget>[];

  @override
  void initState() {
    super.initState();
    _getStays();
  }

  _getStays() async {

    List<Widget> widgets = [];
    var stayList = await fetchAndParseStays();
    stayList.forEach((stay) =>
        widgets.add(
            new ListTile(
              title: new Text("Id "+stay.id.toString()),
              subtitle: new Text("Dose " +stay.dose.toString()),
            )
        )
    );

    setState(() => this.stayWidgets = widgets);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('List Example'),
        ),
        body: new ListView(children: stayWidgets)
    );
  }

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


