import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radon_reporter/view/StaysScreen.dart' as StaysScreen;
import 'package:radon_reporter/view/QRScreen.dart' as QRScreen;
import 'package:radon_reporter/view/DoseScreen.dart' as DoseScreen;


main(List<String> arguments) async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  MyStatefulWidgetState createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<MyStatefulWidget> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    QRScreen.QRScanner(),
    DoseScreen.LastStay(),
    StaysScreen.StayScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,   // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            title: Text('Erfassen'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.data_usage),
              title: Text('Dosis')
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            title: Text('Aufenthalte'),
          ),

          new BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Anlagen'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}