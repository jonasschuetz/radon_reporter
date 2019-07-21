
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:radon_reporter/controller/DoseController.dart' as DoseController;
import 'package:radon_reporter/view/Colors.dart' as AppColors;
import 'package:flutter/widgets.dart';
import 'package:radon_reporter/controller/StayController.dart' as StayController;
import 'package:radon_reporter/controller/RoomController.dart' as RoomController;
import 'package:radon_reporter/view/Colors.dart' as Colors;
import 'package:radon_reporter/main.dart' as Main;



void main() {
  runApp(new MaterialApp(
    home: new AnimatedRadialChartExample(),
  ));
}

class AnimatedRadialChartExample extends StatefulWidget {
  @override
  _AnimatedRadialChartExampleState createState() =>
      new _AnimatedRadialChartExampleState();
}

class _AnimatedRadialChartExampleState extends State<AnimatedRadialChartExample> {

  final GlobalKey<AnimatedCircularChartState> _chartKey =
  new GlobalKey<AnimatedCircularChartState>();
  final _chartSize = const Size(200.0, 200.0);

  double value = 0.0;
  Color labelColor = AppColors.AppBarTextColor;
  RoomController.RoomParse room;
  StayController.StayParse stay;

  var _stayWidgets = <Widget>[];


  @override
  void initState() {
    super.initState();
    _increment();
    getStayData();
    _getStays();
  }


  Future _increment() async {
    var dosis = await DoseController.getEmpDose(Main.currentEmpId);
    setState(() {
      value = dosis;
      List<CircularStackEntry> data = _generateChartData(value * 10);
      _chartKey.currentState.updateData(data);
    });
  }

  void getStayData() async {
    var stayList = await StayController.fetchAndParseStays();
    var roomList = await RoomController.fetchAndParseRooms();
    stayList.sort((a, b) => b.startTime.compareTo(a.startTime));
    roomList.sort((a, b) => a.id.compareTo(b.id));
    stay = stayList.first;
    room = roomList.elementAt(stay.roomId - 1);
  }


  List<CircularStackEntry> _generateChartData(double value) {
    Color dialColor = AppColors.PieChartColor;
    labelColor = dialColor;

    List<CircularStackEntry> data = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(
            value,
            dialColor,
            rankKey: 'percentage',
          )
        ],
        rankKey: 'percentage',
      ),
    ];


    return data;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _labelStyle = Theme
        .of(context)
        .textTheme
        .title
        .merge(new TextStyle(color: labelColor));

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Dosis'),
        centerTitle: true,
        backgroundColor: AppColors.AppBarBackground,
        textTheme: TextTheme(
            title: TextStyle(
              color: AppColors.AppBarTextColor,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )
        ),
      ),
      body: new Column(
        children: <Widget>[
          const SizedBox(height: 20.0),
          new Container(
            child: new Text("Aktuelle Dosis",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.AppBarTextColor
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          new Container(
            child: Center(
              child: Card(
                child: new AnimatedCircularChart(
                  key: _chartKey,
                  size: _chartSize,
                  initialChartData: _generateChartData(value),
                  chartType: CircularChartType.Radial,
                  edgeStyle: SegmentEdgeStyle.round,
                  percentageValues: true,
                  holeLabel: '$value',
                  labelStyle: _labelStyle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          new Container(
            child: new Text("Letzter Aufenthalt",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.AppBarTextColor
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
              child:
              new ListView(
                  children: _stayWidgets
              )
          ),
        ],
      ),
    );
  }


  _getStays() async {
    List<Widget> widgets = [];
    var stayList = await StayController.fetchAndParseStays();
    var roomList = await RoomController.fetchAndParseRooms();
    stayList.sort((a,b) => b.startTime.compareTo(a.startTime));
    roomList.sort((a,b) => a.id.compareTo(b.id));

    var stay = stayList.sublist(0,1);

    stay.forEach((stay) =>
        widgets.add(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 5.0),
//                new Text(stay.startTime.day.toString()+"."+stay.startTime.month.toString()+"."+stay.startTime.year.toString(),
//
//                ),
                const SizedBox(height: 5.0),
                Card(
                  //color: Color(247247247),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0,21,0,8),
                    child: new ListTile(
                      title: new Text(roomList.elementAt(stay.roomId-1).name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.AppBarTextColor
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 16.0),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: new Text("Raumnummer: "),
                                flex: 1,
                              ),
                              Expanded(
                                child: new Text(stay.roomId.toString()),
                                flex: 1,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: new Text("Aufenthaltsdauer: "),
                                flex: 1,
                              ),
                              Expanded(
                                child: new Text(stay.startTime.hour.toString()+":"+stay.startTime.minute.toString()+
                                    " - "+stay.endTime.hour.toString()+":"+stay.endTime.minute.toString()),
                                flex: 1,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: new Text("Belastung Raum: "),
                                flex: 1,
                              ),
                              Expanded(
                                child: new Text(roomList.elementAt(stay.roomId-1).averageValue.toString()),
                                flex: 1,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(""),
                                flex: 1,
                              ),
                              Expanded(
                                  flex: 5,
                                  child: Center(child: new Text(stay.dose.toString()+" msv",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.AppBarTextColor
                                    ),
                                  )
                                  )
                              ),
                              Expanded(
                                flex: 0,
                                child: PopupMenuButton(
                                  onSelected: (result) { setState(() {
                                    result;
                                  });},
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                    const PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                          leading: Icon(Icons.edit),
                                          title: Text('Bearbeiten')
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 2,
                                      child: ListTile(
                                          leading: Icon(Icons.close),
                                          title: Text('Löschen')
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
        )
    );
    setState(() => this._stayWidgets = widgets);
  }
//}

}