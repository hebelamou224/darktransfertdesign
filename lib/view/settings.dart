import 'package:flutter/material.dart';
import '../../../model/action.dart';
import '../../../service/action_service.dart';
import '../../../user_connect_info.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  bool stateCheck = false;
  String devise = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Parametre"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.redAccent, size: 30,),
        ),
      ),
      body:  SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ListTile(
                      title: Text("Dark Transfert App"),
                      subtitle: Text("Version 0.0.1", style: TextStyle(color: Colors.black54),),
                    ),
                    const SizedBox(height: 10,),
                    Divider(color: Colors.grey.withOpacity(0.2),),
                    ListTile(
                      onTap: (){
                        setState(() {
                          stateCheck = !stateCheck;
                        });
                      },
                      title: const Row(
                        children: [
                          Text("Emprinte digital"),
                          IconButton(
                              onPressed: null,
                              icon: Icon(Icons.fingerprint)
                          ),
                        ],
                      ),
                      subtitle: const Text("Deverouiller rapidement avec l'empreint"),
                      trailing: Checkbox(
                          value: stateCheck,
                          activeColor: Colors.orange,
                          onChanged: (value){
                            setState(() {
                              stateCheck = value!;
                            });
                          }
                      ),
                    ),
                    Divider(color: Colors.grey.withOpacity(0.2),),
                    ListTile(
                      onTap: (){
                      },
                      title: const Row(
                        children: [
                          Text("Devise de la monnaie"),
                          IconButton(
                              onPressed: null,
                              icon: Icon(Icons.euro)
                          ),
                        ],
                      ),
                      subtitle: DropdownButtonFormField(
                        items: const [
                           DropdownMenuItem(
                              value: "GNF",
                              child:  Text("Franc Guinée (GNF)"),
                            ),
                          DropdownMenuItem(
                            value: "US",
                            child:  Text("Dollar (US)"),
                          ),
                          DropdownMenuItem(
                            value: "EU",
                            child:  Text("Euro (EURO)"),
                          )
                        ],
                        value: "GNF",
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none
                          )
                        ),
                        onChanged: (value) {
                          devise = value!;
                        },
                      )
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.grey.withOpacity(0.05),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: const Center(
                  child: Text("Copy Right 2024 Made by Trustify Technology"),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
