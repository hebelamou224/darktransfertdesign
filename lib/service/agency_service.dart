import 'dart:async';

import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/model/customer.dart';
import 'package:darktransfert/repository/agency_repository.dart';

class AgencyService{


  AgencyRepository agencyRepository = AgencyRepository();

  Future<List<Agency>> findAllAgencyByPartner(String usernamePartner) async{
    List<Agency> list = await agencyRepository.findAllAgencyByPartner(usernamePartner);
    return list;
  }

  Future<String> addAgencyForPartner(Agency agency, String partnerUsername){
    return agencyRepository.addAgencyForPartner(agency, partnerUsername);
  }

  Future<Agency?> depositOnAccountAgency(String usernamePartner, String identifyAgency, double amount) async{
    return await agencyRepository.depositOnAccountAgency(usernamePartner, identifyAgency, amount);
  }

  Future<Agency?> findByIdentifyAgency(String identifyAgency) async{
    return await agencyRepository.findByIdentifyAgency(identifyAgency);
  }

  Future<Customer?> deposit(Customer customer, double amount) async{
    return await agencyRepository.deposit(customer, amount);
  }

  Future<Agency?> updateAccountAgencyAfterOperationDeposit(String identifyAgency, double amount)async{
    return await agencyRepository.updateAccountAgencyAfterOperationDeposit(identifyAgency, amount);
  }

  Future<String> withdrawal(String codeWithdrawal) async{
    return await agencyRepository.withdrawal(codeWithdrawal);
  }

  Future<Agency?> updateAccountAgencyAfterOperation(String identifyAgency, double amount, String type) async{
    return await agencyRepository.updateAccountAgencyAfterOperation(identifyAgency, amount, type);
  }

}