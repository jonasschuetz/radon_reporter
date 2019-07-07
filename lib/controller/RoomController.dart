import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:radon_reporter/model/Room.dart' as Room;
import 'package:radon_reporter/controller/QRController.dart' as QRController;

var currentRoom = new Room.Room();

Future getRoomDetails (int id) async {
  var room = await fetchAndParseRoom(id);
  currentRoom.name = room.name;
  currentRoom.averageValue = room.averageValue;
  QRController.currentStay.roomId = room.id;
  print(QRController.currentStay.roomId.toString());
}

Future<RoomParse> fetchAndParseRoom(int id) async {

  var jsonEndpoint = 'https://radonweb.herokuapp.com/api/room/'+id.toString();

  var res = await http.get(jsonEndpoint);
  var jsonStr = res.body;
  var parsedRoomsList = jsonDecode(jsonStr);
  print(parsedRoomsList);
  var roomList = <RoomParse>[];
  var room  = new RoomParse.fromJsonMap(parsedRoomsList);
  print(roomList);
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

