import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/view/agency/persone.dart';
import 'package:darktransfert/view/components/drawer_menu_comptable_area.dart';
import 'package:darktransfert/view/comptable/page/rechargement.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../model/action.dart';
import '../../model/agency.dart';
import '../../service/action_service.dart';
import '../../service/agency_service.dart';
import '../../service/customer_service.dart';
import '../../user_connect_info.dart';
import '../agency/page/deposit_account_agency.dart';
import '../caissier/pages/action.dart';
import '../components/animation_delay.dart';
import '../login.dart';

class ComptableArea extends StatefulWidget {
  const ComptableArea({super.key});

  @override
  State<ComptableArea> createState() => _ComptableAreaState();
}

class _ComptableAreaState extends State<ComptableArea> {

  late Future<AgencyModel?> agencyFuture;
  AgencyService agencyService = AgencyService();
  CustomerService customerService = CustomerService();

  ActionService actionService = ActionService();
  late Future<List<ActionsConnected>?> lastActionToday ;

  bool showAccountSolde = true;

  @override
  void initState() {
    super.initState();
    //Get information for the agency when open the app
    agencyFuture = agencyService.findByIdentifyAgency(UserConnected.identifyAgency);
    //Get last action
    lastActionToday = actionService.findActionByEmployeeId(UserConnected.id, "", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.withOpacity(0.5),
        title: const Text(
          "Espace comptable",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: (){
                setState(() {
                  agencyFuture = agencyService.findByIdentifyAgency(UserConnected.identifyAgency);
                  lastActionToday = actionService.findActionByEmployeeId(UserConnected.id, "", true);
                });
              },
              icon: const Icon(Icons.refresh_rounded)
          ),
          IconButton(
                onPressed: ()async{
                  if(await confirm(
                      context,
                      title: const Text("Deconnexion"),
                      content: const  Text("Voullez-vous vous deconnectez ?"),
                      textOK: const Text("OUI"),
                      textCancel: const Text("NON")
                  )){
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginPage())
                    );
                  }
              },
              icon: const Icon(Icons.logout)
          )
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
              const DelayTopAnimation(
                delay: 1000,
                child: Text(
                  "Mes services",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              separetedSize(),
              myServices(),
              separetedSize(),
              //buttonRowTwo()
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

  DelayTopAnimation cardOfSolde() {
    return DelayTopAnimation(
      delay: 1000,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 15),
        width: double.infinity,
        height: 270,
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
                  }else if(!snasop.hasData){
                    return const Center(child: Text("Aucune information disponible", style: TextStyle(color: Colors.red),),);
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
                        agencyFuture = agencyService.findByIdentifyAgency(UserConnected.identifyAgency);
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
                        agencyFuture = agencyService.findByIdentifyAgency(UserConnected.identifyAgency);
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
                    String day = DateTime.now().day < 10 ? "0${DateTime.now().day}" : "${DateTime.now().day}";
                    String month = DateTime.now().month < 10 ? "0${DateTime.now().month}" : "${DateTime.now().month}";
                    int year = DateTime.now().year;

                    String date = "$year-$month-$day";

                    Navigator.of(context).push(
                        PageAnimationTransition(
                            page: ActionEmployee(date: date, allAction: true, title: "Ajourd'hui"),
                            pageAnimationType: RightToLeftFadedTransition()
                        )
                    );
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
            FutureBuilder(
                future: lastActionToday,
                builder: (context, snashop){
                  if(snashop.connectionState == ConnectionState.waiting){
                    return const Center(child:  CircularProgressIndicator(color: Colors.orange,),);
                  }else if(snashop.hasError){
                    return const Center(child: Text("Error de chargement de donné", style: TextStyle(color: Colors.red),));
                  }else if(snashop.data!.isEmpty){
                    return const Center(child: Text("Aucune action n'est disponible", style: TextStyle(color: Colors.red),));
                  }else{
                    return Row(
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
                                      color: Colors.orange
                                  ),
                                  child: const  Center(
                                    child: Text(
                                      "T",
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snashop.data!.first.typeAction,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(1),
                                  width: 220,
                                  child: Text(
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                    snashop.data!.first.description,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "DATE",
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${snashop.data?.first.dateAction}",
                              style: const TextStyle(fontSize: 8),
                            )
                          ],
                        )
                      ],
                    );
                  }
                }
            ),

          ],
        ),
      ),
    );
  }

  DelayRightAnimation myServices() {
    return DelayRightAnimation(
      delay: 1000,
      child: Row(
        children: [
          UserConnected.mainAgency?
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
                        Icons.arrow_circle_up,
                        size: 40,
                        color: Colors.orange,
                      ),
                      Text("Alimentation", style: TextStyle(fontSize: 11))
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      PageAnimationTransition(
                          page:  const DepositAccountAgency(),
                          pageAnimationType: RightToLeftFadedTransition()
                      )
                  );
                },
              )): Container(),
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
                        Icons.compare_arrows,
                        size: 40,
                        color: Colors.green,
                      ),
                      Text("Rechargement", style: TextStyle(fontSize: 11))
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      PageAnimationTransition(
                          page:  const OperationOnMainAgency(),
                          pageAnimationType: RightToLeftFadedTransition()
                      )
                  );
                },
              )),
          const SizedBox(
            width: 20,
          ),
          // Expanded(
          //     child: InkWell(
          //       child: Container(
          //         height: 80,
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         child: const Column(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: [
          //             Icon(
          //               Icons.pin,
          //               size: 40,
          //               color: Colors.orange,
          //             ),
          //             Text("Nombre...", style: TextStyle(fontSize: 11))
          //           ],
          //         ),
          //       ),
          //       onTap: () {
          //         Navigator.pushNamed(context, "/create_customer");
          //       },
          //     )),
          // const SizedBox(
          //   width: 20,
          // ),
          // Expanded(
          //     child: InkWell(
          //       child: Container(
          //         height: 80,
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         child: const Column(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: [
          //             Icon(
          //               Icons.co_present,
          //               size: 40,
          //               color: Colors.orange,
          //             ),
          //             Text(
          //               "Presence",
          //               style: TextStyle(fontSize: 11),
          //             )
          //           ],
          //         ),
          //       ),
          //       onTap: () {
          //         Navigator.pushNamed(context, "/listOfTransaction");
          //         //Navigator.popNamed(context, "/listOfTransaction");
          //       },
          //     )),
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
                        Icons.local_activity,
                        size: 40,
                        color: Colors.orange,
                      ),
                      Text("Aujourd'hui", style: TextStyle(fontSize: 11))
                    ],
                  ),
                ),
                onTap: () {

                  String day = DateTime.now().day < 10 ? "0${DateTime.now().day}" : "${DateTime.now().day}";
                  String month = DateTime.now().month < 10 ? "0${DateTime.now().month}" : "${DateTime.now().month}";
                  int year = DateTime.now().year;

                  String date = "$year-$month-$day";
                  print(date);

                  Navigator.of(context).push(
                      PageAnimationTransition(
                          page: ActionEmployee(date: date, allAction: false, title: "Ajourd'hui"),
                          pageAnimationType: RightToLeftFadedTransition()
                      )
                  );
                },
              )),
        ],
      ),
    );
  }


  DelayLetfAnimation buttonRowTwo() {
    return DelayLetfAnimation(
      delay: 1000,
      child: Row(
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
                        Icons.local_activity,
                        size: 40,
                        color: Colors.orange,
                      ),
                      Text("Aujourd'hui", style: TextStyle(fontSize: 11))
                    ],
                  ),
                ),
                onTap: () {

                  String day = DateTime.now().day < 10 ? "0${DateTime.now().day}" : "${DateTime.now().day}";
                  String month = DateTime.now().month < 10 ? "0${DateTime.now().month}" : "${DateTime.now().month}";
                  int year = DateTime.now().year;

                  String date = "$year-$month-$day";
                  print(date);

                  Navigator.of(context).push(
                      PageAnimationTransition(
                          page: ActionEmployee(date: date, allAction: false, title: "Ajourd'hui"),
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
      ),
    );
  }
}
