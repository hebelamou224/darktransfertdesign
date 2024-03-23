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
      print(response.body);
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

}