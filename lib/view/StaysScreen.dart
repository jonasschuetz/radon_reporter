import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radon_reporter/controller/StayController.dart' as StayController;
import 'package:radon_reporter/controller/QRController.dart' as QRController;
import 'package:radon_reporter/model/Stay.dart' as Stay;



// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class StayScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StayScreenState();
}

class StayScreenState extends State<StayScreen>{

  TabController tabController;

  var stayWidgets = <Widget>[];

  @override
  void initState() {
    super.initState();
    _getStays();
    //QRController.stopStay();
  }

  _getStays() async {
    List<Widget> widgets = [];
    Stay.Stay stays;
    var stayList = await StayController.fetchAndParseStays();
    stayList.forEach((stay) =>
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


