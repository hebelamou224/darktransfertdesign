import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/service/action_service.dart';
import 'package:darktransfert/service/agency_service.dart';
import 'package:darktransfert/service/customer_service.dart';
import 'package:darktransfert/service/partner_services.dart';
import 'package:darktransfert/user_connect_info.dart';
import 'package:darktransfert/view/components/animation_delay.dart';
import 'package:darktransfert/view/components/drawer_men_partner.dart';
import 'package:darktransfert/view/login.dart';
import 'package:darktransfert/view/partner/page/action.dart';
import 'package:darktransfert/view/partner/page/create_personnel.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../model/action.dart';
import '../../model/agency.dart';
import '../admin/details_agency.dart';
import 'page/create_agency_partener.dart';



class PartnerPage extends StatefulWidget {
  const PartnerPage({super.key});

  @override
  State<PartnerPage> createState() => _PartnerPageState();
}

class _PartnerPageState extends State<PartnerPage> {

  PartnerService partnerService = PartnerService();
  AgencyService agencyService = AgencyService();
  CustomerService customerService = CustomerService();
  ActionService actionService = ActionService();
  late Future<AgencyModel?> agencyFuture;
  late Future<List<ActionsConnected>?> actions ;

  bool showAccountSolde = false;
  String identifyAgency = UserConnected.identifyAgency;

  @override
  void initState() {
    super.initState();
    identifyAgency = UserConnected.identifyAgency;
    agencyFuture = agencyService.findByIdentifyAgency(UserConnected.identifyAgency);
    actions = actionService.findAllByIdentifyAgency(identifyAgency);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Space partenaire",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: (){
                setState(() {
                  //Get information for the agency when open the app
                  //agencyFuture = agencyService.findByIdentifyAgency(UserConnected.identifyAgency);

                  //Get last action
                  //lastActionToday = actionService.findActionByEmployeeId(UserConnected.id, "", true);
                });
                partnerService.login(UserConnected.username, UserConnected.password).then((partner) {
                  setState(() {
                    UserConnected.partnerModel = partner;
                  });
                }, onError: (err){
                  showDialog(
                      context: context,
                      builder: (build){
                        return  AlertDialog(
                          title: const Text("Rafraichissement"),
                          content: const  Text("Error de rafraichissement de la page"),
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
      drawer: const NavigationDrawersPartners(),
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
              listAgency(),
              separetedSize(),
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
              rowOfPage(),
              separetedSize(),
              DelayTopAnimation(
                  delay: 1150,
                  child: listAgencies()
              ),
            ],
          ),
        ),
      ),
    );
  }


  SingleChildScrollView listAgencies() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.from(UserConnected.partnerModel!.agencies.map((agency){
            String name = agency.name.toUpperCase();
            return Row(
              children: [
                Column(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                              PageAnimationTransition(
                                  page:  DetailsAgency(agency: agency,),
                                  pageAnimationType: RightToLeftFadedTransition()
                              )
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 150,
                          width: 130,
                          child:  Card(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(name,style: const TextStyle(
                                    fontSize: 10
                                  ),),
                                  const SizedBox(height: 15,),
                                  Text("${agency.account} FGN"),
                                  const SizedBox(height: 15,),
                                  const Text("Nbr employes",
                                  style: TextStyle(fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 15,),
                                  Text("${agency.employees.length}")
                                ],
                              ),
                            )
                          )
                        ),
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

  SizedBox separetedSize() {
    return const SizedBox(
      height: 20,
    );
  }

  DelayTopAnimation rowOfPage() {
    return  const DelayTopAnimation(
      delay: 1100,
      child: Text("Mes Agences", style: TextStyle(fontWeight: FontWeight.w700)),
    );
  }
  DelayTopAnimation listAgency(){
    return DelayTopAnimation(
      delay: 950,
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.orange, width: 2)
          ),
        ),
        hint: const Text("Veuillez selectionner une agence"),
        onChanged: (value){
          setState(() {
            agencyFuture =  agencyService.findByIdentifyAgency(value!);
            identifyAgency = value;
          });
        },
        items: UserConnected.partnerModel?.agencies.map((agency){
          return DropdownMenuItem(
            value: agency.identify,
            child:  Text(agency.name),
          );
        }).toList(),
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
                        agencyFuture = agencyService.findByIdentifyAgency(identifyAgency);
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
                        agencyFuture = agencyService.findByIdentifyAgency(identifyAgency);
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
                            page: ActionEmployee(
                                title: "Operation",
                                identifyAgency: identifyAgency,
                            ),
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
              future: actions,
              builder: (context,snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.orange,),
                        Text("Veuillez Patientez")
                      ],
                    ),
                  );
                }else if(snapshot.hasError){
                  return const Center(child: Text("Error de chargements", style: TextStyle(color: Colors.red),),);
                }else if(snapshot.data!.isEmpty){
                  return const Center(child: Text("Aucune operation disponible", style: TextStyle(color: Colors.red),),);
                }else{
                  return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 241, 241, 241),
                      ),
                      child: Card(
                        elevation: 2,
                        child: ListTile(
                          onTap: (){
                            // detailOperationForPrint(snapshot.data![index], context);
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data!.first.typeAction, style: const TextStyle(fontSize: 20),),
                            ],
                          ),
                          subtitle: Text(snapshot.data!.first.description),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("DATE"),
                              Text(snapshot.data!.first.dateAction, style: const TextStyle(color: Colors.green),)
                            ],
                          ),
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.orange
                            ),
                            child: Center(
                              child: Text(snapshot.data!.first.typeAction.substring(0,1)),
                            ),
                          ),

                        ),
                      )
                  );
                }
              },

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
              )
          ),
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
