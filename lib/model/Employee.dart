
class Employee {
  String firstName;
  String lastName;
  double dose;
  Employee({this.firstName, this.lastName, this.dose});

  Map<String, dynamic> toJson(Employee instance) => <String, dynamic>{
    'firstName': instance.firstName,
    'lastName': instance.lastName,
    'dose': instance.dose.toString(),
  };

}