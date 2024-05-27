import 'dart:async';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/service/agency_service.dart';
import 'package:darktransfert/service/partner_services.dart';
import 'package:darktransfert/user_connect_info.dart';
import 'package:flutter/material.dart';
import 'package:kdialogs/kdialogs.dart';

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

  String partnerUsername = UserConnected.username;

  bool isLoading = false;
  bool isLoadingAgencyName = true;

  PartnerService partnerService = PartnerService();
  AgencyService agencyService = AgencyService();

  FocusNode focusNodeName = FocusNode();
  FocusNode focusNodeDescription = FocusNode();
  FocusNode focusNodeLieu = FocusNode();
  FocusNode focusNodeAmount = FocusNode();

  @override
  void initState() {
    super.initState();
    accountAgencyController.text = "00";
  }

  @override
  void dispose() {
    super.dispose();
    agenceNameController.dispose();
    descriptionAgencyController.dispose();
    accountAgencyController.dispose();
    lieuAgencyController.dispose();
    addressController.dispose();

    focusNodeName.dispose();
    focusNodeDescription.dispose();
    focusNodeLieu.dispose();
    focusNodeAmount.dispose();
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
                          "Enregistrer une nouvelle agence pour vous",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
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
                          focusNode: focusNodeName,
                          onEditingComplete: (){
                            focusNodeDescription.nextFocus();
                          },
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
                          focusNode: focusNodeDescription,
                          onEditingComplete: (){
                            focusNodeLieu.nextFocus();
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          focusNode: focusNodeLieu,
                          onEditingComplete: (){
                            focusNodeAmount.nextFocus();
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_on_outlined),
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
                              prefixIcon: TextButton(onPressed: null, child: Text("GNF")),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)),
                              labelText: "Montant / Solde",
                              hintText: "Enter le montant initial de l'agence"),
                          controller: accountAgencyController,
                          focusNode: focusNodeAmount,
                          validator: (value){
                            if(value == ""){
                              accountAgencyController.text = "00";
                              return null;
                            }else{
                              return null;
                            }
                          },
                        ),
                      ),
                      submit(formKey),
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

            focusNodeAmount.unfocus();
            focusNodeLieu.unfocus();
            focusNodeDescription.unfocus();
            focusNodeName.unfocus();
            AgencyModel agency = AgencyModel(
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

            if(await confirm(
                context,
                title: const Row(
                  children: [
                    Icon(Icons.info, color: Colors.green,),
                    SizedBox(width: 8,),
                    Text("Confirmation"),
                  ],
                ),
                content: const Text(
                    "Confirmez-vous l'enregistrement des informations saisie"
                ),
                textOK: const Text("Confirmer",
                  style: TextStyle(color: Colors.green),
                ),
                textCancel: const Text("Anuller",
                  style: TextStyle(color: Colors.red),
                )
            )){
              final close = await showKDialogWithLoadingMessage(context, message: "Veuillez patienter" );
              await agencyService.addAgencyForPartner(
                  agency, partnerUsername).then((value) async{
                if(value == "succes"){
                  close();
                  if(await confirm(
                      context,
                      title: const Row(
                        children: [
                          Icon(Icons.info, color: Colors.green,),
                          SizedBox(width: 8,),
                          Text("Information"),
                        ],
                      ),
                      content: const Text(
                          "Enregistrement effectue avec succes"
                      ),
                      textOK: const Text("OK",
                        style: TextStyle(color: Colors.green),
                      ),
                      textCancel: const Text("Fermer",
                        style: TextStyle(color: Colors.red),
                      )

                  )) {
                  }
                  Navigator.pop(context);
                }
              }, onError: (error){
                close();
                showDialog(
                  context: context,
                  builder: (builder){
                    return const AlertDialog(
                      title: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red,),
                          SizedBox(width: 8,),
                          Text("Error"),
                        ],
                      ),
                      content: Text("Error d'enrgistrement d'agence, veuillez reprendre"),
                      actions: [
                        Text("OK")
                      ],
                    );
                  },
                );
              });
            }else{
              return;
            }
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
