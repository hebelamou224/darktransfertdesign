import 'package:darktransfert/model/employee.dart';
import 'package:darktransfert/repository/employee_repository.dart';

class EmployeeService{

  EmployeeRepository employeeRepository = EmployeeRepository();

  Future<String> addEmployeeForAnAgency(Employee employee, String usernamePartner, String identifyAgency) async{
    return await employeeRepository.addEmployeeForAnAgency(employee, usernamePartner, identifyAgency);
  }

  Future<String> findByUsername(String username) async{
    return await employeeRepository.findByUsername(username);
  }

  Future<Employee?> updateInformation(Employee employee) async{
    return await employeeRepository.updateInformation(employee);
  }

}