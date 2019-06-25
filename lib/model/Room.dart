class Room {
  int averageBq;
  String name;
  Room({this.name, this.averageBq});

  Map<String, dynamic> toJson(Room instance) => <String, dynamic>{
    'name': instance.name,
    'averageBq': instance.averageBq.toString()
  };

}