import 'dart:convert';

import 'package:darktransfert/model/employee.dart';
import 'package:darktransfert/model/user.dart';
import 'package:http/http.dart' as http;


class UserRepository{

 // String URL_GET = "https://maxed-ladybug-production.up.railway.app/users";

  static List<User> parseResponse(String responseBody){
    final parsed = jsonDecode(responseBody).cast<Map<String,dynamic>>();

    return parsed.map<User>((json) => User.fromJson(json)).toList();
   
  }

  static User parseResponseEntity(String responseBody){
    return User.fromJson(jsonDecode(responseBody) as Map<String, dynamic>);
  }


  static Future<List<User>> fetchUsers() async{
    final response = await http 
      .get(Uri.parse("http://192.168.21.113:8080/v1/api/transfert/user/"));

    if(response.statusCode == 200){
     print("Liste des utilisateurs");

    // print(response.body);
      return [];
    }
    throw Exception("Failed to load Users");

  }

  static Future<Employee?> findUser(String username, String password) async{
    final response = await http
        .get(Uri.parse("http://192.168.21.113:8080/v1/api/transfert/employee?username=$username&&password=$password"));
    if(response.statusCode == 200){
      var object = jsonDecode(response.body);
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