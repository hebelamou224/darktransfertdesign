import 'dart:convert';

import 'package:darktransfert/constant.dart';
import 'package:darktransfert/model/partner.dart';
import 'package:http/http.dart' as http;


class PartnerRepository{

  static String IP_ADDRESS = "192.168.21.113";

  static List<Partner> parseResponse(String responseBody){
    final parsed = jsonDecode(responseBody).cast<Map<String,dynamic>>();

    return parsed.map<Partner>((json) => Partner.fromJson(json)).toList();

  }


  Future<String> addPartner(Partner partner) async{
    String responseCreated;
    Uri url = Uri.parse("http://${IP_ADDRESS}:8080/v1/api/transfert/partner/add");
    var data = Map<String, dynamic>();
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

}