import 'dart:async';

import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/model/employee.dart';
import 'package:darktransfert/model/partner.dart';
import 'package:darktransfert/service/agency_service.dart';
import 'package:darktransfert/service/employee_service.dart';
import 'package:darktransfert/service/partner_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DepositAccountAgency extends StatefulWidget {
  const DepositAccountAgency({super.key});

  @override
  State<DepositAccountAgency> createState() => _DepositAccountAgencyState();
}

class _DepositAccountAgencyState extends State<DepositAccountAgency> {
  final formKey = GlobalKey<FormState>();
  final montantDeposit = TextEditingController();
  String partnerUsername = "";
  late String identifyAgency = "";

  bool isLoading = false;
  bool isLoadingAgencyName = true;
  bool isSelectedPartner = true;
  bool showIconUsernameEmployeeExist = false;

  late Future<List<Agency>> agencies;
  late Future<List<Partner>> partners;

  PartnerService partnerService = PartnerService();
  AgencyService agencyService = AgencyService();
  EmployeeService employeeService = EmployeeService();

  @override
  void initState() {
    super.initState();
    partners = partnerService.findAllPartner();
  }

  @override
  void dispose() {
    super.dispose();
    montantDeposit.dispose();
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
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Container(
                                  child: const Text(
                                      "Error de chargement des partenaires"),
                                );
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
                                          '${partner.fullname} : ${partner.telephone}'),
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
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Container(
                                      child: const Text(
                                          "Error de chargement des agences"),
                                    );
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
                                        identifyAgency = value;
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
                              )),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              prefixIcon: TextButton(onPressed: null, child: Text("GNF", style: TextStyle(fontWeight: FontWeight.w600),)),
                              suffixIcon: TextButton(onPressed: null, child: Text("GNF", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orange),)),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)),
                              labelText: "Montant*",
                              hintText: "Entrer le montant de rechargement"),
                          controller: montantDeposit,
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
                      isLoading
                          ? const CircularProgressIndicator()
                          : submit(formKey),
                    ],
                  ))
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
            setState(() {
              isLoading = true;
            });
            //Confirmation de l'enregistrement

            showDialog(
                context: context,
                builder: (build) {
                  return AlertDialog(
                    title: const Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Alimentation"),
                      ],
                    ),
                    content: const Text("Confirmez-vous le depôt ?"),
                    actions: [
                      //Enregistrement refuser
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Annuler",
                            style: TextStyle(color: Colors.red),
                          )),

                      TextButton(
                          onPressed: () {
                            //Enregistrement accepter

                            Navigator.of(context).pop();

                            Future<Agency?> response =
                                agencyService.depositOnAccountAgency(
                                    partnerUsername,
                                    identifyAgency,
                                    double.parse(montantDeposit.text));
                            response.then((agency) {
                              if (agency != null) {
                                showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return AlertDialog(
                                        title: const Text("Alimentaion"),
                                        content: Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                              "Alimentation effectuer avec succes, le nouveau solde de cette agence est : ${agency.account} GNF"),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                montantDeposit.text = "";
                                              },
                                              child: const Text("OK"))
                                        ],
                                        icon: const Icon(
                                          Icons.check_circle,
                                          size: 40,
                                          color: Colors.green,
                                        ),
                                      );
                                    });
                                //end succes
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return AlertDialog(
                                        title: const Text("Alimentaion"),
                                        content: Container(
                                          padding: const EdgeInsets.all(10),
                                          child: const Text(
                                              "Une error s'est produite veuillez reprendre"),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("OK"))
                                        ],
                                        icon: const Icon(
                                          Icons.close,
                                          size: 40,
                                          color: Colors.red,
                                        ),
                                      );
                                    });
                              }
                            });
                          },
                          child: const Text("Confrimer")),
                    ],
                  );
                });

            setState(() {
              isLoading = false;
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
}
