import 'dart:io';

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'dart:async';
import 'package:flutter/services.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:radon_reporter/scanner.dart';

void main() => runApp(MaterialApp(home: QRViewExample()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Radon Reporting'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var connection;

  Future<dynamic> openConnection() async{
    connection = new PostgreSQLConnection("86.119.40.8", 5432, "tester", username: "tester", password: "tester2019");
    //logger.debug("establish conn")
    await connection.open();
  }

  Future<List> writeData() async{
    connection.query("INSERT INTO stay (startdate, enddate) VALUES (timestamp '2019-01-08 04:05:06', timestamp '2019-01-08 08:05:06')");
    //var res = await connection.query("SELECT * FROM stay WHERE stay_id = 1");

    List<List<dynamic>> results = await connection.query("SELECT * FROM stay WHERE stay_id = @aValue", substitutionValues: {
      "aValue" : 1
    });

    for (final row in results) {
      var a = row[1];
      print(a);
      var b = row[2];
      print(b);
    }
  }

  static var _start;
  static var _stop;
  var _difference;

  void _printTimeStart() {
    setState(() {
      _start = DateTime.now();
      openConnection();
      //writeData();
    });
  }

  void _printTimeStop() async {
    setState(()  async {
      _stop = DateTime.now().toLocal();
      _difference = _stop.difference(_start);
      writeData();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[      // Add 3 lines from here...
          IconButton(icon: Icon(Icons.photo_camera), onPressed: (){
          }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: _printTimeStart,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Colors.red, Colors.green, Colors.blue],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Center(child: Text('Start')),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Start:',
              ),
            ),

            Center(
              child: Text(
                '$_start',
                style: Theme.of(context).textTheme.display1,
              ),
            ),

            RaisedButton(
              onPressed: _printTimeStop,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Colors.red, Colors.green, Colors.blue],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Center(child: Text('Stop')),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Stop:',
              ),
            ),

            Center(
              child: Text(
                '$_stop',
                style: Theme.of(context).textTheme.display1,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Duration:',
              ),
            ),

            Center(
              child: Text(
                '$_difference',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
          ],
        ),
      ),
    );}
}


class QRViewExample extends StatefulWidget {
  const QRViewExample({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {

  var connection;

  Future<dynamic> openConnection() async{
    connection = new PostgreSQLConnection("86.119.40.8", 5432, "tester", username: "tester", password: "tester2019");
    //logger.debug("establish conn")
    await connection.open();
  }

  Future<List> writeStart() async{
    connection.query("INSERT INTO stay (startdate, enddate) VALUES (timestamp '$_start', timestamp '2019-01-08 08:05:06')");

    //var res = await connection.query("SELECT * FROM stay WHERE stay_id = 1");

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

  static var _start;
  static var _stop;
  var _difference;


  void _printTimeStart() {
    setState(() async {
      _start = DateTime.now().toString();
      //print(_start);
      writeStart();
      //openConnection();
      //writeData();
    });
  }

  void _printTimeStop() async {
    setState(()  async {
      _stop = DateTime.now().toLocal();
      _difference = _stop.difference(_start);
      writeStart();
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
    final channel = controller.channel;
    controller.init(qrKey);
    channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case "onRecognizeQR":
          dynamic arguments = call.arguments;
          setState(() {
            qrText = arguments.toString();
            _printTimeStart();
            new Duration(seconds: 10);
            sleep(new Duration(seconds: 10));
          });
      }
    });
  }
}

