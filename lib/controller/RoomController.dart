import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:radon_reporter/model/Room.dart' as Room;
import 'package:radon_reporter/controller/StayController.dart' as StayController;


// Some lines of code are from:
// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

var currentRoom = new Room.Room();

Future getRoomDetails (int id) async {
  var room = await fetchAndParseRoom(id);
  currentRoom.name = room.name;
  currentRoom.averageValue = room.averageValue;
  StayController.currentStay.roomId = room.id;
  print(StayController.currentStay.roomId.toString());
}

Future<RoomParse> fetchAndParseRoom(int id) async {

  var jsonEndpoint = 'https://radonweb.herokuapp.com/api/room/'+id.toString();

  var res = await http.get(jsonEndpoint);
  var jsonStr = res.body;
  var parsedRoomsList = jsonDecode(jsonStr);
  var roomList = <RoomParse>[];
  var room  = new RoomParse.fromJsonMap(parsedRoomsList);
  return room;
}

Future<List<RoomParse>> fetchAndParseRooms() async {

  var jsonEndpoint = 'https://radonweb.herokuapp.com/api/room';

  var res = await http.get(jsonEndpoint);
  var jsonStr = res.body;
  var parsedRoomList = jsonDecode(jsonStr);
  var roomList = <RoomParse>[];
  parsedRoomList.forEach((parsedRoom) {
    roomList.add(
        new RoomParse.fromJsonMap(parsedRoom)
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

