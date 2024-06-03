import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/model/agency.dart';
import 'package:darktransfert/service/agency_service.dart';
import 'package:darktransfert/service/customer_service.dart';
import 'package:darktransfert/user_connect_info.dart';
import 'package:darktransfert/view/agency/persone.dart';
import 'package:darktransfert/view/caissier/pages/action.dart';
import 'package:darktransfert/view/caissier/pages/deposit_international.dart';
import 'package:darktransfert/view/caissier/pages/deposit_local.dart';
import 'package:darktransfert/view/caissier/pages/liste_of_transactions.dart';
import 'package:darktransfert/view/caissier/pages/search_transaction.dart';
import 'package:darktransfert/view/caissier/pages/withdrawal.dart';
import 'package:darktransfert/view/components/drawer_menu_agency.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../model/customer.dart';
import '../components/animation_delay.dart';
import '../login.dart';


class CaissierArea extends StatefulWidget {
  const CaissierArea({super.key});

  @override
  State<CaissierArea> createState() => _CaissierAreaState();
}

class _CaissierAreaState extends State<CaissierArea> {
  AgencyService agencyService = AgencyService();
  CustomerService customerService = CustomerService();

  bool showAccountSolde = true;
  late Future<AgencyModel?> agencyFuture;
  late Future<Customer?> lastOperation;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    //Get information for the agency when open the app
    agencyFuture = agencyService.findByIdentifyAgency(UserConnected.identifyAgency);
    //Get last operation
    lastOperation = customerService.findFirstByOrderByOperationDateModifyDesc();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
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
              onPressed: (){
                setState(() {
                  agencyFuture = agencyService.findByIdentifyAgency(UserConnected.identifyAgency);
                  //Get last operation
                  lastOperation = customerService.findFirstByOrderByOperationDateModifyDesc();
                });
              },
              icon: const Icon(Icons.refresh)
          ),
          IconButton(
              onPressed: () async{
                if(await confirm(
                    context,
                  title: const Text("Deconnexion"),
                  content: const Text("Voullez vous deconnectez ?"),
                  textOK: const Text("OUI"),
                  textCancel: const Text("NON")
                )){
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginPage())
                  );
                }
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      drawer: const NavigationDrawerAgency(),
      body: RefreshIndicator(
          onRefresh: () {
            return Future((){
              lastOperation = customerService.findFirstByOrderByOperationDateModifyDesc();
            });
          },
          child: mainHomeRegistreCustomer()
        ),
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
              const DelayTopAnimation(
                delay: 1000,
                child:  Text(
                  "Mes services",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              separetedSize(),
              buttonRowOne(),
              DelayTopAnimation(
                delay: 1000,
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: TextFormField(
                    onEditingComplete: (){
                      searchFocus.unfocus();
                      Navigator.of(context).push(
                          PageAnimationTransition(
                              page:  SearchTransaction(initialValue: searchController.text,),
                              pageAnimationType: RightToLeftFadedTransition()
                          )
                      );
                      searchController.text = "";
                    },
                    focusNode: searchFocus,
                    autofocus: false,
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Recherche par nom ou code transaction",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: (){
                          searchFocus.unfocus();
                          Navigator.of(context).push(
                              PageAnimationTransition(
                                  page:  const SearchTransaction(),
                                  pageAnimationType: RightToLeftFadedTransition()
                              )
                          );
                          searchController.text = "";
                        },
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: (){
                          searchFocus.unfocus();
                          Navigator.of(context).push(
                              PageAnimationTransition(
                                  page:   SearchTransaction(initialValue: searchController.text,),
                                  pageAnimationType: RightToLeftFadedTransition()
                              )
                          );
                          searchController.text = "";
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.orange, width: 3)
                      ),
                      border: const OutlineInputBorder()
                    ),
                  ),
                ),
              )
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
        height: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.white),
        child: Column(
          children: [
            //for show the name agency
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
            //for show the an amount agency
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
                    Navigator.of(context).push(
                        PageAnimationTransition(
                            page: const ListOfTransaction(),
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
                future: lastOperation,
                builder: (context, snashop){
                  if(snashop.connectionState == ConnectionState.waiting){
                    return const Center(child:  CircularProgressIndicator(color: Colors.orange,),);
                  }else if(snashop.hasError){
                    return const Center(child: Text("Error de chargement de donné", style: TextStyle(color: Colors.red),));
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
                                      color: snashop.data!.status! ? Colors.orange : Colors.green
                                  ),
                                  child:  Center(
                                    child: Text(
                                      snashop.data!.status! ? "R" : "D",
                                      style: const TextStyle(
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
                                  snashop.data!.status! ? "${snashop.data?.fullnameRecever}" : "${snashop.data?.fullname}",
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  snashop.data!.status! ? "Retrait": "Depot",
                                  style: const TextStyle(fontSize: 10),
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${snashop.data?.amount} GNF",
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${snashop.data?.dateModify}",
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

  DelayRightAnimation buttonRowOne() {
    return DelayRightAnimation(
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
                    Icons.arrow_downward,
                    size: 40,
                    color: Colors.green,
                  ),
                  Text("Depôt", style: TextStyle(fontSize: 11))
                ],
              ),
            ),
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (builder){
                    return AlertDialog(
                      title: const Text("Operation de depot"),
                      content: SizedBox(
                        height: 150,
                        child: Column(
                          children: [
                            const Text("Veuillez choissir le mode de transaction"),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: double.infinity,
                              child: Card(
                                elevation: 2,
                                child: TextButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                      Navigator.of(context).push(PageAnimationTransition(
                                          page: const DepositInternationalAgencyCustome(),
                                          pageAnimationType: RightToLeftFadedTransition()
                                      )
                                      );
                                    },
                                    child: const Text("Internation")
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: double.infinity,
                              child: Card(
                                elevation: 2,
                                child: TextButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                      Navigator.of(context).push(PageAnimationTransition(
                                          page: const DepositAgencyCustome(),
                                          pageAnimationType: RightToLeftFadedTransition()
                                      )
                                      );
                                    },
                                    child: const Text("Local")
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: const Text("Fermer")
                        )
                      ],
                    );
                  }
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
              Navigator.of(context).push(
                  PageAnimationTransition(
                    page: const ListOfTransaction(),
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
      ),
    );
  }
}
