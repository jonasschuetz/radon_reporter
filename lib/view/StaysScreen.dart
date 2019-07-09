import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radon_reporter/controller/StayController.dart' as StayController;
import 'package:radon_reporter/controller/QRController.dart' as QRController;
import 'package:radon_reporter/model/Room.dart' as Room;
import 'package:radon_reporter/controller/RoomController.dart' as RoomController;
import 'package:radon_reporter/view/Colors.dart' as Colors;


//Some lines of code are from:
// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class StayScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StayScreenState();
}

class StayScreenState extends State<StayScreen>{

  TabController _tabController;

  var _stayWidgets = <Widget>[];

  @override
  void initState() {
    super.initState();
    _getStays();
  }

  _getStays() async {
    List<Widget> widgets = [];
    var stayList = await StayController.fetchAndParseStays();
    var roomList = await RoomController.fetchAndParseRooms();
    stayList.sort((a,b) => b.startTime.compareTo(a.startTime));
    roomList.sort((a,b) => a.id.compareTo(b.id));
    stayList.forEach((stay) =>
        widgets.add(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 5.0),
                new Text(stay.startTime.day.toString()+"."+stay.startTime.month.toString()+"."+stay.startTime.year.toString()),
                const SizedBox(height: 5.0),
                Card(
                  //color: Color(247247247),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0,8,0,8),
                    child: new ListTile(
                      title: new Text(roomList.elementAt(stay.roomId-1).name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text("Raumnummer: "+stay.roomId.toString()),
                          new Text("Aufenthaltsdauer: " +
                              stay.startTime.hour.toString()+":"+stay.startTime.minute.toString()+
                              " - "+stay.endTime.hour.toString()+":"+stay.endTime.minute.toString()
                          ),
                          new Text("Belastung Raum: "+roomList.elementAt(stay.roomId-1).averageValue.toString() ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(""),
                                flex: 1,
                              ),
                              Expanded(
                                  flex: 5,
                                  child: Center(child: new Text(stay.dose.toString()+" msv"))
                              ),
                              Expanded(
                                flex: 0,
                                child: PopupMenuButton(
                                  onSelected: (result) { setState(() {
                                    result;
                                  });},
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                    const PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                          leading: Icon(Icons.edit),
                                          title: Text('Bearbeiten')
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 2,
                                      child: ListTile(
                                          leading: Icon(Icons.close),
                                          title: Text('Löschen')
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
        )
    );
    setState(() => this._stayWidgets = widgets);
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Center(child: new Text('Aufenthalte')),
        ),
        body:
        Column(
          children: <Widget>[
            Container(child: Column(
              children: <Widget>[
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8,0,0,0),
                        child: new Text('Filtern'),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,8,0),
                        child: new Text('Sortieren'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
              ],
            ),
            ),
            Expanded(
                child:
                new ListView(
                    children: _stayWidgets
                )
            ),
          ],
        )
    );
  }


}


