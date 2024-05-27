import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/model/partner.dart';
import 'package:darktransfert/service/action_service.dart';
import 'package:darktransfert/service/agency_service.dart';
import 'package:darktransfert/service/customer_service.dart';
import 'package:darktransfert/service/partner_services.dart';
import 'package:darktransfert/user_connect_info.dart';
import 'package:darktransfert/view/admin/detail_partner.dart';
import 'package:darktransfert/view/agency/page/create_employee.dart';
import 'package:darktransfert/view/agency/page/deposit_account_agency.dart';
import 'package:darktransfert/view/agency/persone.dart';
import 'package:darktransfert/view/caissier/pages/action.dart';
import 'package:darktransfert/view/components/animation_delay.dart';
import 'package:darktransfert/view/components/drawer_menu.dart';
import 'package:darktransfert/view/agency/page/create_agency.dart';
import 'package:darktransfert/view/comptable/page/rechargement.dart';
import 'package:darktransfert/view/list_partners.dart';
import 'package:darktransfert/view/login.dart';
import 'package:darktransfert/view/partner/page/create_partner.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import 'model/action.dart';
import 'model/agency.dart';
import 'model/partners_get.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeState();
}

class _HomeState extends State<HomeMain> {

  PartnerService partnerService = PartnerService();
  AgencyService agencyService = AgencyService();
  CustomerService customerService = CustomerService();
  ActionService actionService = ActionService();
  late Future<List<PartnerModel>> partners;
  late Future<AgencyModel?> agencyFuture;
  late Future<List<ActionsConnected>?> lastActionToday ;

  bool showAccountSolde = false;

  @override
  void initState() {
    super.initState();
    partners = partnerService.findAllPartners();
    //Get information for the agency when open the app
    agencyFuture = agencyService.findByIdentifyAgency(UserConnected.identifyAgency);
    //Get last action
    lastActionToday = actionService.findActionByEmployeeId(UserConnected.id, "", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Agence principal",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: (){
                setState(() {
                  partners = partnerService.findAllPartners();
                  //Get information for the agency when open the app
                  agencyFuture = agencyService.findByIdentifyAgency(UserConnected.identifyAgency);
                  //Get last action
                  lastActionToday = actionService.findActionByEmployeeId(UserConnected.id, "", true);
                });
              },
              icon: const Icon(Icons.refresh)
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
      drawer: const NavigationDrawers(),
      body: mainHome(),
    );
  }

  Container mainHome() {
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
                delay: 1100,
                child: Text(
                  "Mes services",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              separetedSize(),
              buttonRowOne(),
              separetedSize(),
              buttonRowTwo(),
              separetedSize(),
              rowOfPage(),
              separetedSize(),
              DelayTopAnimation(
                delay: 1150,
                  child: listPartners()
              ),
            ],
          ),
        ),
      ),
    );
  }


  FutureBuilder listPartners() {
    return FutureBuilder(
      future: partners,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(color: Colors.orange,),
          );
        }else if(snapshot.hasError){
          return  Container(
            padding: const EdgeInsets.all(10),
            child: const Text("Error de chargement des partenaires", style: TextStyle(color: Colors.red),),
          );
        }else{
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.from(snapshot.data?.map((partner){
                String fullname = partner.fullname.trim();
                String firstname = fullname.split(' ').first;
                String lastname = fullname.split(' ').last;
                String firstLetterFirstname = firstname.substring(0,1).toUpperCase();
                String firstLetterLastname = "";
                if(lastname.isNotEmpty){
                  firstLetterLastname = lastname.substring(0,1).toUpperCase();
                }else{
                  firstLetterLastname = firstname.substring(0,1).toUpperCase();
                }
                return Row(
                  children: [
                    Column(
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                  PageAnimationTransition(
                                      page:  DetailsPartners(partner: partner),
                                      pageAnimationType: RightToLeftFadedTransition()
                                  )
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              height: 70,
                              width: 70,
                              child:  CircleAvatar(
                                backgroundColor: Colors.orange,
                                child: Center(child:  Text('$firstLetterFirstname$firstLetterLastname',
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            firstname,
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                        ]
                    ),
                    const SizedBox(width: 15,),
                  ],
                );
              }).toList(),)
            ),
          );
        }
      },
    );
  }


  SizedBox separetedSize() {
    return const SizedBox(
      height: 20,
    );
  }

  DelayTopAnimation rowOfPage() {
    return  DelayTopAnimation(
      delay: 1100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Mes Partnaires", style: TextStyle(fontWeight: FontWeight.w700)),
          TextButton(
              onPressed: (){
                Navigator.of(context).push(
                    PageAnimationTransition(
                        page:  const ListPartners(),
                        pageAnimationType: RightToLeftFadedTransition()
                    )
                );
              },
              child: const Text(
                "VOIR PLUS",
                style: TextStyle(
                    color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
              ),
          )

        ],
      ),
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
                    //Navigator.pushNamed(context, "/listOfTransaction");
                    String date = "";
                    DateTime.now().month < 10 ?
                    date = "${DateTime.now().year}-0${DateTime.now().month}-${DateTime.now().day}" :
                    date = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
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
                                  "${snashop.data?.first.typeAction}",
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
                                    "${snashop.data?.first.description}",
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

  DelayRightAnimation buttonRowOne() {
    return DelayRightAnimation(
      delay: 1000,
      child: Row(
        children: [
          Expanded(
              child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    PageAnimationTransition(
                        page:  const CreateAgency(),
                        pageAnimationType: RightToLeftFadedTransition()
                    )
                );
              },
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
                    Icons.storefront,
                    size: 40,
                    color: Colors.orange,
                  ),
                  Text("Agences", style: TextStyle(fontSize: 11))
                ],
              ),
            ),
          )),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                  PageAnimationTransition(
                      page:  const CreatePartner(),
                      pageAnimationType: RightToLeftFadedTransition()
                  )
              );
            },
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
                    Icons.personal_injury,
                    size: 40,
                    color: Colors.orange,
                  ),
                  Text("Partenaire", style: TextStyle(fontSize: 11))
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
                    Icons.groups,
                    size: 40,
                    color: Colors.orange,
                  ),
                  Text("Personnels", style: TextStyle(fontSize: 11))
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                  PageAnimationTransition(
                      page:  const CreateEmployee(),
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
                    Icons.paid,
                    size: 40,
                    color: Colors.orange,
                  ),
                  Text(
                    "Comptablité",
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
                    Icons.sort,
                    size: 40,
                    color: Colors.orange,
                  ),
                  Text("Liste", style: TextStyle(fontSize: 11))
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                  PageAnimationTransition(
                      page:  const ListPartners(),
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
