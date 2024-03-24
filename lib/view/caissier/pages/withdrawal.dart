import 'dart:async';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/model/customer.dart';
import 'package:darktransfert/service/agency_service.dart';
import 'package:darktransfert/service/customer_service.dart';
import 'package:darktransfert/user_connect_info.dart';
import 'package:darktransfert/view/components/field.dart';
import 'package:flutter/material.dart';

class WithDrawalAgencyCustome extends StatefulWidget {
  const WithDrawalAgencyCustome({super.key});

  @override
  State<WithDrawalAgencyCustome> createState() =>
      _WithDrawalAgencyCustomeState();
}

class _WithDrawalAgencyCustomeState extends State<WithDrawalAgencyCustome> {
  CustomerService customerService = CustomerService();
  AgencyService agencyService = AgencyService();
  final searchController = TextEditingController();
  late Future<Customer?> customers;
  late Future<Agency?> agencyFuture;

  Customer customerInformationForWithdrawal = Customer(
      id: 0,
      identify: "",
      fullname: "",
      telephone: "",
      address: "",
      numberIdentify: '',
      mail: "",
      fullnameRecever: '',
      phoneRecever: '',
      addressRecever: '',
      mailRecever: '');

  bool showIfCodeIsExist = false;
  bool show = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    customers = customerService.findByIdentify("");
    agencyFuture =
        agencyService.findByIdentifyAgency(UserConnected.identifyAgency!);
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Customer? customerSearch;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Retrait d'argent",
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
                  child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: const Text(
                      "Entrez le code du retrait",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: TextFormField(
                        onChanged: (value) {
                          searchController.text = searchController.text.toUpperCase();
                          setState(() {
                            customerInformationForWithdrawal = Customer(
                                id: 0,
                                identify: "",
                                fullname: '',
                                telephone: '',
                                address: '',
                                numberIdentify: '',
                                mail: '',
                                fullnameRecever: '',
                                phoneRecever: '',
                                addressRecever: '',
                                mailRecever: '');
                            showIfCodeIsExist = false;
                            show = false;
                          });
                          customers = customerService
                              .findByIdentify(searchController.text);
                          customers.then((customer) {
                            setState(() {
                              customerSearch = customer;
                              customerInformationForWithdrawal = customer!;
                              show = true;
                              showIfCodeIsExist = true;
                              // print(customerSearch);
                            });
                          });
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                            prefixIcon: showIfCodeIsExist
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    customerInformationForWithdrawal = Customer(
                                        id: 0,
                                        identify: "",
                                        fullname: '',
                                        telephone: '',
                                        address: '',
                                        numberIdentify: '',
                                        mail: '',
                                        fullnameRecever: '',
                                        phoneRecever: '',
                                        addressRecever: '',
                                        mailRecever: '');
                                    showIfCodeIsExist = false;
                                    show = false;
                                  });
                                  customers = customerService.findByIdentify(searchController.text);
                                  customers.then((customer) {
                                    setState(() {
                                      customerSearch = customer;
                                      customerInformationForWithdrawal = customer!;
                                      showIfCodeIsExist = true;
                                      // print(customerSearch);
                                    });
                                  });
                                },
                                icon: const Icon(Icons.send)),
                            border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orange, width: 2)),
                            labelText: "Code*",
                            hintText: "Entrer le code*"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Veuillez le code";
                          } else {
                            return null;
                          }
                        }),
                  ),
                  /* FutureBuilder(
                          future: customers,
                          builder: (context, snashop){
                            if(snashop.connectionState == ConnectionState.waiting){
                              return const CircularProgressIndicator(color: Colors.orange,);
                            }else if(snashop.hasError){
                              return Container(child: const Text("Une error s'est produite"),);
                            }else if(snashop.hasData){
                              setState(() {
                                showIfCodeIsExist = true;
                              });
                              return Column(
                                children: [
                                  TextFormField(
                                    readOnly: true,
                                    initialValue: "${snashop.data?.fullname}",
                                  ),
                                ],
                              );
                            }
                            else{
                              return Container(child: const Text("Veuillez entrer un code correct"),);
                            }
                          }
                      ),*/
                  showIfCodeIsExist
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Informations de l'expediteur",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  initialValue:
                                      customerInformationForWithdrawal.fullname,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person_pin),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2)),
                                    labelText: "Nom complet",
                                  )),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  initialValue: customerInformationForWithdrawal
                                      .telephone,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.phone),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2)),
                                    labelText: "Telephone",
                                  )),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  initialValue:
                                      customerInformationForWithdrawal.address,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.location_on_outlined),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2)),
                                    labelText: "Addresse",
                                  )),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  initialValue: customerInformationForWithdrawal
                                      .numberIdentify,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.perm_identity),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2)),
                                    labelText: "N° pièce",
                                  )),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  initialValue:
                                      customerInformationForWithdrawal.mail,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2)),
                                    labelText: "Email",
                                  )),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              "Informations du destinateur",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  initialValue: customerInformationForWithdrawal
                                      .fullnameRecever,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person_pin),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2)),
                                    labelText: "Nom complet",
                                  )),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  initialValue: customerInformationForWithdrawal
                                      .phoneRecever,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.phone),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2)),
                                    labelText: "Telephone",
                                  )),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  initialValue: customerInformationForWithdrawal
                                      .addressRecever,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.location_on_outlined),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2)),
                                    labelText: "Addresse",
                                  )),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  initialValue: customerInformationForWithdrawal
                                      .mailRecever,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2)),
                                    labelText: "Email",
                                  )),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              "Informations de la transaction",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  initialValue: customerInformationForWithdrawal
                                      .amount
                                      .toString(),
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: TextButton(
                                        onPressed: null, child: Text("GNF")),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2)),
                                    labelText: "Montant",
                                  )),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  initialValue: customerInformationForWithdrawal
                                      .dateDeposit,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.date_range),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2)),
                                    labelText: "Date depôt",
                                  )),
                            ),
                            customerInformationForWithdrawal.status!
                                ? Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                        initialValue:
                                            customerInformationForWithdrawal
                                                .dateWithdrawal,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(Icons.date_range),
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.orange,
                                                  width: 2)),
                                          labelText: "Date retrait",
                                        )),
                                  )
                                : Container(),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  initialValue:
                                      customerInformationForWithdrawal.type,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.merge_type),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2)),
                                    labelText: "Type",
                                  )),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  initialValue:
                                      customerInformationForWithdrawal.status!
                                          ? "Cette operation est terminée"
                                          : "Retrait en entente",
                                  readOnly: true,
                                  decoration:  InputDecoration(
                                    prefixIcon: customerInformationForWithdrawal.status! ? const Icon(Icons.check_circle,color: Colors.green,) : const Icon(Icons.real_estate_agent),
                                    border: const OutlineInputBorder(),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange, width: 2)),
                                    labelText: "Status",
                                  )),
                            ),
                          ],
                        )
                      : Container(
                          margin: const EdgeInsets.all(4),
                          child: const Text(
                            "Veuillez entre un code valide pour continuer le retrait",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                  isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.orange,
                        )
                      : showIfCodeIsExist
                          ? SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                  ),
                                  onPressed: customerInformationForWithdrawal.status!
                                      ? null
                                      : () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          if (await confirm(context,
                                              title: const Text("Retrait d'argent"),
                                              content: const Text("Vous confirmez le retrait de ce argent ?"),
                                              textOK: const Text("OUI"),
                                              textCancel: const Text("NON",
                                                style: TextStyle(color: Colors.red),
                                              ))) {
                                            //withdrawal accepted
                                            agencyFuture.then((value) async {
                                              //if the amount agency is available in wallet
                                              if (value!.account >= customerInformationForWithdrawal.amount!) {
                                                //save withdrawal
                                                final response = await agencyService.withdrawal(searchController.text);
                                                if (response == "succes") {
                                                  //update account agency after withdrawal
                                                  Future<Agency?>updateAccountAgency = agencyService.updateAccountAgencyAfterOperation(
                                                      UserConnected.identifyAgency!,
                                                      customerInformationForWithdrawal.amount!,
                                                      "WITHDRAWAL"
                                                  );
                                                  updateAccountAgency.then((value) async {
                                                    if (await confirm(context,
                                                        title: const Row(
                                                          children: [
                                                            Icon(
                                                              Icons.check_circle,
                                                              color: Colors.green,
                                                            ),
                                                            Text("Information")
                                                          ],
                                                        ),
                                                        content: const Text("Retrait effectué avec succes, vous pouvez remettre l'argent au client"),
                                                        textOK: const Text("OK"))) {
                                                        setState(() {
                                                          searchController.text = "";
                                                          showIfCodeIsExist = false;
                                                        });
                                                    }
                                                  }).catchError((onError) async{
                                                    if (await confirm(context,
                                                          title: const Row(
                                                            children: [
                                                              Icon(Icons.close, color: Colors.red,),
                                                              Text("Error de retrait")
                                                            ],
                                                          ),
                                                          content: const Text("Error de mise à jour du compte de l'agence"),
                                                          textOK: const Text("OK"))
                                                      ) {}
                                                  });
                                                } else {
                                                  if (await confirm(context,
                                                      title: const Row(
                                                        children: [
                                                          Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          ),
                                                          Text("Error de retrait")
                                                        ],
                                                      ),
                                                      content: const Text("Echec de retrait, une error s'est produite veuillez reprendre"),
                                                      textOK: const Text("OK"))) {}
                                                }
                                              } else {
                                                //if the amount agency not available in wallet
                                                if (await confirm(context,
                                                    title: const Row(
                                                      children: [
                                                        Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        ),
                                                        Text("Error de retrait")
                                                      ],
                                                    ),
                                                    content: const Text(
                                                        "Solde insuffisant, veuillez recharger le solde de l'agence pour poursuivre le retrait. Merci!"),
                                                    textOK: const Text("OK"))) {}
                                              }
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }).catchError((error) async {
                                              if (await confirm(context,
                                                  title: const Row(
                                                    children: [
                                                      Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                      ),
                                                      Text("Error")
                                                    ],
                                                  ),
                                                  content: const Text(
                                                      "Error de verification du solde de l'agence, veuillez reprendre"),
                                                  textOK: const Text("OK"))) {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              }
                                            });
                                          } else {
                                            //deni withdrawal

                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        },
                                  child: const Text(
                                    "Confirmer",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            )
                          : const Text(""),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
