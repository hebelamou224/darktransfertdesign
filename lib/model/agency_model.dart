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
    required this.employees,
  });

  @override
  String toString() {
    return 'AgencyWithEmployees{id: $id, identify: $identify, name: $name, description: $description, lieu: $lieu, account: $account, employees: $employees}';
  }
}