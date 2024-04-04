import 'package:darktransfert/view/admin/details_employee.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import '../../model/agency_model.dart';

class DetailsAgency extends StatefulWidget {
  final AgencyWithEmployees agency;
  const DetailsAgency({super.key, required this.agency });

  @override
  State<DetailsAgency> createState() => _DetailsAgencyState();
}

class _DetailsAgencyState extends State<DetailsAgency> {

  final style = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500
  );
  final style1 = const TextStyle(
    fontSize: 16,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.agency.name),
        leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 30,),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.orange,
                  ),
                  child: Center(
                    child: Text(widget.agency.name.substring(0,1),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 120,
                          fontWeight: FontWeight.bold
                      ) ,
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.agency.identify,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    prefixIcon: const Icon(Icons.add_home_work_outlined),
                    border: const OutlineInputBorder(),
                    labelText: "Identifiant",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.agency.name,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    prefixIcon: const Icon(Icons.ac_unit),
                    border: const OutlineInputBorder(),
                    labelText: "Nom de l'engence",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.agency.description,
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: null,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    prefixIcon: const Icon(Icons.description,),
                    border: const OutlineInputBorder(),
                    labelText: "Description",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.agency.lieu,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    prefixIcon: const Icon(CupertinoIcons.location_north,),
                    border: const OutlineInputBorder(),
                    labelText: "Localité",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.agency.account.toString(),
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    prefixIcon: TextButton(
                      onPressed: (){},
                      child: const Text("GNF"),
                    ),
                    border: const OutlineInputBorder(),
                    labelText: "Solde de l'agence",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Card(
              elevation: 0.5,
              color: Colors.orange,
              child: ListTile(
                title: const Text("Liste des employés de cette agence", style: TextStyle(color: Colors.white)),
                subtitle: Text("Nombre total d'employer :  ${widget.agency.employees.length}", style: const TextStyle(color: Colors.white),),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_downward, color: Colors.white, size: 30,),
                  onPressed: (){
                    /*Navigator.of(context).push(
                        PageAnimationTransition(
                            page:  DetailsPartners(partner: snapshot.data![index]),
                            pageAnimationType: RightToLeftFadedTransition()
                        )
                    );*/
                  },
                ),
              ),
            ),
            Column(
              children: List.from(widget.agency.employees.map((employee){
                return Card(
                  elevation: 0.5,
                  color: Colors.white,
                  child: ListTile(
                    title: Text(employee.fullname),
                    subtitle: Text("Tel: ${employee.telephone}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: (){
                        Navigator.of(context).push(
                          PageAnimationTransition(
                              page:  DetailsEmployee(employee: employee,),
                              pageAnimationType: RightToLeftFadedTransition()
                          )
                        );
                      },
                    ),

                  ),
                );
              })),
            )
          ],
        ),
      ),
    );
  }
}
