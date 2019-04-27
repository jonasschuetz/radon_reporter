import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
    connection = new PostgreSQLConnection("localhost", 5432, "jonasschutz", username: "jonasschuetz", password: "tester2019");
    await connection.open();
  }

  Future<List> writeData() async{
    connection.query("INSERT INTO stay (startdate, enddate) VALUES (2019-01-08 04:05:06, 2019-01-08 08:05:06)");
    connection.query("SELECT * FROM stay WHERE id = @idParam", {"idParam" : 1});
  }

  static var _start;
  static var _stop;
  var _difference;

  void _printTimeStart() {
    setState(() {
      _start = DateTime.now();
      openConnection();
      writeData();
    });
  }

  void _printTimeStop() {
    setState(() {
      _stop = DateTime.now().toLocal();
      _difference = _stop.difference(_start);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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


