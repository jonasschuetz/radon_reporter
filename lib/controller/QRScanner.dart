import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:radon_reporter/model/stay.dart' as stay;
import 'package:radon_reporter/main.dart' as main;

var currentStay = new stay.Stay();

void setStay(stay.Stay currentStay) async {
  var url = 'http://86.119.40.8:8008/stays';
  var jsonData = currentStay.toJson(currentStay);

  var client = new HttpClient();
  client.findProxy = null;

  Future<http.Response> foo(url, body) async{
    var response = await http.post(Uri.parse(url), body: body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response;
  }

  foo(url, jsonData);
}

void stopStay() async{
  currentStay.endTime = DateTime.now();
  currentStay.dose = 123;
  currentStay.id = 100;
  setStay(currentStay);
}


class QRScanner extends StatefulWidget {
  const QRScanner({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => QRScannerState();
}

class QRScannerState extends State<QRScanner> {

  var currentStayID = 90;

  int setID(){
    currentStayID++;
    return currentStayID;
  }

  void setRoomID(String id){
    //currentStay.roomID = int.parse(ID);
    currentStay.startTime = DateTime.now();
    //setStay(currentStay);
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
            flex: 4,
          ),
          Expanded(
            child: Text("This is the result of scan: $qrText"),
            flex: 1,
          ),
          Expanded(
            child:
            RaisedButton(
              onPressed: null,
              textColor: Colors.white,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Colors.red, Colors.green, Colors.blue],
                  ),
                ),
                child: Center(child: Text('stop')),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    final channel = controller.channel;
    controller.init(qrKey);

    channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case "onRecognizeQR":
          dynamic arguments = call.arguments;
          setState(() {
            qrText = arguments.toString();
            setRoomID(qrText);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => main.StopScreen()),
            );
            dispose();
          });
      }
    });
  }
}



