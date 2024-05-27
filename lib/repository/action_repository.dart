import 'dart:async';
import 'dart:convert';

import 'package:darktransfert/model/action.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

class ActionRepository{

  List<ActionsConnected> parseResponse(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ActionsConnected>((json) => ActionsConnected.fromJson(json)).toList();
  }



  Future<List<ActionsConnected>?> findAllByIdentifyAgency(String identifyAgency) async{
    Uri url = Uri.parse("${CONSTANTE.URL_DATABASE}/action?identifyAgency=$identifyAgency");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<ActionsConnected> list = parseResponse(response.body);
      return list;
    }
    return [];
  }

  Future<List<ActionsConnected>?> findActionByEmployeeId(int employeeId, String date, bool all) async{
    Uri url;
    if(all){
      url = Uri.parse("${CONSTANTE.URL_DATABASE}/action?EmployeeId=$employeeId");
    }else{
      url = Uri.parse("${CONSTANTE.URL_DATABASE}/action/$employeeId?date=$date");
    }
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<ActionsConnected> list = parseResponse(response.body);
      return list;
    }
    return [];
  }

}