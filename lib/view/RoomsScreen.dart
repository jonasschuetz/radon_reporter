import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radon_reporter/controller/StayController.dart' as StayController;
import 'package:radon_reporter/controller/QRController.dart' as QRController;
import 'package:radon_reporter/model/Room.dart' as Room;
import 'package:radon_reporter/controller/RoomController.dart' as RoomController;
import 'package:radon_reporter/view/Colors.dart' as AppColors;



//Some lines of code are from:
// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class RoomScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RoomScreenState();
}

class RoomScreenState extends State<RoomScreen>{

  TabController _tabController;

      var _roomWidgets = <Widget>[];

  @override
  void initState() {
    super.initState();
    _getRooms();
  }

  _getRooms() async {
    List<Widget> widgets = [];
    var roomList = await RoomController.fetchAndParseRooms();
    //stayList.where((stay)=> stay.id==1);
    roomList.sort((a,b) => a.id.compareTo(b.id));
    roomList.forEach((room) =>
        widgets.add(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //todo: Anlagename
               // new Text(room.startTime.day.toString()+"."+room.startTime.month.toString()+"."+room.startTime.year.toString()),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0,8,0,8),
                    child: new ListTile(
                      title: new Text("ID: "+room.id.toString()),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(room.name),
                          new Text("Belastung Sommer: " ),
                          new Text("Belastung Winter: " ),
                          Center(child: new Text(room.averageValue.toString())),
                          Center(child: new Text("Bq/m3")),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
        )
    );
    setState(() => this._roomWidgets = widgets);
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('Räume'),
          centerTitle: true,
          backgroundColor: AppColors.AppBarBackground,
          textTheme: TextTheme(
              title: TextStyle(
                color: AppColors.AppBarTextColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )
          ),
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
                    children: _roomWidgets
                )
            ),
          ],
        )
    );
  }


}


