import 'dart:io';

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:radon_reporter/model/stay.dart' as stay;
import 'package:radon_reporter/controller/QRScanner.dart' as QRScanner;
import 'package:radon_reporter/view/DoseScreen.dart' as DoseScreen;



main(List<String> arguments) async {
  runApp(TabLayoutDemo());
}

//@Copyright by uncoded-decimal https://github.com/uncoded-decimal/Flutter_gram
class TabLayoutDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      color: Colors.yellow,
      home: DefaultTabController(
        length: 4,
          child: new Scaffold(
            body: TabBarView(
              children: [
                QRScanner.QRScanner(),
                DoseScreen.DoseScreen(),
                new Container(
                  color: Colors.lightGreen,
                ),
                new Container(
                  color: Colors.red,
                ),
              ],
            ),
            bottomNavigationBar: new TabBar(
              tabs: [
                Tab(
                  icon: new Icon(Icons.home),
                ),
                Tab(
                  icon: new Icon(Icons.list),
                ),
                Tab(
                  icon: new Icon(Icons.perm_identity),
                ),
                Tab(icon: new Icon(Icons.settings),)
              ],
              labelColor: Colors.red,
              unselectedLabelColor: Colors.blue,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.all(5.0),
              indicatorColor: Colors.red,
            ),
            backgroundColor: Colors.white,
          ),
        ),
    );
  }
}