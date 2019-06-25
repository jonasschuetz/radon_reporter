import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/widgets.dart';
import 'package:radon_reporter/controller/QRController.dart' as QRController;
import 'package:radon_reporter/controller/StayController.dart' as StayController;
import 'package:radon_reporter/main.dart' as main;
import 'package:radon_reporter/model/Stay.dart' as Stay;



class QRScanner extends StatefulWidget {
  const QRScanner({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => QRScannerState();
}

class QRScannerState extends State<QRScanner> {



  bool scan = true;
  bool stop = false;
  bool manual = false;

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

 // Future<String> lastStay = getLastStay();



  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Flutter App'),
      ),
      body: Column(
        children: <Widget>[
          Visibility(
            visible: scan,
            child: Expanded(
              child:
              Padding(
                padding: const EdgeInsets.fromLTRB(0,50,0,0),
                child: Text("Bitte scannen Sie den QR Code"),
              ),
              flex: 1,
            ),
          ),
          Visibility(
            visible: scan,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0,0,20.0,0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,40),
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
              ),
              flex: 2,
            ),
          ),
          Visibility(
            visible: scan,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,40,0,40),
                child: RaisedButton(
                  child: Text('Manuelle Eingabe'),
                  onPressed: (){
                    setState(() {
                      scan = false;
                      manual = true;
                    });
                  },
                ),
              ),
            ),
          ),
          Visibility(
            visible: scan,
            child: Expanded(
              child:
              Padding(
                padding: const EdgeInsets.fromLTRB(0,50,0,0),
                child: Text('laststay'),
              ),
              flex: 1,
            ),
          ),



          //View if manual start
          Visibility(
            visible: manual,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Geben Sie den Code ein'
                    ),
                    controller: myController,),
                ),
                const SizedBox(height: 20.0),
                RaisedButton(
                  child: Text('check'),
                  onPressed: () {
                    setState(() {
                      QRController.currentStay.startTime = DateTime.now();
                      scan = false;
                      manual = false;
                      stop = true;
                    });
                  },
                ),
              ],
            ),
          ),



          Visibility(
            visible: stop,
            child: Column(
              children: <Widget>[
                RaisedButton(
                  child: Text('stop'),
                  onPressed: () {
                    QRController.stopStay();
                    setState(() {
                      stop = false;
                      scan = true;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                Text('hello'),
              ],
            ),
          ),
          //Stop view
//          Visibility(
//            visible: stop,
//            child: Center(
//              child: Padding(
//                padding: const EdgeInsets.fromLTRB(0,300,0,0),
//                child: RaisedButton(
//                  child: Text('stop'),
//                  onPressed: () {
//                    QRController.stopStay();
//                    setState(() {
//                      stop = false;
//                      scan = true;
//                    });
//                  },
//                ),
//              ),
//            ),
//          ),
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
            QRController.currentStay.startTime = DateTime.now();
            QRController.setRoomID(qrText);
            stop = true;
            scan = false;
          });
      }
    });
  }
}


Future<String> getLastStay() async {
  List<Widget> widgets = [];
  var stayList = await StayController.fetchAndParseStays();
  var lastStay = stayList.last;

  return lastStay.startTime.toIso8601String();
}

