
class Employee {
  String firstName;
  String lastName;
  double dosis;
  Employee({this.firstName, this.lastName, this.dosis});

  Map<String, dynamic> toJson(Employee instance) => <String, dynamic>{
    'firstName': instance.firstName,
    'lastName': instance.lastName,
    'dosis': instance.dosis.toString(),
  };

}