import 'dart:async';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/model/partner.dart';
import 'package:darktransfert/service/agency_service.dart';
import 'package:darktransfert/service/employee_service.dart';
import 'package:darktransfert/service/partner_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kdialogs/kdialogs.dart';

import '../../../user_connect_info.dart';

class DepositAccountAgency extends StatefulWidget {
  const DepositAccountAgency({super.key});

  @override
  State<DepositAccountAgency> createState() => _DepositAccountAgencyState();
}

class _DepositAccountAgencyState extends State<DepositAccountAgency> {
  final formKey = GlobalKey<FormState>();
  final amountDeposit = TextEditingController();
  String partnerUsername = "";
  late String identifyAgency = "";

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
          "Alimentation de la caisse",
          style: TextStyle(color: Colors.black),
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
          margin: const EdgeInsets.all(50),
          child: Column(
            children: [
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: const Text(
                          "Alimentation du solde d'une agence",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: FutureBuilder(
                            future: partners,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator(color: Colors.orange,);
                              } else if (snapshot.hasError) {
                                return const Text(
                                    "Error de chargement des partenaires");
                              } else {
                                return DropdownButtonFormField(
                                  validator: (value) => (value == null ||
                                          value == "")
                                      ? "Veuillez selectionner un partenaire"
                                      : null,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    labelText: "Partenaire*",
                                    hintText: "Selectionner un partenaire*",
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2)),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      identifyAgency = "";
                                      partnerUsername = value;
                                      isSelectedPartner = false;
                                      agencies = agencyService
                                          .findAllAgencyByPartner(value);
                                    });
                                  },
                                  items: snapshot.data
                                      ?.map<DropdownMenuItem>((partner) {
                                    return DropdownMenuItem(
                                      value: partner.username,
                                      child: Text(
                                          '${partner.fullname} : ${partner.telephone != ''? partner.telephone : '' }'),
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          )),
                      isSelectedPartner
                          ? Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: const Text(
                                  "Veuillez selectionner un partenaire dabord pour afficher ses agences"))
                          : Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: FutureBuilder(
                                future: agencies,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator(color: Colors.orange,);
                                  } else if (snapshot.hasError) {
                                    return const Text(
                                        "Error de chargement des agences, veuillez reprendre");
                                  } else {
                                    return DropdownButtonFormField(
                                      validator: (value) => (value == null ||
                                              value == "")
                                          ? "Veuillez selectionner une agence"
                                          : null,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.maps_home_work),
                                        labelText: "Agence*",
                                        hintText: "Selectionner une agence*",
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.orange,
                                                width: 2)),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          identifyAgency = value;
                                        });
                                      },
                                      items: snapshot.data
                                          ?.map<DropdownMenuItem>((agency) {
                                        return DropdownMenuItem(
                                          value: agency.identify,
                                          child: Text('${agency.name} '),
                                        );
                                      }).toList(),
                                    );
                                  }
                                },
                              )
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          focusNode: focusAmount,
                          decoration: const InputDecoration(
                              prefixIcon: TextButton(onPressed: null, child: Text("GNF", style: TextStyle(fontWeight: FontWeight.w600),)),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)
                              ),
                              labelText: "Montant*",
                              hintText: "Entrer le montant de rechargement"
                          ),
                          controller: amountDeposit,
                          validator: (value) {
                            if (value == "") {
                              return "Veuillez entrer le montant de recharge";
                            }
                            int amount = int.parse(value!);
                            if (amount == 0) {
                              return "Le montant de recharge ne peut pas etre null";
                            }
                            return null;
                          },
                        ),
                      ),
                      submit(formKey),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox submit(GlobalKey<FormState> formKey) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            focusAmount.unfocus();
            //confirm for the deposit
            if(await confirm(
                context,
                title: const Row(
                  children: [
                    Icon(Icons.info, color: Colors.green,),
                    SizedBox(width: 8,),
                    Text("Confirmation"),
                  ],
                ),
                content: const Text("Confirmez-vous le depôt ?"),
                textOK: const Text("OUI"),
                textCancel: const Text("NON"),
            )){
            }else{
              return;
            }

            final close = await showKDialogWithLoadingMessage(context, message: "Veuillez patienter" );
            await agencyService.findByIdentifyAgency(UserConnected.identifyAgency)
                .then((value) async{
                  close();
              if(value!.account >= double.parse(amountDeposit.text)){
                depositOnAccountAgency();
              }else{
                showDialog(
                    context: context,
                    builder: (builder){
                      return  AlertDialog(
                        icon: const Icon(Icons.close, color: Colors.red, size: 50,),
                        title: const Text("Error"),
                        content: Text("Solde insuffissant veuillez recharger le compte de l'agence '${value.name}' pour continuer les operation, solde actuel est: ${value.account} GNF"),
                        actions: [
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const Text("OK")
                          )
                        ],
                      );
                    }
                );
              }
            }, onError: (error) async{
                close();
                showDialog(
                    context: context,
                    builder: (builder){
                      return  AlertDialog(
                        icon: const Icon(Icons.close, color: Colors.red, size: 50,),
                        title: const Text("Error"),
                        content: const Text("Error de recuperation des informations de l'agence principale, veuillez verifier votre connection et reessayer"),
                        actions: [
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const Text("OK")
                          )
                        ],
                      );
                    }
                );
            });
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        child: const Text(
          "Enregistrer",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }


  Future<void> depositOnAccountAgency() async{
    final close = await showKDialogWithLoadingMessage(context, message: "Veuillez patienter" );
    agencyService.updateAccountAgencyAfterOperation(
        UserConnected.identifyAgency,
        double.parse(amountDeposit.text),
        "WITHDRAWAL"
    ).then((mainAgency) async{
      if (mainAgency != null) {
        agencyService.depositOnAccountAgency(
            partnerUsername,
            identifyAgency,
            double.parse(amountDeposit.text)
        ).then((agency) async{
          close();
          if(await confirm(
            context,
            title: const Row(
              children: [
                Icon(Icons.check_circle, size: 40, color: Colors.green,
                ),
                Text("Alimentation"),
              ],
            ),
            content: Text("Alimentation effectuée avec succes, le nouveau solde de l'agence de '${agency!.name}' est : ${agency.account} GNF"),
            textOK: const Text("OK"),
            textCancel: const Text("Fermer"),
          )){
          }
          Navigator.pop(context);
        }, onError: (err) async{
          close();
          showDialog(
              context: context,
              builder: (builder){
                return  AlertDialog(
                  icon: const Icon(Icons.close, color: Colors.red, size: 40,),
                  title: const Text("Error"),
                  content: const Text("Une error s'est produite l'ors du depot, veuillez verifier la connectivité de votre téléphone et reprendre"),
                  actions: [
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Text("OK")
                    )
                  ],
                );
              }
          );
        });
        //end succes
      }
    }, onError: (error) async{
      close();
      showDialog(
          context: context,
          builder: (builder){
            return  AlertDialog(
              icon: const Icon(Icons.close, color: Colors.red, size: 40,),
              title: const Text("Error"),
              content: const Text("Error de mise à jour du compte de l'agence principal, veuillez reprendre l'operation"),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("OK")
                )
              ],
            );
          }
      );
    });
  }

}
