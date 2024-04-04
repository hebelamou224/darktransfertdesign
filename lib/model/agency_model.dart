import 'employee.dart';

class AgencyWithEmployees{
  int id;
  String identify;
  String name;
  String description;
  String lieu;
  double account;
  List<Employee> employees;

  AgencyWithEmployees({
    required this.id,
    required this.identify,
    required this.name,
    required this.description,
    required this.lieu,
    required this.account,
    required this.employees
  });
}