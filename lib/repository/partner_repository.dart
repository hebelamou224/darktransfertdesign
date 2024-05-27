import 'dart:convert';
import 'dart:typed_data';

import 'package:darktransfert/constant.dart';
import 'package:darktransfert/model/employee.dart';
import 'package:darktransfert/model/partner.dart';
import 'package:darktransfert/model/partners_get.dart';
import 'package:http/http.dart' as http;

import '../model/agency_model.dart';


class PartnerRepository{
  static List<Partner> parseResponse(Uint8List bodyBytes){
    final parsed = json.decode(utf8.decode(bodyBytes)).cast<Map<String,dynamic>>();

    return parsed.map<Partner>((json) => Partner.fromJson(json)).toList();
  }

  Future<PartnerModel?> login(Partner partner) async{

    Uri url = Uri.parse("${CONSTANTE.URL_DATABASE}/partner/login");
    var data = <String, dynamic>{};
    data["username"] = partner.username;
    data["password"] = partner.password;

    final response = await http.post(url,body: data,headers: {
      "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
    });
    if(response.statusCode == 200){
      final data = json.decode(utf8.decode(response.bodyBytes));
      List<AgencyWithEmployees> agencies = [];

      for(int i = 0; i < data["agencies"].length; i++){
        List<Employee> empList = [];
        for(int j = 0; j < data["agencies"][i]["employees"].length; j++){
          empList.add(
              Employee(
                id: data["agencies"][i]["employees"][j]["id"],
                username: data["agencies"][i]["employees"][j]["username"],
                fullname: data["agencies"][i]["employees"][j]["fullname"],
                address: data["agencies"][i]["employees"][j]["address"],
                telephone: data["agencies"][i]["employees"][j]["telephone"],
                dateRegister: data["agencies"][i]["employees"][j]["dateRegister"],
                role: data["agencies"][i]["employees"][j]["role"],
                identifyAgency: data["agencies"][i]["employees"][j]["identifyAgency"],
                password: data["agencies"][i]["employees"][j]["password"]
              )
          );
        }
        agencies.add(
            AgencyWithEmployees(
                id: data["agencies"][i]["id"],
                identify: data["agencies"][i]["identify"],
                name: data["agencies"][i]["name"],
                description: data["agencies"][i]["description"],
                lieu: data["agencies"][i]["lieu"],
                account: data["agencies"][i]["account"],
                employees: empList,
            )
        );
      }
      PartnerModel partnerModel = PartnerModel(
          id: data["id"],
          username: data["username"],
          fullname: data["fullname"],
          telephone: data["telephone"],
          address: data["address"],
          dateRegister: data["dateRegister"],
          agencies: agencies,
          password: data["password"]
      );
      return partnerModel;
    }
    return null;
  }

  Future<String> addPartner(Partner partner) async{
    String responseCreated;
    Uri url = Uri.parse("${CONSTANTE.URL_DATABASE}/partner/add");
    var data = <String, dynamic>{};
    data["username"] = partner.username;
    data["fullname"] = partner.fullname;
    data["address"] = partner.address;
    data["telephone"] = partner.telephone;
    data["password"] = partner.password;

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
    Uri url = Uri.parse("${CONSTANTE.URL_DATABASE}/partner/");
    final response = await http.get(url);
    if(response.statusCode == 200){
      List<Partner> list = parseResponse(response.bodyBytes);
      return list;
    }
    return [];
  }

  Future<List<PartnerModel>> findAllPartnersWithValue(String searchValue) async{
    Uri url = Uri.parse("${CONSTANTE.URL_DATABASE}/partner?searchValue=$searchValue");
    final response = await http.get(url);
    if(response.statusCode == 200){
      final data = json.decode(utf8.decode(response.bodyBytes));
      List<PartnerModel> list = [];

      for(int i = 0; i < data.length; i++){
        //Agencies
        List<AgencyWithEmployees> agencies = [];
        for(int j = 0; j < data[i]["agencies"].length; j++){
          //Employees
          List<Employee> employees = [];
          for(int k = 0; k < data[i]["agencies"][j]["employees"].length; k++){
            if(data[i]["agencies"][j]["employees"][k]["identifyAgency"] == data[i]["agencies"][j]["identify"]){
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
          }//end Employees

          agencies.add(
              AgencyWithEmployees(
                id: data[i]["agencies"][j]["id"],
                identify: data[i]["agencies"][j]["identify"],
                name: data[i]["agencies"][j]["name"],
                description: data[i]["agencies"][j]["description"],
                lieu: data[i]["agencies"][j]["lieu"],
                account: data[i]["agencies"][j]["account"],
                employees: employees,
              )
          );
        }//End Agencies
        list.add(
            PartnerModel(
              id: data[i]["id"],
              username: data[i]["username"],
              fullname: data[i]["fullname"],
              telephone: data[i]["telephone"],
              address: data[i]["address"],
              dateRegister: data[i]["dateRegister"],
              agencies: agencies,
            )
        );
      }
      return list;
    }
    return [];
  }

  Future<List<PartnerModel>> findAllPartners() async{
    Uri url = Uri.parse("${CONSTANTE.URL_DATABASE}/partner/");
    final response = await http.get(url);
    if(response.statusCode == 200){
      final data = json.decode(utf8.decode(response.bodyBytes));

      List<PartnerModel> list = [];
      //partners
      for(int i = 0; i < data.length; i++){
        //Agencies
        List<AgencyWithEmployees> agencies = [];
        for(int j = 0; j < data[i]["agencies"].length; j++){
          //Employees
          List<Employee> employees = [];
          for(int k = 0; k < data[i]["agencies"][j]["employees"].length; k++){
            if(data[i]["agencies"][j]["employees"][k]["identifyAgency"] == data[i]["agencies"][j]["identify"]){
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
          }//end Employees

          agencies.add(
              AgencyWithEmployees(
                  id: data[i]["agencies"][j]["id"],
                  identify: data[i]["agencies"][j]["identify"],
                  name: data[i]["agencies"][j]["name"],
                  description: data[i]["agencies"][j]["description"],
                  lieu: data[i]["agencies"][j]["lieu"],
                  account: data[i]["agencies"][j]["account"],
                  employees: employees,
              )
          );
        }//End Agencies
        list.add(
            PartnerModel(
              id: data[i]["id"],
              username: data[i]["username"],
              fullname: data[i]["fullname"],
              telephone: data[i]["telephone"],
              address: data[i]["address"],
              dateRegister: data[i]["dateRegister"],
              agencies: agencies,
            )
        );
      }
      return list;
    }
    return [];
  }

}