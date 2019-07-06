import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radon_reporter/controller/StayController.dart' as StayController;
import 'package:radon_reporter/controller/QRController.dart' as QRController;
import 'package:radon_reporter/model/Stay.dart' as Stay;


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
    Stay.Stay stays;
    var stayList = await StayController.fetchAndParseStays();
    stayList.sort((a,b) => a.startTime.compareTo(b.startTime));
    stayList.forEach((stay) =>
        widgets.add(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(stay.startTime.weekday.toString()),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0,8,0,8),
                    child: new ListTile(
                      title: new Text("Id "+stay.id.toString()),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text("Raumnummer: "),
                          new Text("Aufenthaltsdauer: " +
                              stay.startTime.toLocal().hour.toString()+":"+stay.startTime.minute.toString()+
                              " - "+stay.endTime.toLocal().hour.toString()+":"+stay.endTime.minute.toString()
                          ),
                          new Text("Belastung Raum: "),
                          Row(
                            children: <Widget>[
                              new Text("0.002 msv"),
                              PopupMenuButton(
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


