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

void doseCalculation(){
  var duration = QRController.currentStay.endTime.difference(QRController.currentStay.startTime);
  double dose = (duration.inHours)*currentRoom.averageValue*0.4*1.87*pow(10,-5);
  QRController.currentStay.dose = dose.toInt();
}

Future getRoomDetails (int id) async {
  var room = await fetchAndParseRooms(id);
  currentRoom.name = room.first.name;
  currentRoom.averageValue = room.first.averageValue;
  QRController.currentStay.roomID = room.first.id;
}

//void getRoom() async {
//  var url = 'http://86.119.40.8:8008/rooms/1';
//  var client = new HttpClient();
//  client.findProxy = null;
//
//  Future<http.Response> foo(url) async {
//    var response = await http.get(Uri.parse(url));
//    print('Response status: ${response.statusCode}');
//    print('Response body: ${response.body}');
//    return response;
//  }
//  foo(url);
//}

Future<List<RoomParse>> fetchAndParseRooms(int id) async {

  var jsonEndpoint = 'http://86.119.40.8:8008/room/1';

  var res = await http.get(jsonEndpoint);
  var jsonStr = res.body;
  var parsedRoomsList = jsonDecode(jsonStr);
  print(parsedRoomsList);
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
  final int averageValue;
  final DateTime createdAt;
  final DateTime updatedAt;


  RoomParse.fromJsonMap(Map jsonMap) :
        id = jsonMap['id'],
        name = jsonMap['name'],
        averageValue = int.parse(jsonMap['averageValue'].toString()),
        createdAt = DateTime.parse(jsonMap['createdAt'].toString()),
        updatedAt = DateTime.parse(jsonMap['updatedAt'].toString())

  ;
}



