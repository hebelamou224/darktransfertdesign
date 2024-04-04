
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/home.dart';
import 'package:darktransfert/user_connect_info.dart';
import 'package:darktransfert/view/list_partners.dart';
import 'package:darktransfert/view/user.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../agency/page/create_agency.dart';
import '../agency/page/create_employee.dart';
import '../agency/page/deposit_account_agency.dart';
import '../caissier/pages/action.dart';
import '../comptable/page/rechargement.dart';
import '../login.dart';
import '../partner/page/create_partner.dart';


class NavigationDrawers extends StatelessWidget {
  const NavigationDrawers({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildHeader(context),
                buildMenuItems(context)
              ]),
        ),
      );

  Widget buildHeader(BuildContext context) {
    return Material(
      color: Colors.orange.shade800,
      child: InkWell(
        onTap: (){
          //close navigator drawer before
          Navigator.pop(context);
          Navigator.of(context).push(
              PageAnimationTransition(
                  page: const UserPage(),
                  pageAnimationType: RightToLeftFadedTransition()
              )
          );
        },
        child: Container(
          padding:
          EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 24),
          child:  Column(
            children:  [
              CircleAvatar(
                radius: 52,
                backgroundColor: Colors.orange,
                child: Center(child: Text(UserConnected.letterOfName(), style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),),),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                UserConnected.fullname,
                style: const TextStyle(fontSize: 28, color: Colors.white),
              ),
              Text(
                UserConnected.telephone,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 5, //Vertical spacing
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Acceuil"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeMain()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.storefront),
            title: const Text("Agences"),
            onTap: () {
              //Close the navigation drawer before
              Navigator.pop(context);

              Navigator.of(context).push(
                  PageAnimationTransition(
                      page:  const CreateAgency(),
                      pageAnimationType: RightToLeftFadedTransition()
                  )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.personal_injury),
            title: const Text("Patenaires"),
            onTap: () {
              //Close the navigation drawer before
              Navigator.pop(context);

              Navigator.of(context).push(
                  PageAnimationTransition(
                      page:  const CreatePartner(),
                      pageAnimationType: RightToLeftFadedTransition()
                  )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.groups),
            title: const Text("Personnels"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  PageAnimationTransition(
                      page:  const CreateEmployee(),
                      pageAnimationType: RightToLeftFadedTransition()
                  )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text("Comptabilités"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.arrow_circle_up),
            title: const Text("Alimentation"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  PageAnimationTransition(
                      page:  const DepositAccountAgency(),
                      pageAnimationType: RightToLeftFadedTransition()
                  )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.compare_arrows),
            title: const Text("Rechargement"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  PageAnimationTransition(
                      page:  const OperationOnMainAgency(),
                      pageAnimationType: RightToLeftFadedTransition()
                  )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.sort),
            title: const Text("Liste"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  PageAnimationTransition(
                      page:  const ListPartners(),
                      pageAnimationType: RightToLeftFadedTransition()
                  )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.manage_history),
            title: const Text("Historique"),
            onTap: () {
              Navigator.pop(context);
              /*Navigator.of(context).push(
                  PageAnimationTransition(
                      page:  const ListPartners(),
                      pageAnimationType: RightToLeftFadedTransition()
                  )
              );*/
            },
          ),
          const Divider(
            color: Colors.orangeAccent,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Paramettres"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Historique actions"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  PageAnimationTransition(
                      page: const ActionEmployee(date: "", allAction: true, title: "Historique"),
                      pageAnimationType: RightToLeftFadedTransition()
                  )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red,),
            title: const Text("Deconnection", style: TextStyle(color: Colors.red),),
            onTap: () async{
              Navigator.pop(context);
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
          ),
        ],
      ),
    );
  }
}
