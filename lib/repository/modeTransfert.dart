
import 'dart:convert';

import '../constant.dart';
import '../model/modeTransfert.dart';
import 'package:http/http.dart' as http;

class ModeTransfertRepository{

  Future<List<ModeTransfert>?> findAll() async{
    Uri url = Uri.parse("${CONSTANTE.URL_DATABASE}/mode");
    final response = await http.get(url);
    if(response.statusCode == 200){
      List<dynamic> data= json.decode(utf8.decode(response.bodyBytes));
      print('data: ${data}');
      List<ModeTransfert> modes = data.map((mode) {
        print("mode: ${mode['name']}");
        return ModeTransfert(
          id: mode['id'],
          name: mode['name'],
          description: mode['description']
        );
      }).toList();
      print("modes: $modes");
      print("=========Modes==========");
      print(modes);
      print("===========modes ==============");
      return modes;
    }
    return null;
  }
}