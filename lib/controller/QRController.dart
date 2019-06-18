import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:radon_reporter/model/Stay.dart' as Stay;

var currentStay = new Stay.Stay();

void setStay(Stay.Stay currentStay) async {
  var url = 'http://86.119.40.8:8008/stays';
  var jsonData = currentStay.toJson(currentStay);

  var client = new HttpClient();
  client.findProxy = null;

  Future<http.Response> foo(url, body) async{
    var response = await http.post(Uri.parse(url), body: body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response;
  }

  foo(url, jsonData);
}

void stopStay() async{
  currentStay.endTime = DateTime.now();
  currentStay.dose = 123;
  currentStay.id = 100;
  setStay(currentStay);
}
//
//
//class QRScanner extends StatefulWidget {
//  const QRScanner({
//    Key key,
//  }) : super(key: key);
//
//  @override
//  State<StatefulWidget> createState() => QRScannerState();
//}
//
//class QRScannerState extends State<QRScanner> {
//
//  var currentStayID = 90;
//
//  int setID(){
//    currentStayID++;
//    return currentStayID;
//  }
//
//  void setRoomID(String id){
//    //currentStay.roomID = int.parse(ID);
//    currentStay.startTime = DateTime.now();
//    //setStay(currentStay);
//  }
//
//  bool scan = true;
//  bool stop = false;
//
//  void _changed(bool visibility, String field) {
//    setState(() {
//      if (field == "scan"){
//        scan = visibility;
//      }
//      if (field == "stop"){
//        stop = visibility;
//      }
//    });
//  }
//
//  TabController _tabController;
//
//  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//  var qrText = "";
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: new AppBar(
//        title: new Text('Aufenthalt loggen'),
//      ),
//      body: Column(
//        children: <Widget>[
//          Visibility(
//            visible: scan,
//            child: Expanded(
//                child:
//                Padding(
//                  padding: const EdgeInsets.fromLTRB(0,50,0,0),
//                  child: Text("Bitte scannen Sie den QR Code"),
//                ),
//              flex: 1,
//            ),
//          ),
//          Visibility(
//            visible: scan,
//            child: Expanded(
//              child: Padding(
//                padding: const EdgeInsets.fromLTRB(20.0,0,20.0,0),
//                child: Padding(
//                  padding: const EdgeInsets.fromLTRB(20,0,20,40),
//                  child: QRView(
//                    key: qrKey,
//                    onQRViewCreated: _onQRViewCreated,
//                  ),
//                ),
//              ),
//              flex: 2,
//            ),
//          ),
////          Expanded(
////            child: Text("This is the result of scan: $qrText"),
////            flex: 1,
////          ),
//          Visibility(
//            visible: scan,
//            child: Expanded(
//              child: Padding(
//                padding: const EdgeInsets.fromLTRB(0,40,0,40),
//                child: RaisedButton(
//                  child: Text('Manuelle Eingabe'),
//                  onPressed: null,
////                  () {
////                Navigator.push(
////                  context,
////                  MaterialPageRoute(builder: (context) => DoseScreen.DoseScreen()),
////                );
////                QRScanner.stopStay();
////                //DoseScreen.getStay();
////              },
//                ),
//              ),
//            ),
//          ),
//          Visibility(
//            visible: stop,
//            child: Center(
//              child: Padding(
//                padding: const EdgeInsets.fromLTRB(0,300,0,0),
//                child: RaisedButton(
//                  child: Text('stop'),
//                  onPressed: () {
//
////                  Navigator.push(
////                    context,
////                    MaterialPageRoute(builder: (context) => DoseScreen.DoseScreen()),
////                  );
//                    stopStay();
//                    setState(() {
//                      stop = false;
//                      scan = true;
//                      //navigate with TabController
//                    });
//                        () => _tabController.animateTo((_tabController.index + 1) % 2);
//                    //DoseScreen.getStay();
//                  },
//                ),
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  void _onQRViewCreated(QRViewController controller) {
//    final channel = controller.channel;
//    controller.init(qrKey);
//
//    channel.setMethodCallHandler((MethodCall call) async {
//      switch (call.method) {
//        case "onRecognizeQR":
//          dynamic arguments = call.arguments;
//          setState(() {
//            qrText = arguments.toString();
//            //setRoomID(qrText);
//            stop = true;
//            scan = false;
////            Navigator.push(
////              context,
////              MaterialPageRoute(builder: (context) => stopScreen.StopScreen()),
////            );
//            //dispose();
//          });
//      }
//    });
//  }
//}
//
//
//
//
