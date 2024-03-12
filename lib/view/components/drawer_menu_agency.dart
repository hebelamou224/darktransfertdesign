
import 'package:darktransfert/view/caissier/registre_customer.dart';
import 'package:darktransfert/view/favorite.dart';
import 'package:darktransfert/view/user.dart';
import 'package:flutter/material.dart';

class NavigationDrawerAgency extends StatelessWidget {
  const NavigationDrawerAgency({super.key});

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
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const UserPage()));
        },
        child: Container(
          //color: Colors.blue.shade700,
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 24),
          child: const Column(
            children:  [
              CircleAvatar(
                radius: 52,
                backgroundImage: NetworkImage(
                    "https://media.istockphoto.com/id/1476170969/fr/photo/portrait-dun-jeune-homme-pr%C3%AAt-%C3%A0-lemploi-business-concept.webp?b=1&s=170667a&w=0&k=20&c=y1iV8F--V8Q-L1YvZvAcA7Z0XeOkK4cmRUdeHz_gz_I="),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "Moriba Hebelamou",
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
              Text(
                "dev.hebelamou@gmail.com",
                style: TextStyle(fontSize: 16, color: Colors.white),
              )
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
                  MaterialPageRoute(builder: (context) => const CaisierArea()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text("Client"),
            onTap: () {
              //Close the navigation drawer before
              Navigator.pop(context);

              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Favorite()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.arrow_forward),
            title: const Text("Depôt"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.arrow_back),
            title: const Text("Retrait"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text("Caisse"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text("Listes"),
            onTap: () {},
          ),
          const Divider(
            color: Colors.orangeAccent,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Paramettres"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Historique"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}