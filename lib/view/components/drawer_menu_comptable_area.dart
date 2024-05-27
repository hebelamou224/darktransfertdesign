import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/view/comptable/area_comptable.dart';
import 'package:darktransfert/view/user.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../user_connect_info.dart';
import '../agency/page/deposit_account_agency.dart';
import '../caissier/pages/action.dart';
import '../login.dart';
import '../settings.dart';

class NavigationDrawerComptable extends StatelessWidget {
  const NavigationDrawerComptable({super.key});

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
                /* backgroundImage: NetworkImage(
                    "https://media.istockphoto.com/id/1476170969/fr/photo/portrait-dun-jeune-homme-pr%C3%AAt-%C3%A0-lemploi-business-concept.webp?b=1&s=170667a&w=0&k=20&c=y1iV8F--V8Q-L1YvZvAcA7Z0XeOkK4cmRUdeHz_gz_I="),*/
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
                  MaterialPageRoute(builder: (context) => const ComptableArea()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.arrow_circle_up),
            title: const Text("Alimentation"),
            onTap: () {
              //Close the navigation drawer before
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
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.pin),
            title: const Text("Nombre client"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text("Caisse"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.co_present),
            title: const Text("Prensence caissier"),
            onTap: () {},
          ),
          const Divider(
            color: Colors.orangeAccent,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Paramettres"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  PageAnimationTransition(
                      page: const Settings(),
                      pageAnimationType: RightToLeftFadedTransition()
                  )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Historique"),
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
