import 'dart:ui';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/model/customer.dart';
import 'package:darktransfert/service/agency_service.dart';
import 'package:darktransfert/user_connect_info.dart';
import 'package:flutter/material.dart';

class DepositAgencyCustome extends StatefulWidget {
  const DepositAgencyCustome({super.key});

  @override
  State<DepositAgencyCustome> createState() => _DepositAgencyCustomeState();
}

class _DepositAgencyCustomeState extends State<DepositAgencyCustome> {

  final formKey = GlobalKey<FormState>();
  final fullnameSender = TextEditingController();
  final phoneSender = TextEditingController();
  final addressSender = TextEditingController();
  final numberIdentifySender = TextEditingController();
  final mailSender = TextEditingController();
  final fullnameRecever = TextEditingController();
  final mailRecever = TextEditingController();
  final addressRecever = TextEditingController();
  final phoneRecerver = TextEditingController();
  final amount = TextEditingController();
  AgencyService agencyService = AgencyService();
  bool isLoadingDeposit = false;
  bool back = false;
  int currentPage = 0;
  PageController pageController = PageController(
      initialPage: 0, viewportFraction: 0.9);
  List<Widget> pages = [
    const DepositInformationPerson(),
    const WithdrawalInformationPerson()
  ];

  @override
  void dispose() {
    super.dispose();
    fullnameSender.dispose();
    phoneSender.dispose();
    addressSender.dispose();
    mailSender.dispose();
    fullnameRecever.dispose();
    mailRecever.dispose();
    phoneRecerver.dispose();
    addressRecever.dispose();
    amount.dispose();
    numberIdentifySender.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pagesNavigation = [
      depositInformation(),
      withdrawalInformation(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Depot d'argent", style: TextStyle(color: Colors.black),),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.close, color: Colors.redAccent, size: 30,),),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 0.9,
                child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    itemCount: pagesNavigation.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return pagesNavigation[index % pagesNavigation.length];
                    }
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () {
                    pageController.animateToPage(0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn
                    );
                  }, child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: (currentPage == 0) ? BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)
                    ) : null,
                    child: Text("Information expediteur", style: TextStyle(
                        color: (currentPage == 0) ? Colors.orange : Colors
                            .black54
                    ),),
                  )),
                  TextButton(onPressed: () {
                    pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn
                    );
                  }, child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: (currentPage == 1) ? BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)
                    ) : null,
                    child: Text("Information destinateur", style: TextStyle(
                        color: (currentPage == 1) ? Colors.orange : Colors
                            .black54
                    ),),
                  ))
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: TextFormField(
                          controller: amount,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              prefixIcon: TextButton(onPressed: null,
                                  child: Text("GNF", style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),)),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 2)),
                              labelText: "Montant*",
                              hintText: "Entrer le montant* Ex: 500000 GNF"),
                            validator: (value) {
                            if (value!.isNotEmpty) {
                              double amount = double.parse(value);
                              if (amount == 0) {
                                return "Le montant de transaction ne peux pas etre null";
                              } else {
                                return null;
                              }
                            } else {
                              return "Veuillez entrer le montant de transaction";
                            }
                          }
                      ),
                    ),
                    isLoadingDeposit? const CircularProgressIndicator(color: Colors.orange,):
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                isLoadingDeposit = true;
                              });
                              Customer customer = Customer(id: 0,
                                  identify: "",
                                  fullname: fullnameSender.text,
                                  telephone: phoneSender.text,
                                  address: addressSender.text,
                                  numberIdentify: numberIdentifySender.text,
                                  mail: mailSender.text,
                                  fullnameRecever: fullnameRecever.text,
                                  phoneRecever: phoneRecerver.text,
                                  addressRecever: addressRecever.text,
                                  mailRecever: mailRecever.text
                              );
                              double amountDeposit = double.parse(amount.text);

                              if(await confirm(
                                  context,
                                title: const Text("Confirmation"),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Informations de l'expediteur: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                    Row(
                                      children: [
                                        const Text("NOM COMPLET : ",style: TextStyle(fontWeight: FontWeight.w500),),
                                        Text(customer.fullname)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("TELEPHONE : ",style: TextStyle(fontWeight: FontWeight.w500),),
                                        Text(customer.telephone),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("ADDRESSE : ",style: TextStyle(fontWeight: FontWeight.w500),),
                                        Text(customer.address),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("N°PIECE : ",style: TextStyle(fontWeight: FontWeight.w500),),
                                        Text(customer.numberIdentify),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("EMAIL : ",style: TextStyle(fontWeight: FontWeight.w500),),
                                        Text(customer.mail),
                                      ],
                                    ),
                                    const SizedBox(height: 8,),
                                    const Text("Informations du destinateur: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                    Row(
                                      children: [
                                        const Text("NOM COMPLET : ",style: TextStyle(fontWeight: FontWeight.w500),),
                                        Text(customer.fullnameRecever),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("ADDRESSE : ",style: TextStyle(fontWeight: FontWeight.w500),),
                                        Text(customer.addressRecever),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("EMAIL : ",style: TextStyle(fontWeight: FontWeight.w500),),
                                        Text(customer.mailRecever),
                                      ],
                                    ),
                                    const SizedBox(height: 8,),
                                    Row(
                                      children: [
                                        const Text("MONTANT : ",style: TextStyle(fontWeight: FontWeight.w600),),
                                        Text("$amountDeposit GNF"),
                                      ],
                                    ),
                                  ],
                                ),
                                textOK: const Text("OUI"),
                                textCancel: const Text("NON", style: TextStyle(color: Colors.red),),
                              )){
                                //Continous the saved deposit operation
                              }else{
                                setState(() {
                                  isLoadingDeposit = false;
                                });
                                return;
                              }

                              //sending request saved deposit operation
                              Future<Customer?> response = agencyService.deposit(customer, amountDeposit);
                              response.then((customer){
                                if(customer != null){
                                  //Update account agency after deposit
                                  Future<Agency?> agenceFuture = agencyService.updateAccountAgencyAfterOperationDeposit(UserConnected.identifyAgency!, amountDeposit);
                                  agenceFuture.then((agency) async {
                                    if(agency != null){
                                      //Confirm for the print recu after operation deposit
                                      if(await confirm(
                                          context,
                                        title: const Row(children: [
                                          Icon(Icons.check_circle, color: Colors.green,),
                                          Text("Confirmation")
                                          ],),
                                        content: const Text("Depot effectué avec succes, souhaitez-vous imprimer le reçu maintenant ?"),
                                        textOK: const Text("OUI"),
                                        textCancel: const Text("NON", style: TextStyle(color: Colors.red),)
                                      )){
                                        //Print here
                                        setState(() {
                                          back = true;
                                        });
                                      }else{
                                        setState(() {
                                          back = true;
                                        });
                                      }
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Echec de mise a jour du compte de l'agence",style:
                                          TextStyle(color: Colors.white)),
                                            backgroundColor: Colors.red,)
                                      );
                                    }
                                  });
                                  //Go to home caissier area
                                  back ? Navigator.pop(context) : null;
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Echec d'enregistrement du depot",style:
                                      TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.red,)
                                  );
                                }
                              });
                              setState(() {
                                isLoadingDeposit = false;
                              });
                            }
                          },
                          child: const Text(
                            "Valider la transaction", style: TextStyle(
                              color: Colors.white),)
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget withdrawalInformation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Text("Entrer les informations du destinateur",
                  style: TextStyle(fontSize: 20),),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: fullnameRecever,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange, width: 2)),
                      labelText: "Nom complet*",
                      hintText: "Entrer le nom complet*"),
                  validator: (value) =>
                  (value == null || value == "")
                      ? "Veuillez entrer le nom complet"
                      : null,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: phoneRecerver,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange, width: 2)),
                      labelText: "Telephone*",
                      hintText: "Entrer le numero de telephone*"),
                  validator: (value) =>
                  (value == null || value == "")
                      ? "Veuillez entrer le numero telephone"
                      : null,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: addressRecever,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange, width: 2)),
                      labelText: "Addresse",
                      hintText: "Entrer le numero de telephone*"),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: mailRecever,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.mail_outline),
                      suffixIcon: IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text(
                                    "Entrer une addresse email du destinateur pour qu'il soit informé sur l'etat de la transaction par mail"))
                            );
                          },
                          icon: const Icon(Icons.info_outlined, size: 15,
                            color: Colors.orange,)
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange, width: 2)),
                      labelText: "Email",
                      hintText: "Entrer une adresse mail valide"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget depositInformation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: const Text("Entrer les informations du l'expediteur",
                  style: TextStyle(fontSize: 20),),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: fullnameSender,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange, width: 2)),
                      labelText: "Nom complet*",
                      hintText: "Entrer le nom complet*"),
                  validator: (value) {
                    if(value!.isEmpty){
                      return "Veuillez entrer le nom complete";
                    }else if(value.length < 4){
                      return "Le nom complet doit etre aumoins 4 caracteres";
                    }else{
                      return null;
                    }
                  }

                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: phoneSender,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange, width: 2)),
                      labelText: "Telephone*",
                      hintText: "Entrer le numero de telephone*"),
                  validator: (value) =>
                  (value == null || value == "")
                      ? "Veuillez entrer le numero telephone"
                      : null,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: addressSender,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange, width: 2)),
                      labelText: "Addresse",
                      hintText: "Entrer le numero de telephone*"),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: numberIdentifySender,
                  onChanged: (value){
                    numberIdentifySender.text = value.toUpperCase();
                  },
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.perm_identity),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange, width: 2)),
                      labelText: "N° pièce",
                      hintText: "Entrer le numero du pièce d'identité"),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: mailSender,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.mail_outline),
                      suffixIcon: IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text(
                                    "Entrer une addresse email pour etre informer sur l'etat de votre transaction par mail"))
                            );
                          },
                          icon: const Icon(Icons.info_outlined, size: 15,
                            color: Colors.orange,)
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange, width: 2)),
                      labelText: "Email",
                      hintText: "Entrer une adresse mail valide"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}


