import 'dart:math';
import 'package:radon_reporter/controller/RoomController.dart' as RoomController;
import 'package:radon_reporter/controller/QRController.dart' as QRController;
import 'package:radon_reporter/controller/DoseController.dart' as DoseController;



Future doseCalculation()   {
  var duration = QRController.currentStay.endTime.difference(QRController.currentStay.startTime);
  QRController.currentStay.dose = duration.inSeconds*RoomController.currentRoom.averageValue*(0.4)*(1.87)*pow(10,-5);
  DoseController.currentEmp.dosis = DoseController.currentEmp.dosis+QRController.currentStay.dose;
  DoseController.setDose(DoseController.currentEmp);
}

void doseUpdate(double stayDose) {

}