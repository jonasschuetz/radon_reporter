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
import 'package:radon_reporter/model/Room.dart' as Room;
import 'package:radon_reporter/controller/QRController.dart' as QRController;


var currentRoom = new Room.Room();

int doseCalculation(){
  var duration = QRController.currentStay.endTime.difference(QRController.currentStay.startTime);
  QRController.currentStay.dose = (duration.inHours)*currentRoom.averageBq*0.4*1.87*pow(10,-5);
}

Future getRoomDetails (int id) async {
  var room = await fetchAndParseRooms(id);
  currentRoom.name = room.first.name;
  currentRoom.averageBq = room.first.averageBq;
}

void getRoom() async {
  var url = 'http://86.119.40.8:8008/rooms/1';
  var client = new HttpClient();
  client.findProxy = null;

  Future<http.Response> foo(url) async {
    var response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response;
  }
  foo(url);
}

Future<List<RoomParse>> fetchAndParseRooms(int id) async {

  var jsonEndpoint = 'http://86.119.40.8:8008/rooms/'+id.toString();

  var res = await http.get(jsonEndpoint);
  var jsonStr = res.body;
  var parsedRoomsList = jsonDecode(jsonStr);
  var roomList = <RoomParse>[];
  parsedRoomsList.forEach((parsedRooms) {
    roomList.add(
        new RoomParse.fromJsonMap(parsedRooms)
    );
  });
  return roomList;
}

class RoomParse {
  final int id;
  final String name;
  final int averageBq;

  RoomParse.fromJsonMap(Map jsonMap) :
        id = jsonMap['id'],
        name = jsonMap['name'],
        averageBq = int.parse(jsonMap['averageBq'].toString());

//  String toString() {
//    return 'name: $name\nuser name: $userName\naddress: $address';
//  }
}



