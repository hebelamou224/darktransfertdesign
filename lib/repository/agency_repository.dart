import 'dart:convert';
import 'dart:typed_data';

import 'package:darktransfert/constant.dart';
import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/model/customer.dart';
import 'package:darktransfert/user_connect_info.dart';
import 'package:http/http.dart' as http;

class AgencyRepository {

  List<AgencyModel> parseResponse(Uint8List bodyBytes) {
    final parsed = json.decode(utf8.decode(bodyBytes)).cast<Map<String, dynamic>>();
    return parsed.map<AgencyModel>((json) => AgencyModel.fromJson(json)).toList();
  }

  Future<List<AgencyModel>> findAllAgencyByPartner(String usernamePartner) async {
    Uri url = Uri.parse("${CONSTANTE.URL_DATABASE}/agency/$usernamePartner");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<AgencyModel> list = parseResponse(response.bodyBytes);
      return list;
    }
    return [];
  }

  Future<String> addAgencyForPartner(AgencyModel agency,
      String partnerUserName) async {
    Uri url = Uri.parse("${CONSTANTE
        .URL_DATABASE}/partner/addAgencyForPartner/$partnerUserName");
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

  Future<AgencyModel?> depositOnAccountAgency(String usernamePartner,
      String identifyAgency, double amount) async {
    Uri url = Uri.parse("${CONSTANTE
        .URL_DATABASE}/agency/$identifyAgency?usernamePartner=$usernamePartner&amount=$amount&idSource=${UserConnected.id}");
    final response = await http.put(url);
    if (response.statusCode == 200) {
      final object= json.decode(utf8.decode(response.bodyBytes));
      AgencyModel agency = AgencyModel(
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

  Future<AgencyModel?> findByIdentifyAgency(String identifyAgency) async {
    Uri url = Uri.parse("${CONSTANTE
        .URL_DATABASE}/agency?identifyAgency=$identifyAgency");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final object= json.decode(utf8.decode(response.bodyBytes));
      AgencyModel agency = AgencyModel(
          id: object["id"],
          identify: object["identify"],
          name: object["name"],
          description: object["description"],
          lieu: object["lieu"],
          account: object["account"],
          owner: object["owner"]
      );
      return agency;
    }
    return null;
  }

  Future<Customer?> deposit(Customer customer, double amount) async {
    Uri url = Uri.parse("${CONSTANTE
        .URL_DATABASE}/operation/deposit?amount=$amount&idSource=${UserConnected.id}&identifyAgency=${UserConnected.identifyAgency}");
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
      "mailRecever": customer.mailRecever,
    };
    final response = await http.post(url, body: data, headers: {
      "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
    });
    if (response.statusCode == 200) {
      final object= json.decode(utf8.decode(response.bodyBytes));
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

  Future<Customer?> depositInternational(Customer customer, double amount) async {
    Uri url = Uri.parse("${CONSTANTE
        .URL_DATABASE}/operation?amount=$amount&idSource=${UserConnected.id}&identifyAgency=${UserConnected.identifyAgency}");
    var mode = <String, dynamic>{
      "id": customer.mode
    };
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
      "mailRecever": customer.mailRecever,
      "mode": mode
    };
    final response = await http.post(url, body: data, headers: {
      "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
    });
    if (response.statusCode == 200) {
      final object= json.decode(utf8.decode(response.bodyBytes));
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

  Future<AgencyModel?> updateAccountAgencyAfterOperationDeposit(
      String identifyAgency, double amount) async {
    Uri url = Uri.parse("${CONSTANTE
        .URL_DATABASE}/agency/update/$identifyAgency?amount=$amount");
    final response = await http.put(url);
    if (response.statusCode == 200) {
      final data= json.decode(utf8.decode(response.bodyBytes));
      AgencyModel agency = AgencyModel(id: data["id"],
          identify:  data["identify"],
          name:  data["name"],
          description:  data["description"],
          lieu:  data["lieu"],
          account:  data["account"]
      );
      return agency;
    }
    return null;
  }

  Future<String> withdrawal(String codeWithdrawal) async {
    Uri url = Uri.parse("${CONSTANTE
        .URL_DATABASE}/operation/withdrawal/$codeWithdrawal?idSource=${UserConnected.id}");
    final response = await http.put(url);
    if (response.statusCode == 200) {
      return "succes";
    }
    return "not_succes";
  }

  Future<AgencyModel?> updateAccountAgencyAfterOperation(
      String identifyAgency, double amount, String type) async {
    Uri url = Uri.parse("${CONSTANTE
        .URL_DATABASE}/agency/updateAccount/$identifyAgency?amount=$amount&&type=$type");
    final response = await http.put(url);
    if (response.statusCode == 200) {
      final data= json.decode(utf8.decode(response.bodyBytes));
      AgencyModel agency = AgencyModel(id: data["id"],
          identify:  data["identify"],
          name:  data["name"],
          description:  data["description"],
          lieu:  data["lieu"],
          account:  data["account"]
      );
      return agency;
    }
    return null;
  }

  Future<AgencyModel?> updateOnAccountMainAgencyAfterOperationWithdrawal(
      String identifyAgency, double amount) async {
    Uri url = Uri.parse("${CONSTANTE
        .URL_DATABASE}/agency/updateAccount/$identifyAgency/${UserConnected.id}/?amount=$amount");
    final response = await http.put(url);
    if (response.statusCode == 200) {
      final data= json.decode(utf8.decode(response.bodyBytes));
      AgencyModel agency = AgencyModel(id: data["id"],
          identify:  data["identify"],
          name:  data["name"],
          description:  data["description"],
          lieu:  data["lieu"],
          account:  data["account"]
      );
      return agency;
    }
    return null;
  }


}