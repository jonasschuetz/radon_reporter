import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:radon_reporter/controller.dart';
import 'package:radon_reporter/main.dart';
import 'package:radon_reporter/view.dart';
import 'package:radon_reporter/model.dart';


class QRViewExampleState extends State<QRViewExample> {

  var connection;

  Future<dynamic> openConnection() async{
    connection = new PostgreSQLConnection("86.119.40.8", 5432, "tester", username: "tester", password: "tester2019");
    //logger.debug("establish conn")
    await connection.open();
  }

  Future<List> writeStart() async{
    connection.query("INSERT INTO stay (startdate, enddate) VALUES (timestamp '$_start', timestamp '2019-01-08 08:05:06')");
    List<List<dynamic>> results = await connection.query("SELECT * FROM stay");
    print(results.last.toString());


//    List<List<dynamic>> results = await connection.query("SELECT * FROM stay WHERE stay_id = @aValue", substitutionValues: {
//      "aValue" : 1
//    });
//
//    for (final row in results) {
//      var a = row[1];
//      print(a);
//      var b = row[2];
//      print(b);
//    }
  }

  Future<List> writeStop() async{
    connection.query("INSERT INTO stay (startdate, enddate) VALUES (timestamp '$_start', timestamp '$_stop')");
    List<List<dynamic>> results = await connection.query("SELECT * FROM stay");
    print(results.last.toString());
  }

  static var _start;
  static var _stop;
  var _difference;


  void _startOfStay() {
    setState(() async {
      _start = DateTime.now().toString();
      writeStart();
    });
  }

  void _stopOfStay() async {
    setState(()  async {
      _stop = DateTime.now();
      writeStop();
      //_difference = _stop.difference(_start);
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
              onPressed: openConnection,
              textColor: Colors.white,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Colors.red, Colors.green, Colors.blue],
                  ),
                ),
                child: Center(child: Text('open connection')),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    var stopwatch = new Stopwatch();

    final channel = controller.channel;
    controller.init(qrKey);

    channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case "onRecognizeQR":
          dynamic arguments = call.arguments;

          setState(() {

            if(qrText=="") {
              qrText = arguments.toString();
              stopwatch..start();
              _startOfStay();
              qrText = "hello";
            }
            if(stopwatch.elapsed.inSeconds>10) {
              qrText = arguments.toString();
              print(stopwatch.elapsed.inSeconds.toString());
              _stopOfStay();
            }

          });

      }
    });
  }
}
