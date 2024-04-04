import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/service/agency_service.dart';
import 'package:darktransfert/view/components/animation_delay.dart';
import 'package:flutter/material.dart';
import 'package:kdialogs/kdialogs.dart';

class OperationOnMainAgency extends StatefulWidget {
  const OperationOnMainAgency({super.key});

  @override
  State<OperationOnMainAgency> createState() => _OperationOnMainAgencyState();
}

class _OperationOnMainAgencyState extends State<OperationOnMainAgency> {

  late String typeOperation;
  bool isTaping = false;
  bool deposit = true;
  bool withdrawal = true;
  final formkey = GlobalKey<FormState>();
  String identifyAgency = "";
  AgencyService agencyService = AgencyService();

  TextEditingController amountDepositController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    amountDepositController.dispose();
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
              deposit ?
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  splashColor: Colors.orange,
                  borderRadius: BorderRadius.circular(2),
                  child: Card(
                    color: Colors.orange.withOpacity(0.5),
                    elevation: (2),
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
                    setState(() {
                      typeOperation = "DEPOSIT";
                      isTaping = true;
                      withdrawal = false;
                    });
                  },
                ),
              ): Container(),
              withdrawal ?
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  splashColor: Colors.orange,
                  borderRadius: BorderRadius.circular(2),
                  child: Card(
                    color: Colors.orange.withOpacity(0.5),
                    elevation: (2),
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
                    setState(() {
                      typeOperation = "WITHDRAWAL";
                      isTaping = true;
                      deposit = false;
                    });
                  },
                ),
              ): Container(),
              isTaping ?
              DelayAnimation(
                delay: 100,
                child: Column(
                  children: [
                    Container(
                        margin: const  EdgeInsets.all(20),
                        child: const Text("Choississez la source d'aprovissionnement ?"),
                    ),
                    SizedBox(
                      height: 270,
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                        children: [
                          InkWell(
                            splashColor: Colors.orange,
                            borderRadius: BorderRadius.circular(2),
                            child: Card(
                              color: Colors.white,
                              elevation: (1),
                              child: Container(
                                child: const Image(
                                  image: AssetImage("assets/images/om.png"),
                                  fit: BoxFit.fill,
                                )
                              ),
                            ),
                            onTap: (){

                            },
                          ),
                          InkWell(
                            splashColor: Colors.orange,
                            borderRadius: BorderRadius.circular(2),
                            child: Card(
                              color: Colors.white,
                              elevation: (1),
                              child: Container(
                                //padding: const  EdgeInsets.all(20),
                                child: const Image(
                                  image: AssetImage("assets/images/mtn_money.png"),
                                  fit: BoxFit.cover,
                                )
                              ),
                            ),
                            onTap: (){

                            },
                          ),
                          InkWell(
                            splashColor: Colors.orange,
                            borderRadius: BorderRadius.circular(2),
                            child: Card(
                              color: Colors.white,
                              elevation: (1),
                              child: Container(
                                  child: const Image(
                                    image: AssetImage("assets/images/paycard.jpg"),
                                    fit: BoxFit.cover,
                                  )
                              ),
                            ),
                            onTap: (){

                            },
                          ),
                          InkWell(
                            splashColor: Colors.orange,
                            borderRadius: BorderRadius.circular(2),
                            child: Card(
                              color: Colors.white,
                              elevation: (1),
                              child: Container(
                                  child: const Image(
                                    image: AssetImage("assets/images/credit_card.jpg"),
                                    fit: BoxFit.cover,
                                  )
                              ),
                            ),
                            onTap: (){

                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: InkWell(
                        splashColor: Colors.orange,
                        borderRadius: BorderRadius.circular(2),
                        child: Card(
                          color: Colors.black54.withOpacity(0.5),
                          elevation: (2),
                          child: Container(
                            padding: const  EdgeInsets.all(20),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Autre methode de rechargement local",style: TextStyle(color: Colors.white),),
                                Icon(Icons.arrow_forward_ios, color: Colors.white,)
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          showBottomSheet();
                        },
                      ),
                    )
                  ],
                ),
              )  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  showBottomSheet(){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: const Text("Rechargement"),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close, color: Colors.red,)
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 30, right: 30, left: 30, bottom: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: amountDepositController,
                        decoration: const InputDecoration(
                            prefixIcon: TextButton(onPressed: null, child: Text("GNF")),
                            border: OutlineInputBorder(),
                            hintText: "Entrer le montant d'operation",
                            labelText: "Montant",
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange,width: 2)
                            ),
                        ),
                        validator: (value){
                          if(value == ""){
                            return "Veuillez entre le montant";
                          }else if(double.parse(value!) == 0){
                            return "Le montant ne peux pas etre null";
                          }else{
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
                      child: FutureBuilder(
                        future: agencyService.findAllAgencyByPartner("darktransfert"),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(color: Colors.orange,),
                                  Text("Veuillez partientez")
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return const Text(
                                "Error de chargement des agences, veuillez reprendre");
                          } else {
                            return DropdownButtonFormField(
                              validator: (value) => (value == null ||
                                  value == "")
                                  ? "Veuillez selectionner une agence principale"
                                  : null,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.maps_home_work),
                                labelText: "Agence principale*",
                                hintText: "Selectionner une agence principale*",
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
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width / 2,
                      child: ElevatedButton(
                        onPressed: (){Navigator.pop(context);},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Fermer"),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width / 2,
                      child: ElevatedButton(
                          onPressed: () async{
                            if(typeOperation == "DEPOSIT"){
                              depositOnMainAgency();
                            }else{
                              withdrawalOnMainAgency();
                            }

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black54,
                            side: const BorderSide(color: Colors.orange, width: 2),
                          ),
                          child: const Text("Valide")
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        }
    );
  }

  Future<void> depositOnMainAgency() async{
    if(formkey.currentState!.validate()){
      if(await confirm(
          context,
          title: const Text("Confirmation"),
          content: Text("Vous confirmer le depot(entrée) d'une somme de ${amountDepositController.text} GNF?"),
          textCancel: const Text("Annuler"),
          textOK: const Text("OUI")
      )){
      }else{
        return ;
      }
      final close = await showKDialogWithLoadingMessage(context,message: "Veuillez partienter...");
      await agencyService.depositOnAccountAgency(
          "darktransfert",
          identifyAgency,
          double.parse(amountDepositController.text)
      ).then((agency) async{
        if(agency != null){
          close();
          if(await confirm(
              context,
              title: const Row(
                children: [
                  Icon(Icons.info, color: Colors.green,),
                  Text("Rechargement"),
                ],
              ),
              content: const Text("Depôt effectué avec un succes"),
              textOK: const Text("OK"),
              textCancel: const Text("Fermer")
          )){
          }
          Navigator.pop(context);
          amountDepositController.text = "";
        }
      },onError: (value){
        close();
        showDialog(
            context: context,
            builder: (BuildContext builder){
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.error, color: Colors.red,),
                    Text("Rechargement"),
                  ],
                ),
                content: const Text("Une error s'est produit, veuillez reprendre"),
                actions: [
                  TextButton(onPressed: (){Navigator.pop(context);},
                      child: const Text("OK")
                  )
                ],
              );
            }
        );
      });
    }
  }

  Future<void> withdrawalOnMainAgency() async{
    if(formkey.currentState!.validate()){
      if(await confirm(
          context,
          title: const Text("Confirmation"),
          content: Text("Vous confirmer le retrait(sortie) de la somme de ${amountDepositController.text} GNF?"),
          textCancel: const Text("Annuler"),
          textOK: const Text("OUI")
      )){
      }else{
        return ;
      }
      final close = await showKDialogWithLoadingMessage(context,message: "Veuillez partienter...");
      await agencyService.updateOnAccountMainAgencyAfterOperationWithdrawal(
          identifyAgency,
          double.parse(amountDepositController.text)
      ).then((agency) async{
        close();
        if(await confirm(
            context,
          title: const Row(
            children: [
              Icon(Icons.info, color: Colors.green,),
              Text("Rechargement"),
            ],
          ),
          content: const Text("Retrait effectué avec un succes"),
          textOK: const Text("OK"),
          textCancel: const Text("Fermer")
        )){
        }
        Navigator.pop(context);
        amountDepositController.text = "";
      },onError: (value){
        close();
        showDialog(
            context: context,
            builder: (BuildContext builder){
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.error, color: Colors.red,),
                    Text("Rechargement"),
                  ],
                ),
                content: const Text("Error de la transaction, car imposible de mettre à jour le solde veuillez reprendre"),
                actions: [
                  TextButton(onPressed: (){Navigator.pop(context);},
                      child: const Text("OK")
                  )
                ],
              );
            }
        );
      });
    }
  }

}
