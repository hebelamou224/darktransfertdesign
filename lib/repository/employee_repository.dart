import 'dart:convert';

import 'package:darktransfert/constant.dart';
import 'package:darktransfert/model/employee.dart';
import 'package:http/http.dart' as http;

class EmployeeRepository{



  Future<String> addEmployeeForAnAgency(Employee employee, String usernamePartner, String identifyAgency) async{

    Uri url = Uri.parse("http://${Constant.IP_ADDRESS}:8080/v1/api/transfert/partner/addEmployeeToAgency/$usernamePartner?identify=$identifyAgency");

    var data = <String, dynamic>{
      "username": employee.username,
      "fullname": employee.fullname,
      "address": employee.address,
      "telephone": employee.telephone,
      "role": employee.role
    };

    final response = await http.put(url, body: data);
    if(response.statusCode == 200){
      return "succes";
    }
    return "error";
  }

  Future<String> findByUsername(String usernuame) async{
    Uri url = Uri.parse("http://${Constant.IP_ADDRESS}:8080/v1/api/transfert/employee/$usernuame");
    final response = await http.get(url);
    if(response.statusCode == 200){
      return "exist";
    }
    return "not_exist";
  }
  
  Future<Employee?> updateInformation(Employee employee) async{
    var data = <String, dynamic>{
      "username": employee.username,
      "fullname": employee.fullname,
      "address": employee.address,
      "telephone": employee.telephone,
      "role": employee.role,
      "password": employee.password
    };
    
    Uri url = Uri.parse("http://${Constant.IP_ADDRESS}:8080/v1/api/transfert/employee/update");
    final response = await http.put(url, body: data);
    if(response.statusCode == 200){
      final data = json.decode(utf8.decode(response.bodyBytes));
      String password ;
      if(data["password"] == null){
        password = "";
      }else{
        password = data["password"];
      }
      Employee emp = Employee(
          id: data["id"],
          username: data["username"],
          fullname: data["fullname"],
          address: data["address"],
          telephone: data["telephone"],
          dateRegister: data["dateRegister"],
          role: data["role"],
          identifyAgency: data["identifyAgency"],
          password: password
      );
      return emp;
    }
    return null;
    
  }
  
  

}