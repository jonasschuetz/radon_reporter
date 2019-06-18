import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radon_reporter/controller/StayController.dart' as StayController;


// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


class StayScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => StayScreenState();
}


class StayScreenState extends State<StayScreen>{

  var stayWidgets = <Widget>[];

  @override
  void initState() {
    super.initState();
    _getStays();
  }

  _getStays() async {

    List<Widget> widgets = [];
    var stayList = await StayController.fetchAndParseStays();
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


