
class Stay {
  DateTime startTime;
  DateTime endTime;
  double dose;
  int roomID;
  Stay({this.startTime, this.endTime, this.dose, this.roomID});

  Map<String, dynamic> toJson(Stay instance) => <String, dynamic>{
    'startTime': instance.startTime.toIso8601String(),
    'endTime': instance.endTime.toIso8601String(),
    'dose': instance.dose.toString(),
    'roomID': instance.roomID.toString()
  };

}