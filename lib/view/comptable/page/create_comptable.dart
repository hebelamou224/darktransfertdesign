import 'package:darktransfert/view/agency/persone.dart';
import 'package:darktransfert/view/components/drawer_menu_comptable_area.dart';
import 'package:flutter/material.dart';

class ComptableArea extends StatefulWidget {
  const ComptableArea({super.key});

  @override
  State<ComptableArea> createState() => _ComptableAreaState();
}

class _ComptableAreaState extends State<ComptableArea> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Espace comptable",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        actions: [
          IconButton(onPressed: (){

            showDialog(context: context, builder: (builder)=>
                AlertDialog(
                  title: Text("Deconnexion"),
                  content: Text("Voullez vous deconnectez ?"),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: Text("NON",style: TextStyle(color: Colors.red),)),
                    TextButton(onPressed: (){
                      Navigator.popAndPushNamed(context, "/login");
                    }, child: Text("OUI"))
                  ],
                )
            );

            //Navigator.popAndPushNamed(context, "/login");
          }, icon: const Icon(Icons.logout))
        ],
      ),
      drawer: const NavigationDrawerComptable(),
      body: mainHomeComptableArea(),
    );
  }

  Container mainHomeComptableArea() {
    return Container(
      height: double.infinity,
      color: const Color.fromARGB(255, 241, 241, 241),
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cardOfSolde(),
              const Text(
                "Mes services",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              separetedSize(),
              myServices(),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox separetedSize() {
    return const SizedBox(
      height: 20,
    );
  }

  Container cardOfSolde() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text(
                    "500255.6655 FGN",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Dernier transaction"),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/listOfTransaction");
                },
                child: const Text(
                  "VOIR PLUS",
                  style: TextStyle(color: Colors.orange, fontSize: 10),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.orange),
                        child: const Center(
                          child: Text(
                            "AG",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Agance Moriba",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Depot",
                        style: TextStyle(fontSize: 10),
                      )
                    ],
                  )
                ],
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "555555.558 FGN",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "18h 30m",
                    style: TextStyle(fontSize: 9),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Row myServices() {
    return Row(
      children: [
        Expanded(
            child: InkWell(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.manage_history,
                      size: 40,
                      color: Colors.orange,
                    ),
                    Text("Gestion", style: TextStyle(fontSize: 11))
                  ],
                ),
              ),
              onTap: () {
                deposit();
                //Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> const Personnel()));
              },
            )),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: InkWell(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.paid,
                      size: 40,
                      color: Colors.orange,
                    ),
                    Text("Paie", style: TextStyle(fontSize: 11))
                  ],
                ),
              ),
              onTap: () {
                deposit();
              },
            )),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: InkWell(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.pin,
                      size: 40,
                      color: Colors.orange,
                    ),
                    Text("Nombre...", style: TextStyle(fontSize: 11))
                  ],
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, "/create_customer");
              },
            )),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: InkWell(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.co_present,
                      size: 40,
                      color: Colors.orange,
                    ),
                    Text(
                      "Presence",
                      style: TextStyle(fontSize: 11),
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, "/listOfTransaction");
                //Navigator.popNamed(context, "/listOfTransaction");
              },
            )),
      ],
    );
  }

  Future<dynamic> deposit() {
    final controllerAdress = TextEditingController();
    final controllerFullName = TextEditingController();
    final controllerTelephone = TextEditingController();
    final controllerAmount = TextEditingController();
    final formKeyDeposit = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (builder) => AlertDialog(
          title: const Text("Depot"),
          content: Form(
              key: formKeyDeposit,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nom complet*"),
                    controller: controllerFullName,
                    validator: (value) =>
                    value == "" ? "Le champs est requis" : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Adresse*"),
                    controller: controllerAdress,
                    validator: (value) =>
                    value == "" ? "Le champs est requis" : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Telephone*"),
                    controller: controllerTelephone,
                    validator: (value) =>
                    value == "" ? "Le champs est requis" : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Montant*"),
                    controller: controllerAmount,
                    validator: (value) =>
                    value == "" ? "Le champs est requis" : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (formKeyDeposit.currentState!.validate()) {
                            Navigator.pop(builder);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Enregistrement en cours"),
                              backgroundColor: Colors.green,
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange),
                        child: const Text("Validé")),
                  )
                ],
              )),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Annuler",
                  style: TextStyle(color: Colors.red),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Fermer"))
          ],
        ));
  }

  Row buttonRowTwo() {
    return Row(
      children: [
        Expanded(
            child: InkWell(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.euro,
                      size: 40,
                      color: Colors.orange,
                    ),
                    Text("Caisiers", style: TextStyle(fontSize: 11))
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (builder) => const Personnel()));
              },
            )),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: InkWell(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.settings,
                      size: 40,
                      color: Colors.orange,
                    ),
                    Text("Parametre", style: TextStyle(fontSize: 11))
                  ],
                ),
              ),
            )),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: InkWell(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.folder_delete,
                      size: 40,
                      color: Colors.orange,
                    ),
                    Text("Corbeilles", style: TextStyle(fontSize: 11))
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (builder) => const Personnel()));
              },
            )),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: InkWell(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.manage_history,
                      size: 40,
                      color: Colors.orange,
                    ),
                    Text(
                      "Historique",
                      style: TextStyle(fontSize: 11),
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
