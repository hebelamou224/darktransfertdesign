import 'dart:async';

import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/model/customer.dart';
import 'package:darktransfert/repository/agency_repository.dart';

class AgencyService{


  AgencyRepository agencyRepository = AgencyRepository();

  Future<List<AgencyModel>> findAllAgencyByPartner(String usernamePartner) async{
    List<AgencyModel> list = await agencyRepository.findAllAgencyByPartner(usernamePartner);
    return list;
  }

  Future<String> addAgencyForPartner(AgencyModel agency, String partnerUsername){
    return agencyRepository.addAgencyForPartner(agency, partnerUsername);
  }

  Future<AgencyModel?> depositOnAccountAgency(String usernamePartner, String identifyAgency, double amount) async{
    return await agencyRepository.depositOnAccountAgency(usernamePartner, identifyAgency, amount);
  }

  Future<AgencyModel?> findByIdentifyAgency(String identifyAgency) async{
    return await agencyRepository.findByIdentifyAgency(identifyAgency);
  }

  Future<Customer?> deposit(Customer customer, double amount) async{
    return await agencyRepository.deposit(customer, amount);
  }

  Future<AgencyModel?> updateAccountAgencyAfterOperationDeposit(String identifyAgency, double amount)async{
    return await agencyRepository.updateAccountAgencyAfterOperationDeposit(identifyAgency, amount);
  }

  Future<String> withdrawal(String codeWithdrawal) async{
    return await agencyRepository.withdrawal(codeWithdrawal);
  }

  Future<AgencyModel?> updateAccountAgencyAfterOperation(String identifyAgency, double amount, String type) async{
    return await agencyRepository.updateAccountAgencyAfterOperation(identifyAgency, amount, type);
  }

  Future<AgencyModel?> updateOnAccountMainAgencyAfterOperationWithdrawal(String identifyAgency,  double amount) async{
    return await agencyRepository.updateOnAccountMainAgencyAfterOperationWithdrawal(identifyAgency, amount);
  }
}