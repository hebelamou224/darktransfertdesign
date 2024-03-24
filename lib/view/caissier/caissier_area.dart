import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/service/agency_service.dart';
import 'package:darktransfert/user_connect_info.dart';
import 'package:darktransfert/view/agency/persone.dart';
import 'package:darktransfert/view/caissier/pages/deposit.dart';
import 'package:darktransfert/view/caissier/pages/withdrawal.dart';
import 'package:darktransfert/view/components/drawer_menu_agency.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';


class CaissierArea extends StatefulWidget {
  const CaissierArea({super.key});

  @override
  State<CaissierArea> createState() => _CaissierAreaState();
}

class _CaissierAreaState extends State<CaissierArea> {
  AgencyService agencyService = AgencyService();

  bool showAccountSolde = true;
  late Future<Agency?> agencyFuture;

  @override
  void initState() {
    super.initState();
    agencyFuture = agencyService.findByIdentifyAgency(UserConnected.identifyAgency!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Espace caissier",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (builder) => AlertDialog(
                          title: const Text("Deconnexion"),
                          content: const Text("Voullez vous deconnectez ?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "NON",
                                  style: TextStyle(color: Colors.red),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.popAndPushNamed(context, "/login");
                                },
                                child: const Text("OUI"))
                          ],
                        ));

                //Navigator.popAndPushNamed(context, "/login");
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      drawer: const NavigationDrawerAgency(),
      body: mainHomeRegistreCustomer(),
    );
  }

  Container mainHomeRegistreCustomer() {
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
              buttonRowOne(),
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
      height: 250,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Column(
        children: [
          FutureBuilder(
              future: agencyFuture,
              builder: (context, snasop){
                if(snasop.connectionState == ConnectionState.waiting){
                  return const CircularProgressIndicator(color: Colors.orange,);
                }else if(snasop.hasError){
                  return const Center(child: Text("Error de chargement", style: TextStyle(color: Colors.red),),);
                }else{
                  return Text(
                    "${snasop.data?.name.toUpperCase()}",
                    style: const  TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 20
                    ),
                  );
                }
              }
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showAccountSolde ? TextButton(
                  onPressed: () {
                    setState(() {
                      agencyFuture = agencyService.findByIdentifyAgency(UserConnected.identifyAgency!);
                      showAccountSolde = false;
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.visibility, color: Colors.orange,),
                      SizedBox(width: 10,),
                      Text(
                        "AFFICHER LE SOLDE",
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.w500),
                      )
                    ],
                  )
              ):
                  TextButton(
                      onPressed: () {
                        setState(() {
                          agencyFuture = agencyService.findByIdentifyAgency(UserConnected.identifyAgency!);
                          showAccountSolde = true;
                        });
                      },
                      child:  Row(
                        children: [
                          const Icon(Icons.visibility_off, color: Colors.orange,),
                          const SizedBox(width: 10,),
                          FutureBuilder(
                              future: agencyFuture,
                              builder: (context, snasop){
                                if(snasop.connectionState == ConnectionState.waiting){
                                  return const CircularProgressIndicator(color: Colors.orange,);
                                }else if(snasop.hasError){
                                  return const Center(child: Text("Error de chargement"),);
                                }else{
                                  return Text(
                                    "${snasop.data?.account} GNF",
                                    style: const  TextStyle(
                                        color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 18
                                    ),
                                  );
                                }
                              }
                          ),
                        ],
                      )
                  )
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

  Row buttonRowOne() {
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
                  Icons.arrow_downward,
                  size: 40,
                  color: Colors.green,
                ),
                Text("Depôt", style: TextStyle(fontSize: 11))
              ],
            ),
          ),
          onTap: () {
            //Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> const DepositAgencyCustome()));
            Navigator.of(context).push(PageAnimationTransition(
                page: const DepositAgencyCustome(),
                pageAnimationType: RightToLeftFadedTransition()
              )
            );
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
                  Icons.arrow_upward,
                  size: 40,
                  color: Colors.orange,
                ),
                Text("Retrait", style: TextStyle(fontSize: 11))
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(PageAnimationTransition(
                page: const WithDrawalAgencyCustome(),
                pageAnimationType: RightToLeftFadedTransition()
            )
            );
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
                  Icons.person_add,
                  size: 40,
                  color: Colors.orange,
                ),
                Text("Client", style: TextStyle(fontSize: 11))
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
                  Icons.list,
                  size: 40,
                  color: Colors.orange,
                ),
                Text(
                  "Liste",
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