class DepositInformationPerson extends StatefulWidget {

  const DepositInformationPerson({super.key});

  @override
  State<DepositInformationPerson> createState() =>
      _DepositInformationPersonState();
}

class _DepositInformationPersonState extends State<DepositInformationPerson> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Form(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Text("Entrer les informations du l'expediteur",
                      style: TextStyle(fontSize: 20),),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orange, width: 2)),
                          labelText: "Nom complet*",
                          hintText: "Entrer le nom complet*"),
                      validator: (value) =>
                      (value == null || value == "")
                          ? "Veuillez entrer le nom complet"
                          : null,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orange, width: 2)),
                          labelText: "Telephone*",
                          hintText: "Entrer le numero de telephone*"),
                      validator: (value) =>
                      (value == null || value == "")
                          ? "Veuillez entrer le numero telephone"
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
                          labelText: "Addresse",
                          hintText: "Entrer le numero de telephone*"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.perm_identity),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orange, width: 2)),
                          labelText: "N° pièce",
                          hintText: "Entrer le numero du pièce d'identité"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail_outline),
                          suffixIcon: IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text(
                                        "Entrer une addresse email pour etre informer sur l'etat de votre transaction par mail"))
                                );
                              },
                              icon: const Icon(Icons.info_outlined, size: 15,
                                color: Colors.orange,)
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orange, width: 2)),
                          labelText: "Email",
                          hintText: "Entrer une adresse mail valide"),
                    ),
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}


