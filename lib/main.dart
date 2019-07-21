import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radon_reporter/view/StaysScreen.dart' as StaysScreen;
import 'package:radon_reporter/view/QRScreen.dart' as QRScreen;
import 'package:radon_reporter/view/DoseScreen.dart' as DoseScreen;
import 'package:radon_reporter/view/RoomsScreen.dart' as RoomScreen;
import 'package:radon_reporter/view/Colors.dart' as AppColors;

main() async {
  runApp(MyApp());
}

var currentEmpId = 2;

class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
      color: Colors.black,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  MyStatefulWidgetState createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<MyStatefulWidget> {

  int currentIndex = 0;

  final List<Widget> _children = [
    QRScreen.QRScanner(),
    DoseScreen.AnimatedRadialChartExample(),
    StaysScreen.StayScreen(),
    RoomScreen.RoomScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: AppColors.AppBarTextColor,
        onTap: onTabTapped,
        currentIndex: currentIndex,
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
      currentIndex = index;
    });
  }

}