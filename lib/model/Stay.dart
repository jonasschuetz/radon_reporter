
class Stay {
  int id;
  DateTime startTime;
  DateTime endTime;
  int dose;
  //int roomID;
  Stay({this.id, this.startTime, this.endTime, this.dose});

  Map<String, dynamic> toJson(Stay instance) => <String, dynamic>{
    'id': instance.id.toString(),
    'startTime': instance.startTime.toString(),
    'endTime': instance.endTime.toString(),
    'dose': instance.dose.toString()
  };

}