import 'dart:math';
import 'package:radon_reporter/controller/RoomController.dart' as RoomController;
import 'package:radon_reporter/controller/QRController.dart' as QRController;
import 'package:radon_reporter/controller/DoseController.dart' as DoseController;



Future doseCalculation() async {
  var empList = await DoseController.fetchAndParseEmps();
  //DoseController.currentEmp.dose  = empList.elementAt(0).dose;
  var duration = QRController.currentStay.endTime.difference(QRController.currentStay.startTime);
  QRController.currentStay.dose = duration.inSeconds*RoomController.currentRoom.averageValue*(0.4)*(1.87)*pow(10,-5);
  DoseController.currentEmp.dose = QRController.currentStay.dose;
  DoseController.setDose(DoseController.currentEmp);
}

void doseUpdate(double stayDose){



}