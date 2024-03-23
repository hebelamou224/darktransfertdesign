import 'dart:async';

import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/model/partner.dart';
import 'package:darktransfert/service/agency_service.dart';
import 'package:darktransfert/service/partner_services.dart';
import 'package:flutter/material.dart';

class CreateAgency extends StatefulWidget {
  const CreateAgency({super.key});

  @override
  State<CreateAgency> createState() => _CreateAgencyState();
}

class _CreateAgencyState extends State<CreateAgency> {
  final formKey = GlobalKey<FormState>();
  final descriptionAgencyController = TextEditingController();
  final lieuAgencyController = TextEditingController();
  final addressController = TextEditingController();
  final accountAgencyController = TextEditingController();
  final agenceNameController = TextEditingController();

  String partnerUsername = "";

  bool isLoading = false;
  bool isLoadingAgencyName = true;

  late Future<List<Partner>> partners;

  PartnerService partnerService = PartnerService();
  AgencyService agencyService = AgencyService();

  @override
  void initState() {
    super.initState();
    partners = partnerService.findAllPartner();
  }

  @override
  void dispose() {
    super.dispose();
    agenceNameController.dispose();
    descriptionAgencyController.dispose();
    accountAgencyController.dispose();
    lieuAgencyController.dispose();
    addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Creation d'une agence",
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
                          "Enregistrement d'une agence pour un partenaire",
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
                                  child: const Text("Error de chargement"),
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
                                    partnerUsername = value;
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
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.maps_home_work),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)),
                              labelText: "Nom agence*",
                              hintText: "Enter le nom de l'agence"),
                          controller: agenceNameController,
                          validator: (value) => (value == null || value == "")
                              ? "Veuillez entrer le nom de l'agence"
                              : null,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          autocorrect: true,
                          cursorColor: Colors.orange,
                          minLines: 3,
                          maxLines: null,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.description),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)),
                              labelText: "Description",
                              hintText: "Description de l'agence"),
                          controller: descriptionAgencyController,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_city),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)),
                              labelText: "Lieu/Adresse*",
                              hintText: "Enter le lieu ou l'adress"),
                          controller: lieuAgencyController,
                          validator: (value) => (value == null || value == "")
                              ? "Veuillez entrer l'addresse de l'agence"
                              : null,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.euro),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)),
                              labelText: "Montant / Solde",
                              hintText: "Enter le montant initial de l'agence"),
                          controller: accountAgencyController,
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

            Agency agency = Agency(
                id: 0,
                identify: DateTime.now()
                    .toString()
                    .replaceAll("\\s", "")
                    .replaceAll("\\s", ":"),
                name: agenceNameController.text,
                description: descriptionAgencyController.text,
                lieu: lieuAgencyController.text,
                account: double.parse(accountAgencyController.text));

            //Confirmation de l'enregistrement

            showDialog(
                context: context,
                builder: (build) {
                  return AlertDialog(
                    title: const Row(
                      children: [
                        Icon(Icons.info, color: Colors.green,),
                        SizedBox(width: 8,),
                        Text("Enregistrement"),
                      ],
                    ),
                    content: const Text(
                        "Confirmez-vous l'enregistrement des informations saisie"),

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
                          onPressed: () async{
                            //===============================
                            //Enregistrement accepter

                            Navigator.of(context).pop();

                            String response = await agencyService.addAgencyForPartner(
                                agency, partnerUsername);
                            if (response == "succes") {
                              showDialog(
                                  context: context,
                                  builder: (builder) => AlertDialog(
                                    icon: const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 50,
                                    ),
                                    scrollable: true,
                                    title: Container(
                                      width: double.infinity,
                                      child: const Text("Enregistrement de l'agence"),
                                    ),
                                    content: Container(
                                      height: 70,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Text("L'agence "),
                                              Text(
                                                " ${agenceNameController.text.toUpperCase()} ",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Text(
                                              " à été creée pour le partenaire avec l'identifant: $partnerUsername")
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            agenceNameController.text = "";
                                            descriptionAgencyController.text = "";
                                            accountAgencyController.text = "";
                                            lieuAgencyController.text = "";
                                            addressController.text = "";
                                          },
                                          child: const Text("OK"))
                                    ],
                                  ));
                            } else if (response == "error") {
                              showDialog(
                                  context: context,
                                  builder: (builder) => AlertDialog(
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                    title: Container(
                                      child: const Text("Enregistrement de l'agence"),
                                    ),
                                    content: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: const Text(
                                          "Echec d'enregistrement de cette agence, veuillez recommercer l'enregistrement"),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "OK",
                                            style: TextStyle(fontSize: 20),
                                          ))
                                    ],
                                  ));
                            }

                            //===============================

                          }, child: const Text("Confrimer")),

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
