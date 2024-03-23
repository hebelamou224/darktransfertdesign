import 'dart:convert';

import 'package:darktransfert/constant.dart';
import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/model/customer.dart';
import 'package:http/http.dart' as http;

class AgencyRepository {

  static String IP_ADDRESS = "192.168.21.113";

  List<Agency> parseResponse(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Agency>((json) => Agency.fromJson(json)).toList();
  }

  Future<List<Agency>> findAllAgencyByPartner(String usernamePartner) async {
    Uri url = Uri.parse("http://${Constant
        .IP_ADDRESS}:8080/v1/api/transfert/agency/$usernamePartner");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<Agency> list = parseResponse(response.body);
      return list;
    }
    return [];
  }

  Future<String> addAgencyForPartner(Agency agency,
      String partnerUserName) async {
    Uri url = Uri.parse("http://${Constant
        .IP_ADDRESS}:8080/v1/api/transfert/partner/addAgencyForPartner/$partnerUserName");
    var data = <String, dynamic>{
      "identify": agency.identify,
      "name": agency.name,
      "description": agency.description,
      "lieu": agency.lieu,
      "account": agency.account.toString()
    };
    final response = await http.put(url, body: data, headers: {
      "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
    });
    if (response.statusCode == 200) {
      return "succes";
    }
    return "error";
  }

  Future<Agency?> depositOnAccountAgency(String usernamePartner,
      String identifyAgency, double amount) async {
    Uri url = Uri.parse("http://${Constant
        .IP_ADDRESS}:8080/v1/api/transfert/agency/$identifyAgency?usernamePartner=$usernamePartner&&amount=$amount");
    final response = await http.put(url);
    if (response.statusCode == 200) {
      var object = jsonDecode(response.body);
      Agency agency = Agency(
          id: object["id"],
          identify: object["identify"],
          name: object["name"],
          description: object["description"],
          lieu: object["lieu"],
          account: object["account"]);
      return agency;
    }
    return null;
  }

  Future<Agency?> findByIdentifyAgency(String identifyAgency) async {
    Uri url = Uri.parse("http://${Constant
        .IP_ADDRESS}:8080/v1/api/transfert/agency?identifyAgency=$identifyAgency");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var object = jsonDecode(response.body);
      Agency agency = Agency(
          id: object["id"],
          identify: object["identify"],
          name: object["name"],
          description: object["description"],
          lieu: object["lieu"],
          account: object["account"]
      );
      return agency;
    }
    return null;
  }

  Future<Customer?> deposit(Customer customer, double amount) async {
    Uri url = Uri.parse("http://${Constant
        .IP_ADDRESS}:8080/v1/api/transfert/operation/deposit?amount=$amount");
    var data = <String, dynamic>{
      "identify": customer.identify,
      "fullname": customer.fullname,
      "telephone": customer.telephone,
      "address": customer.address,
      "numberIdentify": customer.numberIdentify,
      "mail": customer.mail,
      "fullnameRecever": customer.fullnameRecever,
      "phoneRecever": customer.phoneRecever,
      "addressRecever": customer.addressRecever,
      "mailRecever": customer.mailRecever
    };
    final response = await http.post(url, body: data, headers: {
      "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
    });
    if (response.statusCode == 200) {
      var object = jsonDecode(response.body);
      Customer customer = Customer(id: object["id"],
          identify: object["identify"],
          fullname: object["fullname"],
          telephone: object["telephone"],
          address: object["address"],
          numberIdentify: object["numberIdentify"],
          mail: object["mail"],
          fullnameRecever: object["fullnameRecever"],
          phoneRecever: object["phoneRecever"],
          addressRecever: object["addressRecever"],
          mailRecever: object["mailRecever"]
      );
      return customer;
    }
    return null;
  }

  Future<Agency?> updateAccountAgencyAfterOperationDeposit(
      String identifyAgency, double amount) async {
    Uri url = Uri.parse("http://${Constant
        .IP_ADDRESS}:8080/v1/api/transfert/agency/update/$identifyAgency?amount=$amount");
    final response = await http.put(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      Agency agency = Agency(id: data["id"],
          identify:  data["identify"],
          name:  data["name"],
          description:  data["description"],
          lieu:  data["lieu"],
          account:  data["account"]
      );
      print(agency);
      return agency;
    }
    return null;
  }
}