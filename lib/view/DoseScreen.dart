import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radon_reporter/controller/StayController.dart' as StayController;
import 'package:radon_reporter/controller/QRController.dart' as QRController;
import 'package:radon_reporter/model/Stay.dart' as Stay;



// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class LastStay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LastStayState();
}

class LastStayState extends State<LastStay>{

  TabController tabController;

  var lastStayWidget = <Widget>[];

  @override
  void initState() {
    super.initState();
    _getStays();
    //QRController.stopStay();
  }

  _getStays() async {
    List<Widget> widgets = [];
    var stayList = await StayController.fetchAndParseStays();
    var lastIndex = stayList.length-1;
    var lastStay = await StayController.fetchAndParseStay(2);
    lastStay.forEach((stay) =>
        widgets.add(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Card(
                  child: new ListTile(
                    title: new Text("Id "+stay.id.toString()),
                    subtitle: new Text("Dose " +stay.endTime.toIso8601String()),
                  ),
                ),
              ],
            )
        )
    );
    setState(() => this.lastStayWidget = widgets);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Center(child: new Text('Dosis')),
        ),
        body: Column(
          children: <Widget>[
            Container(child: new Text('hello')),
            Column(
              children: <Widget>[
                new ListView(children: lastStayWidget),
              ],
            ),
          ],
        )
    );
  }


}


