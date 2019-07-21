import 'dart:math';
import 'package:radon_reporter/controller/RoomController.dart' as RoomController;
import 'package:radon_reporter/controller/DoseController.dart' as DoseController;
import 'package:radon_reporter/controller/StayController.dart' as StayController;

Future doseCalculation()   {
  var duration = StayController.currentStay.endTime.difference(StayController.currentStay.startTime);
  StayController.currentStay.dose = duration.inSeconds*RoomController.currentRoom.averageValue*(0.4)*(1.87)*pow(10,-5);
}

double getDose(){
  return DoseController.currentEmp.dosis;
}