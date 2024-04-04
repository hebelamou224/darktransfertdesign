import 'agency_model.dart';
import 'employee.dart';

class PartnerModel{
  int id;
  String username;
  String fullname;
  String address;
  String telephone;
  String dateRegister;
  List<AgencyWithEmployees> agencies;
  List<Employee> employees;

  PartnerModel({
    required this.id,
    required this.username,
    required this.fullname,
    required this.telephone,
    required this.address,
    required this.dateRegister,
    required this.agencies,
    required this.employees
  });

  numberEmployees(){
    return employees.length;
  }
  numberAgencies(){
    return agencies.length;
  }
}