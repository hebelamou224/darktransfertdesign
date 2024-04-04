import 'dart:async';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/model/employee.dart';
import 'package:darktransfert/model/partner.dart';
import 'package:darktransfert/service/agency_service.dart';
import 'package:darktransfert/service/employee_service.dart';
import 'package:darktransfert/service/partner_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../user_connect_info.dart';

class DepositMainAgency extends StatefulWidget {
  const DepositMainAgency({super.key});

  @override
  State<DepositMainAgency> createState() => _DepositMainAgencyState();
}

class _DepositMainAgencyState extends State<DepositMainAgency> {
  final formKey = GlobalKey<FormState>();
  final amountDeposit = TextEditingController();
  String partnerUsername = "";
  late String identifyAgency = "";

  bool isLoading = false;
  bool isLoadingAgencyName = true;
  bool isSelectedPartner = true;
  bool showIconUsernameEmployeeExist = false;

  late Future<List<AgencyModel>> agencies;
  late Future<List<Partner>> partners;

  PartnerService partnerService = PartnerService();
  AgencyService agencyService = AgencyService();
  EmployeeService employeeService = EmployeeService();

  FocusNode focusAmount = FocusNode();

  @override
  void initState() {
    super.initState();
    partners = partnerService.findAllPartner();
  }

  @override
  void dispose() {
    super.dispose();
    amountDeposit.dispose();
    focusAmount.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Operation sur l'agence principale",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.redAccent,
            size: 30,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Text("Quelle operation voullez-vous effectué ?")
              ),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  splashColor: Colors.orange,
                  borderRadius: BorderRadius.circular(2),
                  child: Card(
                    color: Colors.orange.withOpacity(0.5),
                    elevation: (5),
                    child: Container(
                      padding: const  EdgeInsets.all(20),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Depôt vers l'agence principal",style: TextStyle(color: Colors.white),),
                          Icon(Icons.arrow_forward_ios, color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                  onTap: (){

                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  splashColor: Colors.orange,
                  borderRadius: BorderRadius.circular(2),
                  child: Card(
                    color: Colors.orange.withOpacity(0.5),
                    elevation: (5),
                    child: Container(
                      padding: const  EdgeInsets.all(20),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Retrait vers un compte exterieur",style: TextStyle(color: Colors.white),),
                          Icon(Icons.arrow_forward_ios, color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                  onTap: (){

                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
