import 'package:darktransfert/service/partner_services.dart';
import 'package:darktransfert/view/admin/detail_partner.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';


import '../model/partners_get.dart';

class ListPartners extends StatefulWidget {
  const ListPartners({super.key});

  @override
  State<ListPartners> createState() => _ListPartnersState();
}

class _ListPartnersState extends State<ListPartners> {

  PartnerService partnerService = PartnerService();
  late Future<List<PartnerModel>> partners ;

  bool isSearch = false;
  FocusNode focusSearchNode = FocusNode();
  String searchIsEmpty = "";

  @override
  void initState() {
    super.initState();
    partners = partnerService.findAllPartners();
  }

  Future<void> reloadData() async{
    setState(() {
      partners = partnerService.findAllPartners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: isSearch?
            Container(
              height: 46,
              margin: const EdgeInsets.all(10),
              child: TextFormField(
                focusNode: focusSearchNode,
                onChanged: (value){
                  setState(() {
                    partners = partnerService.findAllPartnersWithValue(value);
                    searchIsEmpty = "pour '$value'";
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: (){},
                      icon: const Icon(Icons.mic)
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange)
                  ),
                  hintText: "Nom, Prenom, Telephone"
                ),
              ),
            ):
        const Text(
          "Liste des partenaires",
          style: TextStyle(color: Colors.orange),
        ),
        actions: [
          IconButton(
              onPressed: (){
               setState(() {
                 isSearch = !isSearch;
                 if(isSearch){
                   focusSearchNode.requestFocus();
                 }else{
                   focusSearchNode.unfocus();
                   partners = partnerService.findAllPartners();
                 }
               });
              },
              icon: isSearch? const Icon(Icons.close) : const Icon(Icons.search)
          ),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor:  Colors.white,
        leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 30,),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: RefreshIndicator(
        color: Colors.orange,
        onRefresh: reloadData,
        child: FutureBuilder(
          future: partners,
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                heightFactor: MediaQuery.of(context).size.height,
                child: const Column(
                  children: [
                    CircularProgressIndicator(color: Colors.orange,),
                    SizedBox(height: 8,),
                    Text("Veuillez partienter le chargement")
                  ],
                ),
              );
            }else if(snapshot.hasError){
              return Center(
                heightFactor: MediaQuery.of(context).size.height,
                child: const Text("Error de chargement de la liste", style: TextStyle(color: Colors.red),)
              );
            }else if(snapshot.data!.isEmpty){
              return Center(
                  heightFactor: MediaQuery.of(context).size.height,
                  child: Text("Aucun partenaire trouvés $searchIsEmpty", style: const TextStyle(color: Colors.blueGrey),)
              );
            }else{
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index){
                  return Container(
                    margin: const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                    child: Card(
                      elevation: 0.5,
                      color: Colors.white,
                      child: ListTile(
                        title: Text(snapshot.data![index].fullname),
                        subtitle: Text("Nombre d'agence total: ${snapshot.data![index].agencies.length}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: (){
                            Navigator.of(context).push(
                                PageAnimationTransition(
                                    page:  DetailsPartners(partner: snapshot.data![index]),
                                    pageAnimationType: RightToLeftFadedTransition()
                                )
                            );
                          },
                        ),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.orange,
                          ),

                          child:  Center(
                            child: Text(snapshot.data![index].fullname.substring(0,1)),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        ),
      ),
    );
  }


}

