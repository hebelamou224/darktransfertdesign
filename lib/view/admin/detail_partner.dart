import 'package:darktransfert/model/partners_get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'details_agency.dart';

class DetailsPartners extends StatefulWidget {
  final PartnerModel partner;
  const DetailsPartners({super.key, required this.partner });

  @override
  State<DetailsPartners> createState() => _DetailsPartnersState();
}

class _DetailsPartnersState extends State<DetailsPartners> {
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
        title: Text("${widget.partner.fullname}(partenaire)"),
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
                    child: Text(widget.partner.fullname.substring(0,1),
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
                initialValue: widget.partner.username,
                decoration:  InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                  ),
                  prefixIcon: const Icon(CupertinoIcons.person),
                  border: const OutlineInputBorder(),
                  labelText: "Username",
                  labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.partner.fullname,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    prefixIcon: const Icon(Icons.person_pin),
                    border: const OutlineInputBorder(),
                    labelText: "Nom complet",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.partner.address,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    prefixIcon: const Icon(CupertinoIcons.location_circle,),
                    border: const OutlineInputBorder(),
                    labelText: "Addresse",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.partner.telephone,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    prefixIcon: IconButton(
                      icon: const Icon(CupertinoIcons.phone,),
                      onPressed: (){
                        launchUrlString("tel:${widget.partner.telephone}");
                      },
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: (){
                        launchUrlString("sms:${widget.partner.telephone}");
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: "Telephone",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.partner.dateRegister,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    prefixIcon: const Icon(Icons.calendar_month_outlined),
                    border: const OutlineInputBorder(),
                    labelText: "Date d'enregistrement",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Card(
              elevation: 0.5,
              color: Colors.orange,
              child: ListTile(
                title: const Text("Les agences du partenaires", style: TextStyle(color: Colors.white)),
                subtitle: Text("Nombre d'agence total :  ${widget.partner.agencies.length}", style: const TextStyle(color: Colors.white),),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_downward, color: Colors.white, size: 30,),
                  onPressed: (){},
                ),
              ),
            ),
            Column(
              children: List.from(widget.partner.agencies.map((agency){
                return Card(
                  elevation: 0.5,
                  color: Colors.white,
                  child: ListTile(
                    title: Text(agency.name),
                    subtitle: Text(agency.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: (){
                        Navigator.of(context).push(
                          PageAnimationTransition(
                              page:  DetailsAgency(agency: agency,),
                              pageAnimationType: RightToLeftFadedTransition()
                          )
                        );
                      },
                    ),
                    onTap: (){
                      Navigator.of(context).push(
                          PageAnimationTransition(
                              page:  DetailsAgency(agency: agency,),
                              pageAnimationType: RightToLeftFadedTransition()
                          )
                      );
                    },
                  ),
                );
              })),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, "/dg", (route) => false);
        },
        tooltip: "Acceuil",
        backgroundColor: Colors.orange,
        child: const Icon(Icons.home_outlined, color: Colors.white,),
      ),
    );
  }
}
