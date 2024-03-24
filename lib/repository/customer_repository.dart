import 'dart:convert';

import 'package:darktransfert/constant.dart';
import 'package:darktransfert/model/customer.dart';
import 'package:http/http.dart' as http;

class CustomerRepository {

  Future<Customer?> findByIdentify(String identifyCustomer) async {
    Uri url = Uri.parse("http://${Constant
        .IP_ADDRESS}:8080/v1/api/transfert/customer?identify=$identifyCustomer");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var dateFormatDeposit = DateTime.parse(data["operation"]["dateDeposit"]);
      var dateFormatWithdrawal = DateTime.now();
      if(data["operation"]["dateWithdrawal"] != null){
        dateFormatWithdrawal = DateTime.parse(data["operation"]["dateWithdrawal"]);
      }else{
        dateFormatWithdrawal = DateTime.now();
      }
      Customer customer = Customer(id: data["id"],
          identify: data["identify"],
          fullname: data["fullname"],
          telephone: data["telephone"],
          address: data["address"],
          numberIdentify: data["numberIdentify"],
          mail: data["mail"],
          fullnameRecever: data["fullnameRecever"],
          phoneRecever: data["phoneRecever"],
          addressRecever: data["addressRecever"],
          mailRecever: data["mailRecever"],
          amount: data["operation"]["amount"],
          dateDeposit: "${dateFormatDeposit.day}-${dateFormatDeposit.month}-${dateFormatDeposit.year} à ${dateFormatDeposit.hour}h:${dateFormatDeposit.minute}min:${dateFormatDeposit.second}s",
          dateWithdrawal: "${dateFormatWithdrawal.day}-${dateFormatWithdrawal.month}-${dateFormatWithdrawal.year} à ${dateFormatWithdrawal.hour}h:${dateFormatWithdrawal.minute}min:${dateFormatWithdrawal.second}s",
          status: data["operation"]["status"],
          type: data["operation"]["type"]
      );
      return customer;
    } else {
      return null;
    }
  }

}