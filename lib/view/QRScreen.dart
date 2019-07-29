import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/widgets.dart';
import 'package:radon_reporter/controller/StayController.dart' as StayController;
import 'package:radon_reporter/view/DoseScreen.dart' as DoseScreen;
import 'package:radon_reporter/controller/RoomController.dart' as RoomController;
import 'package:radon_reporter/controller/DoseController.dart' as DoseController;
import 'package:radon_reporter/view/Colors.dart' as AppColors;
import 'package:radon_reporter/main.dart' as Main;


// Some lines of code are from:
// Copyright 2018 Julius Canute

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
    myController.dispose();
    super.dispose();
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final _formKey = GlobalKey<FormState>();
  var qrText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BackgroundColor,
      appBar: new AppBar(
        title: const Text('Erfassen'),
        centerTitle: true,
        backgroundColor: AppColors.AppBarBackground,
        textTheme: TextTheme(
            title: TextStyle(
              color: AppColors.TextColor,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )
        ),
      ),
      body:
      Column(
        children: <Widget>[
          Visibility(
            visible: scan,
            child: Expanded(
              child:
              Padding(
                padding: const EdgeInsets.fromLTRB(0,50,0,0),
                child: Text("Bitte scannen Sie den QR Code",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.TextColor
                  ),
                ),
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
                    onQRViewCreated: _idEntered,
                  ),
                ),
              ),
              flex: 2,
            ),
          ),
          Visibility(
            visible: scan,
            child:
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,40,0,40),
                child: FlatButton(
                  color: AppColors.ButtonColor,
                  textColor: AppColors.TextColor,
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




          //View if manual start
          Visibility(
            visible: manual,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 100.0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: this._formKey,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Bitte geben Sie die Raumnummer ein'
                      ),
                      controller: myController,
                      onSaved: (value) {
                        setState(() {
                          print(value);
                          qrText = value;
                          StayController.currentStay.startTime = DateTime.now();
                          RoomController.getRoomDetails(int.parse(value));
                          DoseController.getEmpDetails(Main.currentEmpId);
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                RaisedButton(
                  child: Text('Aufenthalt starten'),
                  onPressed: () {
                    setState(() {
                      _formKey.currentState.save();
                      scan = false;
                      manual = false;
                      stop = true;
                    });
                  },
                ),
              ],
            ),
          ),


          //Stop view
          Visibility(
            visible: stop,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50.0),
                Text('Raumnummer '+qrText),
                const SizedBox(height: 8.0),
                Text('Aufenthalt gestartet '+DateTime.now().hour.toString()+":"+DateTime.now().minute.toString()
                ),
                const SizedBox(height: 50.0),
                Center(
                  child: RaisedButton(
                    child: Text('Stopp'),
                    onPressed: () {
                      StayController.stopStay();
                      setState(() {
                        stop = false;
                        scan = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _idEntered(QRViewController controller) {

    final channel = controller.channel;
    controller.init(qrKey);

    channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case "onRecognizeQR":
          dynamic arguments = call.arguments;
          setState(() {
            qrText = arguments.toString();
            StayController.currentStay.startTime = DateTime.now();
            stop = true;
            scan = false;
            RoomController.getRoomDetails(int.parse(qrText));
            DoseController.getEmpDetails(Main.currentEmpId);
          }
          );
      }
    });
  }
}
