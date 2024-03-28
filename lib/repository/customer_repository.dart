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

  Future<Customer?> findFirstByOrderByOperationDateModifyDesc() async{
    Uri url = Uri.parse("http://${Constant
        .IP_ADDRESS}:8080/v1/api/transfert/customer/dateModifyDesc/1");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var dateFormatDeposit = DateTime.parse(data["operation"]["dateDeposit"]);
      var dateFormatDateModify = DateTime.now();
      var dateFormatWithdrawal = DateTime.now();
      if(data["operation"]["dateWithdrawal"] != null){
        dateFormatWithdrawal = DateTime.parse(data["operation"]["dateWithdrawal"]);
      }else{
        dateFormatWithdrawal = DateTime.now();
      }
      if(data["operation"]["dateModify"] != null){
        dateFormatDateModify = DateTime.parse(data["operation"]["dateModify"]);
      }else{
        dateFormatDateModify = DateTime.now();
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
          type: data["operation"]["type"],
          dateModify: "${dateFormatDateModify.day}-${dateFormatDateModify.month}-${dateFormatDateModify.year} à ${dateFormatDateModify.hour}h:${dateFormatDateModify.minute}min:${dateFormatDateModify.second}s"
      );
      return customer;
    } else {
      return null;
    }
  }

  Future<List<Customer>?> findAllByOrderByOperationDateModifyDesc() async{
    Uri url = Uri.parse("http://${Constant
        .IP_ADDRESS}:8080/v1/api/transfert/customer/dateModifyDesc");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<Customer> listCustomerWithOperation = data.map((customer){
        var dateFormatDeposit = DateTime.parse(customer["operation"]["dateDeposit"]);
        var dateFormatDateModify = DateTime.now();
        var dateFormatWithdrawal = DateTime.now();
        if(customer["operation"]["dateWithdrawal"] != null){
          dateFormatWithdrawal = DateTime.parse(customer["operation"]["dateWithdrawal"]);
        }else{
          dateFormatWithdrawal = DateTime.now();
        }
        if(customer["operation"]["dateModify"] != null){
          dateFormatDateModify = DateTime.parse(customer["operation"]["dateModify"]);
        }else{
          dateFormatDateModify = DateTime.now();
        }
        return Customer(
            id: customer["id"],
            identify: customer["identify"],
            fullname: customer["fullname"],
            telephone: customer["telephone"],
            address: customer["address"],
            numberIdentify: customer["numberIdentify"],
            mail: customer["mail"],
            fullnameRecever: customer["fullnameRecever"],
            phoneRecever: customer["phoneRecever"],
            addressRecever: customer["addressRecever"],
            mailRecever: customer["mailRecever"],
            amount: customer["operation"]["amount"],
            dateDeposit: "${dateFormatDeposit.day}-${dateFormatDeposit.month}-${dateFormatDeposit.year} à ${dateFormatDeposit.hour}h:${dateFormatDeposit.minute}min:${dateFormatDeposit.second}s",
            dateWithdrawal: "${dateFormatWithdrawal.day}-${dateFormatWithdrawal.month}-${dateFormatWithdrawal.year} à ${dateFormatWithdrawal.hour}h:${dateFormatWithdrawal.minute}min:${dateFormatWithdrawal.second}s",
            status: customer["operation"]["status"],
            type: customer["operation"]["type"],
            dateModify: "${dateFormatDateModify.day}-${dateFormatDateModify.month}-${dateFormatDateModify.year} à ${dateFormatDateModify.hour}h:${dateFormatDateModify.minute}min:${dateFormatDateModify.second}s"
        );
      }).toList();
      return listCustomerWithOperation;
    } else {
      return null;
    }
  }

  Future<List<Customer>?> findAllByFullnameContainingOrFullnameReceverContainingOrderByOperationDateModifyDesc(String fullname) async{
    Uri url = Uri.parse("http://${Constant
        .IP_ADDRESS}:8080/v1/api/transfert/customer/sort?fullname=$fullname&fullnameRecever=$fullname&identify=$fullname");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<Customer> listCustomerWithOperation = data.map((customer){
        var dateFormatDeposit = DateTime.parse(customer["operation"]["dateDeposit"]);
        var dateFormatDateModify = DateTime.now();
        var dateFormatWithdrawal = DateTime.now();
        if(customer["operation"]["dateWithdrawal"] != null){
          dateFormatWithdrawal = DateTime.parse(customer["operation"]["dateWithdrawal"]);
        }else{
          dateFormatWithdrawal = DateTime.now();
        }
        if(customer["operation"]["dateModify"] != null){
          dateFormatDateModify = DateTime.parse(customer["operation"]["dateModify"]);
        }else{
          dateFormatDateModify = DateTime.now();
        }
        return Customer(
            id: customer["id"],
            identify: customer["identify"],
            fullname: customer["fullname"],
            telephone: customer["telephone"],
            address: customer["address"],
            numberIdentify: customer["numberIdentify"],
            mail: customer["mail"],
            fullnameRecever: customer["fullnameRecever"],
            phoneRecever: customer["phoneRecever"],
            addressRecever: customer["addressRecever"],
            mailRecever: customer["mailRecever"],
            amount: customer["operation"]["amount"],
            dateDeposit: "${dateFormatDeposit.day}-${dateFormatDeposit.month}-${dateFormatDeposit.year} à ${dateFormatDeposit.hour}h:${dateFormatDeposit.minute}min:${dateFormatDeposit.second}s",
            dateWithdrawal: "${dateFormatWithdrawal.day}-${dateFormatWithdrawal.month}-${dateFormatWithdrawal.year} à ${dateFormatWithdrawal.hour}h:${dateFormatWithdrawal.minute}min:${dateFormatWithdrawal.second}s",
            status: customer["operation"]["status"],
            type: customer["operation"]["type"],
            dateModify: "${dateFormatDateModify.day}-${dateFormatDateModify.month}-${dateFormatDateModify.year} à ${dateFormatDateModify.hour}h:${dateFormatDateModify.minute}min:${dateFormatDateModify.second}s"
        );
      }).toList();
      return listCustomerWithOperation;
    } else {
      return null;
    }
  }

}