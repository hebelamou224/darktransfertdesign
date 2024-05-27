import 'dart:convert';

import 'package:darktransfert/constant.dart';
import 'package:darktransfert/model/employee.dart';
import 'package:darktransfert/model/user.dart';
import 'package:http/http.dart' as http;


class UserRepository{

  static List<User> parseResponse(String responseBody){
    final parsed = jsonDecode(responseBody).cast<Map<String,dynamic>>();

    return parsed.map<User>((json) => User.fromJson(json)).toList();
   
  }

  static User parseResponseEntity(String responseBody){
    return User.fromJson(jsonDecode(responseBody) as Map<String, dynamic>);
  }

   Future<Employee?> findUser(String username, String password) async{
    final response = await http
        .get(Uri.parse("${CONSTANTE.URL_DATABASE}/employee?username=$username&&password=$password"));
    if(response.statusCode == 200){
      final object = json.decode(utf8.decode(response.bodyBytes));
      Employee employee = Employee(
          id: object["id"],
          username: object["username"],
          fullname: object["fullname"],
          address: object["address"],
          telephone: object["telephone"],
          dateRegister: object["dateRegister"],
          role: object["role"],
          identifyAgency: object["identifyAgency"],
          password: object["password"]
      );
      return employee;
    }
    return null;

  }

}