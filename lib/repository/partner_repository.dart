import 'dart:convert';
import 'dart:ffi';

import 'package:darktransfert/constant.dart';
import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/model/employee.dart';
import 'package:darktransfert/model/partner.dart';
import 'package:darktransfert/model/partners_get.dart';
import 'package:http/http.dart' as http;

import '../model/agency_model.dart';


class PartnerRepository{

  static String IP_ADDRESS = "192.168.21.113";

  static List<Partner> parseResponse(String responseBody){
    final parsed = jsonDecode(responseBody).cast<Map<String,dynamic>>();

    return parsed.map<Partner>((json) => Partner.fromJson(json)).toList();
  }


  Future<String> addPartner(Partner partner) async{
    String responseCreated;
    Uri url = Uri.parse("http://${IP_ADDRESS}:8080/v1/api/transfert/partner/add");
    var data = <String, dynamic>{};
    data["username"] = partner.username;
    data["fullname"] = partner.fullname;
    data["address"] = partner.address;
    data["telephone"] = partner.telephone;

    final response = await http.post(url,body: data,headers: {
      "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
    });
    if(response.statusCode == 200){
      if(response.body == "succes"){
        responseCreated = "succes";
      }
      else {
        responseCreated = "username_exist";
      }
    }else{
      responseCreated = "Error de requette, veuillez reprendre";
    }
    return responseCreated;
  }

  Future<List<Partner>> findAllPartner() async{
    Uri url = Uri.parse("http://${Constant.IP_ADDRESS}:8080/v1/api/transfert/partner/");
    final response = await http.get(url);
    if(response.statusCode == 200){
      List<Partner> list = parseResponse(response.body);
      return list;
    }
    return [];
  }

  Future<List<PartnerModel>> findAllPartnersWithValue(String searchValue) async{
    Uri url = Uri.parse("http://${Constant.IP_ADDRESS}:8080/v1/api/transfert/partner?searchValue=$searchValue");
    final response = await http.get(url);
    if(response.statusCode == 200){
      final data = json.decode(utf8.decode(response.bodyBytes));
      List<PartnerModel> list = [];
      for(int i = 0; i < data.length; i++){

        //get all employees in agency for partner
        List<Employee> employees = [];
        for(int j = 0; j < data[i]["agencies"].length; j++){
          for(int k = 0; k < data[i]["agencies"][j]["employees"].length; k++){
            employees.add(
                Employee(
                    id: data[i]["agencies"][j]["employees"][k]["id"],
                    username: data[i]["agencies"][j]["employees"][k]["username"],
                    fullname: data[i]["agencies"][j]["employees"][k]["fullname"],
                    address: data[i]["agencies"][j]["employees"][k]["address"],
                    telephone: data[i]["agencies"][j]["employees"][k]["telephone"],
                    dateRegister: data[i]["agencies"][j]["employees"][k]["dateRegister"],
                    role: data[i]["agencies"][j]["employees"][k]["role"],
                    identifyAgency: data[i]["agencies"][j]["employees"][k]["identifyAgency"],
                    password: data[i]["agencies"][j]["employees"][k]["password"]
                )
            );
          }
        }
        //get all agency for partner
        List<AgencyWithEmployees> agencies = [];
        for(int j = 0; j < data[i]["agencies"].length; j++){
          agencies.add(
              AgencyWithEmployees(
                  id: data[i]["agencies"][j]["id"],
                  identify: data[i]["agencies"][j]["identify"],
                  name: data[i]["agencies"][j]["name"],
                  description: data[i]["agencies"][j]["description"],
                  lieu: data[i]["agencies"][j]["lieu"],
                  account: data[i]["agencies"][j]["account"],
                  employees: employees
              )
          );
        }

        //add partner with yours information's
        list.add(
            PartnerModel(
                id: data[i]["id"],
                username: data[i]["username"],
                fullname: data[i]["fullname"],
                telephone: data[i]["telephone"],
                address: data[i]["address"],
                dateRegister: data[i]["dateRegister"],
                agencies: agencies,
                employees: employees
            )
        );
      }
      return list;
    }
    return [];
  }

  Future<List<PartnerModel>> findAllPartners() async{
    Uri url = Uri.parse("http://${Constant.IP_ADDRESS}:8080/v1/api/transfert/partner/");
    final response = await http.get(url);
    if(response.statusCode == 200){
      final data = json.decode(utf8.decode(response.bodyBytes));
      List<PartnerModel> list = [];
      for(int i = 0; i < data.length; i++){

        //get all employees in agency for partner
        List<Employee> employees = [];
        for(int j = 0; j < data[i]["agencies"].length; j++){
          for(int k = 0; k < data[i]["agencies"][j]["employees"].length; k++){
            employees.add(
                Employee(
                    id: data[i]["agencies"][j]["employees"][k]["id"],
                    username: data[i]["agencies"][j]["employees"][k]["username"],
                    fullname: data[i]["agencies"][j]["employees"][k]["fullname"],
                    address: data[i]["agencies"][j]["employees"][k]["address"],
                    telephone: data[i]["agencies"][j]["employees"][k]["telephone"],
                    dateRegister: data[i]["agencies"][j]["employees"][k]["dateRegister"],
                    role: data[i]["agencies"][j]["employees"][k]["role"],
                    identifyAgency: data[i]["agencies"][j]["employees"][k]["identifyAgency"],
                    password: data[i]["agencies"][j]["employees"][k]["password"]
                )
            );
          }
        }
        //get all agency for partner
        List<AgencyWithEmployees> agencies = [];
        for(int j = 0; j < data[i]["agencies"].length; j++){
          agencies.add(
              AgencyWithEmployees(
                id: data[i]["agencies"][j]["id"],
                identify: data[i]["agencies"][j]["identify"],
                name: data[i]["agencies"][j]["name"],
                description: data[i]["agencies"][j]["description"],
                lieu: data[i]["agencies"][j]["lieu"],
                account: data[i]["agencies"][j]["account"],
                employees: employees
            )
          );
        }

        //add partner with yours information's
        list.add(
            PartnerModel(
                id: data[i]["id"],
                username: data[i]["username"],
                fullname: data[i]["fullname"],
                telephone: data[i]["telephone"],
                address: data[i]["address"],
                dateRegister: data[i]["dateRegister"],
                agencies: agencies,
                employees: employees
            )
        );
      }
      return list;
    }
    return [];
  }

}