import 'dart:async';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/model/employee.dart';
import 'package:darktransfert/model/partner.dart';
import 'package:darktransfert/model/partners_get.dart';
import 'package:darktransfert/repository/partner_repository.dart';
import 'package:darktransfert/service/agency_service.dart';
import 'package:darktransfert/service/employee_service.dart';
import 'package:darktransfert/service/partner_services.dart';
import 'package:darktransfert/user_connect_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kdialogs/kdialogs.dart';

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

  FocusNode focusFirstnameEmployeeController = FocusNode();
  FocusNode focusLastnameEmployeeController = FocusNode();
  FocusNode focusAddressController= FocusNode();
  FocusNode focusTelephoneController = FocusNode();
  FocusNode focusUsernameEmployeeController = FocusNode();

  String partnerUsername = UserConnected.username;
  late String identifyAgency = "";
  String? role;

  bool isLoadingAgencyName = true;
  bool showIconUsernameEmployeeExist = false;

  late Future<List<AgencyModel>> agencies;

  PartnerService partnerService = PartnerService();
  AgencyService agencyService = AgencyService();
  EmployeeService employeeService = EmployeeService();


  @override
  void initState() {
    super.initState();
    agencies = agencyService.findAllAgencyByPartner(UserConnected.username);
  }

  @override
  void dispose() {
    super.dispose();
    usernameEmployeeController.dispose();
    firstnameEmployeeController.dispose();
    lastnameEmployeeController.dispose();
    telephoneController.dispose();
    addressController.dispose();
    focusAddressController.dispose();
    focusTelephoneController.dispose();
    focusFirstnameEmployeeController.dispose();
    focusLastnameEmployeeController.dispose();
    focusUsernameEmployeeController.dispose();
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
                          "Enregistrer un employee pour votre agence",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: FutureBuilder(
                            future: agencies,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator(color: Colors.orange,);
                              } else if (snapshot.hasError) {
                                return const Text(
                                    "Error de chargement des agences");
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
                              suffixIcon: showIconUsernameEmployeeExist ? IconButton(icon: const Icon(Icons.info_outline,color: Colors.red,),
                                onPressed: (){
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
                          focusNode: focusUsernameEmployeeController,
                          onEditingComplete: (){
                            focusFirstnameEmployeeController.nextFocus();
                          },
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
                          focusNode: focusFirstnameEmployeeController,
                          onEditingComplete: (){
                            focusLastnameEmployeeController.nextFocus();
                          },
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
                          focusNode: focusLastnameEmployeeController,
                          onEditingComplete: (){
                            focusAddressController.nextFocus();
                          },
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
                          focusNode: focusAddressController,
                          onEditingComplete: (){
                            focusTelephoneController.nextFocus();
                          },
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
                          focusNode: focusTelephoneController,
                          onEditingComplete: (){
                            focusTelephoneController.unfocus();
                          },
                          validator: (value) =>
                          (value == null || value == "")
                              ? "Veuillez entrer le numero telephone"
                              : null,
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: DropdownButtonFormField(
                            value: role,
                            validator: (value) =>
                            (value == null)
                                ? "Veuillez selectionner une fonction"
                                : null,
                            onChanged: (valueFonction){
                              setState(() {
                                role = valueFonction!;
                              });
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
                                value: "CAISSIER",
                                child: Text("CAISSIER"),
                              ),
                              DropdownMenuItem(
                                value: "COMPTABLE",
                                child: Text("COMPTABLE"),
                              )
                            ],
                          )
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
            focusAddressController.unfocus();
            focusTelephoneController.unfocus();
            focusFirstnameEmployeeController.unfocus();
            focusLastnameEmployeeController.unfocus();
            focusUsernameEmployeeController.unfocus();

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
                    "Confirmez-vous l'enregistrement des informations saisies"
                ),
                textOK: const Text("Confirmer",
                  style: TextStyle(color: Colors.green),
                ),
                textCancel: const Text("Anuller",
                  style: TextStyle(color: Colors.red),
                )
            )){
            }else{
              return;
            }

            Employee employee = Employee(id: 0,
                username: usernameEmployeeController.text,
                fullname: "${firstnameEmployeeController.text} ${lastnameEmployeeController.text}",
                address: addressController.text,
                telephone: telephoneController.text,
                dateRegister: DateTime.now().toString(),
                role: role!,
                identifyAgency: identifyAgency,
                password: ""
            );

            //Confirmation de l'enregistrement
            final close = await showKDialogWithLoadingMessage(context, message: "Veuillez patienter" );
            await employeeService.addEmployeeForAnAgency(employee, partnerUsername, identifyAgency)
                .then((value) async{
              close();
              if(value == "succes"){
                if(await confirm(
                    context,
                    title: const Row(
                      children: [
                        Icon(Icons.info, color: Colors.green,),
                        SizedBox(width: 8,),
                        Text("Information"),
                      ],
                    ),
                    content: const Text("L'enregistrement du personnnel effectué avec succes"),
                    textOK: const Text("OK"),
                    textCancel: const Text("")
                )){
                }
                Navigator.pop(context);
              }else{
                showDialog(
                    context: context,
                    builder: (builder){
                      return  AlertDialog(
                        icon: const Icon(Icons.close, color: Colors.red, size: 40,),
                        title: const Text("Error"),
                        content: const Text("Echec d'enregistrement du personnel, veuillez penser à modifier le nom d'utilisateur et reesayer"),
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
            }, onError: (error){
              close();
              showDialog(
                  context: context,
                  builder: (builder){
                    return  AlertDialog(
                      icon: const Icon(Icons.close, color: Colors.red, size: 50,),
                      title: const Text("Error"),
                      content: const Text("Une erreur s'est produite, veuillez reprendre. Verifier aussi la connectivité de votre telephone à la base de donnée"),
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
}
