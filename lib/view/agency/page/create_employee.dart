import 'dart:async';

import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/model/employee.dart';
import 'package:darktransfert/model/partner.dart';
import 'package:darktransfert/service/agency_service.dart';
import 'package:darktransfert/service/employee_service.dart';
import 'package:darktransfert/service/partner_services.dart';
import 'package:flutter/material.dart';

class CreateEmployee extends StatefulWidget {
  const CreateEmployee({super.key});

  @override
  State<CreateEmployee> createState() => _CreateEmployeeState();
}

class _CreateEmployeeState extends State<CreateEmployee> {
  final formKey = GlobalKey<FormState>();
  final firstnameEmployeeController = TextEditingController();
  final lastnameEmployeeController = TextEditingController();
  final addressController = TextEditingController();
  final telephoneController = TextEditingController();
  final usernameEmployeeController = TextEditingController();

  String partnerUsername = "";
  late String identifyAgency = "";
  late String fonct = "";

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
    usernameEmployeeController.dispose();
    firstnameEmployeeController.dispose();
    lastnameEmployeeController.dispose();
    telephoneController.dispose();
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
          "Creation d'un personnel",
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
                          "Enregistrement d'un employe pour une agence",
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
                                  validator: (value) =>
                                  (value == null ||
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
                                      agencies =
                                          agencyService.findAllAgencyByPartner(
                                              value);
                                    });
                                  },
                                  items: snapshot.data
                                      ?.map<DropdownMenuItem>((partner) {
                                    return DropdownMenuItem(
                                      value: partner.username,
                                      child: Text(
                                          '${partner.fullname} : ${partner
                                              .telephone}'),
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
                          :
                      Container(
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
                                  validator: (value) =>
                                  (value == null ||
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
                                            color: Colors.orange, width: 2)),
                                  ),
                                  onChanged: (value) {
                                    identifyAgency = value;
                                  },
                                  items: snapshot.data
                                      ?.map<DropdownMenuItem>((agence) {
                                    return DropdownMenuItem(
                                      value: agence.identify,
                                      child: Text(
                                          '${agence.name} '),
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          )),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          decoration:  InputDecoration(
                              prefixIcon: showIconUsernameEmployeeExist ?
                                const Icon(Icons.close,color: Colors.red,):
                                const Icon(Icons.maps_home_work),
                              suffixIcon: showIconUsernameEmployeeExist ? IconButton(icon: Icon(Icons.info_outline), onPressed: (){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Ce nom d'utilisateur existe déjà"),
                                  backgroundColor: Colors.red,
                                ));
                              },) : null,
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)),
                              labelText: "Nom d'utilisateur*",
                              hintText: "Enter le nom d'utilisateur"),
                          controller: usernameEmployeeController,
                          validator: (value) =>
                          (value == null || value == "")
                              ? "Veuillez entrer le nom d'utilisateur"
                              : null,
                          onChanged: (value){
                            Future<String> response = employeeService.findByUsername(value);
                            response.then((value){
                              if(value == "exist"){
                                setState(() {
                                  showIconUsernameEmployeeExist = true;
                                });
                              }else{
                                setState(() {
                                  showIconUsernameEmployeeExist = false;
                                });
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person_pin),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)),
                              labelText: "Prenom *",
                              hintText: "Enter le nom prenom"),
                          controller: firstnameEmployeeController,
                          validator: (value) =>
                          (value == null || value == "")
                              ? "Veuillez entrer le prenom"
                              : null,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)),
                              labelText: "Nom *",
                              hintText: "Enter le nom nom"),
                          controller: lastnameEmployeeController,
                          validator: (value) =>
                          (value == null || value == "")
                              ? "Veuillez entrer le nom"
                              : null,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_on_outlined),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)),
                              labelText: "Addresse ",
                              hintText: "Enter le nom l'addresse"),
                          controller: addressController,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)),
                              labelText: "Telephone *",
                              hintText: "Enter le nom numero telephone"),
                          controller: telephoneController,
                          validator: (value) =>
                          (value == null || value == "")
                              ? "Veuillez entrer le numero telephone"
                              : null,
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: DropdownButtonFormField(

                            value: null,
                            validator: (value) =>
                            (value == null)
                                ? "Veuillez selectionner une fonction"
                                : null,
                            onChanged: (valueFonction){
                              fonct = valueFonction!;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.merge_type_outlined),
                              labelText: "Fonction",
                              hintText: "Selectionner une fonction / role",
                              border:  OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: "ADMIN",
                                child: Text("ADMIN"),
                              ),
                              DropdownMenuItem(
                                value: "COMPTABLE",
                                child: Text("COMPTABLE"),
                              ),
                              DropdownMenuItem(
                                value: "CAISSIER",
                                child: Text("CAISSIER"),
                              ),
                            ],
                          )
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


            Employee employee = Employee(id: 0,
                username: usernameEmployeeController.text,
                fullname: "${firstnameEmployeeController.text} ${lastnameEmployeeController.text}",
                address: addressController.text,
                telephone: telephoneController.text,
                dateRegister: DateTime.now().toString(),
                role: fonct,
                identifyAgency: identifyAgency,
                password: ""
            );

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
                          onPressed: () async {
                            //===============================
                            //Enregistrement accepter

                            Navigator.of(context).pop();

                            String response = await employeeService.addEmployeeForAnAgency(employee, partnerUsername, identifyAgency);
                            if (response == "succes") {
                              showDialog(
                                  context: context,
                                  builder: (builder) =>
                                      AlertDialog(
                                        icon: const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 50,
                                        ),
                                        scrollable: true,
                                        title: Container(
                                          width: double.infinity,
                                          child: const Text(
                                              "Enregistrement employée"),
                                        ),
                                        content: Container(
                                          height: 70,
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Text("Employée "),
                                                  Text(
                                                    " ${firstnameEmployeeController
                                                        .text.toUpperCase()}  ${lastnameEmployeeController.text.toUpperCase()}",
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold),
                                                  ),
                                                ],
                                              ),
                                              const Text(" à été ajouter avec succes dans l'agence avec sucess")
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                usernameEmployeeController
                                                    .text = "";
                                                firstnameEmployeeController
                                                    .text = "";
                                                lastnameEmployeeController.text =
                                                "";
                                                telephoneController.text = "";
                                                addressController.text = "";
                                              },
                                              child: const Text("OK"))
                                        ],
                                      ));
                            } else if (response == "error") {
                              showDialog(
                                  context: context,
                                  builder: (builder) =>
                                      AlertDialog(
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                                        title: Container(
                                          child: const Text(
                                              "Enregistrement employée"),
                                        ),
                                        content: Container(
                                          padding: const EdgeInsets.all(10),
                                          child: const Text(
                                              "Echec d'enregistrement de cet employee pour cette agence, veuillez reprendre la procedure. Pensé à changer le nom d'utilisateur aussi"),
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
