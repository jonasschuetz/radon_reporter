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
  runApp(MaterialApp(home: QRScanner.QRScanner()));
}



class StopScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => StopScreenState();
}


class StopScreenState extends State<StopScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stop Stay'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('stop'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoseScreen.DoseScreen()),
            );
            QRScanner.stopStay();
            //DoseScreen.getStay();
          },
        ),
      ),
    );
  }

  }