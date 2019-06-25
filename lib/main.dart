import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radon_reporter/view/StaysScreen.dart' as StaysScreen;
import 'package:radon_reporter/view/QRScreen.dart' as QRScreen;

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
    StaysScreen.StayScreen(),
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
            icon: Icon(Icons.play_circle_outline),
            title: Text('Aufenthalt'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Aufenthalte'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profil')
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



//
//TabController _tabController;
//
//@override
//void initState() {
//  _tabController = new TabController(length: 3, vsync: null );
//
//  globals.tabController = _tabController;
//
//  //super.initState();
//}
//
////@Copyright by uncoded-decimal https://github.com/uncoded-decimal/Flutter_gram
//class TabLayoutDemo extends StatelessWidget {
//
//  static final staysScreenKey = new GlobalKey<StaysScreen.StayScreenState>();
//  static final qrScreenKey = new GlobalKey<QRScreen.QRScannerState>();
//
//  TabController tabController;
//
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      color: Colors.yellow,
//      home: DefaultTabController(
//        length: 4,
//          child: Builder(builder: (BuildContext context) {
//            return Scaffold(
//              body: TabBarView(
//                children: [
//                  QRScreen.QRScanner(),
//                  StaysScreen.StayScreen(),
//                  new Container(
//                    color: Colors.lightGreen,
//                  ),
//                  new Container(
//                    color: Colors.red,
//                  ),
//                ],
//              ),
//              bottomNavigationBar: new TabBar(
//                tabs: [
//                  Tab(
//                    icon: new Icon(Icons.home),
//                  ),
//                  Tab(
//                    icon: new Icon(Icons.list),
//                  ),
//                  Tab(
//                    icon: new Icon(Icons.perm_identity),
//                  ),
//                  Tab(icon: new Icon(Icons.settings),)
//                ],
//                labelColor: Colors.red,
//                unselectedLabelColor: Colors.blue,
//                indicatorSize: TabBarIndicatorSize.label,
//                indicatorPadding: EdgeInsets.all(5.0),
//                indicatorColor: Colors.red,
//              ),
//              backgroundColor: Colors.white,
//            );
//          }
//          ),
//        ),
//    );
//  }
//}