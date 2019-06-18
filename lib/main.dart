import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radon_reporter/view/StaysScreen.dart' as StaysScreen;
import 'package:radon_reporter/view/QRScreen.dart' as QRScreen;

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
                QRScreen.QRScanner(),
                StaysScreen.StayScreen(),
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