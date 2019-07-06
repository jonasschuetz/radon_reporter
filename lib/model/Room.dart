class Room {
  int averageValue;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  Room({this.name, this.averageValue, this.createdAt ,this.updatedAt});

  Map<String, dynamic> toJson(Room instance) => <String, dynamic>{
    'name': instance.name,
    'averageBq': instance.averageValue.toString(),
    'createdAt': instance.createdAt.toIso8601String(),
    'updatedAt': instance.updatedAt.toIso8601String(),

  };

}