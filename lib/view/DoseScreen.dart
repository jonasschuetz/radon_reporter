
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:radon_reporter/controller/DoseController.dart' as DoseController;
import 'package:radon_reporter/view/Colors.dart' as AppColors;


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

class _AnimatedRadialChartExampleState
    extends State<AnimatedRadialChartExample> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
  new GlobalKey<AnimatedCircularChartState>();
  final _chartSize = const Size(200.0, 200.0);

  double value = 0.0;
  Color labelColor = AppColors.AppBarTextColor;

  @override
  void initState() {
    super.initState();
    _increment();
  }


  Future _increment() async {
    var f = await DoseController.getEmpDose();
    setState(() {
      value = f;
      List<CircularStackEntry> data = _generateChartData(value*10);
      _chartKey.currentState.updateData(data);
    });
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

    if (value > 100) {
      labelColor = Colors.green[200];

      data.add(new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(
            value - 100,
            Colors.green[200],
            rankKey: 'percentage',
          ),
        ],
        rankKey: 'percentage2',
      ));
    }

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
            child: new Text("Aktuelle Dosis"),
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

        ],
      ),
    );
  }
}
