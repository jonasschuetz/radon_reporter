import 'dart:io';

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

main(List<String> arguments) async {
  runApp(MaterialApp(home: QRScanner()));
}


void setStay(Stay currentStay) async {
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

class Stay {
  int id;
  DateTime startTime;
  DateTime endTime;
  int dose;
  Stay({this.id, this.startTime, this.endTime, this.dose});

  Map<String, dynamic> toJson(Stay instance) => <String, dynamic>{
    'id': instance.id.toString(),
    'startTime': instance.startTime.toString(),
    'endTime': instance.endTime.toString(),
    'dose': instance.dose.toString()
  };

}

class QRScanner extends StatefulWidget {
  const QRScanner({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => QRScannerState();
}

class QRScannerState extends State<QRScanner> {

  var currentStayID = 40;
  var currentStay = new Stay();

  int setID(){
    currentStayID++;
    return currentStayID;
  }


  void startStay() async{
    setState(()  {
      currentStay.startTime = DateTime.now();
    });
  }



  void stopStay() async{
    setState(()  {
      currentStay.endTime = DateTime.now();
      currentStay.dose = 123;
      currentStay.id = setID();
      setStay(currentStay);
    });
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
              onPressed: stopStay,
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
             startStay();
          });
      }
    });
  }
}