class WithdrawalInformationPerson extends StatefulWidget {
  const WithdrawalInformationPerson({super.key});

  @override
  State<WithdrawalInformationPerson> createState() =>
      _WithdrawalInformationPersonState();
}

class _WithdrawalInformationPersonState
    extends State<WithdrawalInformationPerson> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Form(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: const Text("Entrer les informations du destinateur",
                      style: TextStyle(fontSize: 20),),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orange, width: 2)),
                          labelText: "Nom complet*",
                          hintText: "Entrer le nom complet*"),
                      validator: (value) =>
                      (value == null || value == "")
                          ? "Veuillez entrer le nom complet"
                          : null,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orange, width: 2)),
                          labelText: "Telephone*",
                          hintText: "Entrer le numero de telephone*"),
                      validator: (value) =>
                      (value == null || value == "")
                          ? "Veuillez entrer le numero telephone"
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
                          labelText: "Addresse",
                          hintText: "Entrer le numero de telephone*"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail_outline),
                          suffixIcon: IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text(
                                        "Entrer une addresse email du destinateur pour qu'il soit informé sur l'etat de la transaction par mail"))
                                );
                              },
                              icon: const Icon(Icons.info_outlined, size: 15,
                                color: Colors.orange,)
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orange, width: 2)),
                          labelText: "Email",
                          hintText: "Entrer une adresse mail valide"),
                    ),
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}


