import 'dart:math';
import 'package:radon_reporter/controller/RoomController.dart' as RoomController;
import 'package:radon_reporter/controller/QRController.dart' as QRController;
import 'package:radon_reporter/controller/DoseController.dart' as DoseController;
import 'package:radon_reporter/view/DoseScreen.dart' as DoseScreen;


double value;

Future doseCalculation()   {
  var duration = QRController.currentStay.endTime.difference(QRController.currentStay.startTime);
  QRController.currentStay.dose = duration.inSeconds*RoomController.currentRoom.averageValue*(0.4)*(1.87)*pow(10,-5);
  DoseController.currentEmp.dosis = DoseController.currentEmp.dosis+QRController.currentStay.dose;
  QRController.currentStay.employeeId = 1;
  DoseController.setDose(DoseController.currentEmp);
}

void doseUpdate(double stayDose) {

}

double getDose(){
  return   DoseController.currentEmp.dosis;

}