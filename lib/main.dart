import 'package:darktransfert/home.dart';
import 'package:darktransfert/view/caissier/pages/create_custormer.dart';
import 'package:darktransfert/view/caissier/pages/liste_of_transactions.dart';
import 'package:darktransfert/view/caissier/caissier_area.dart';
import 'package:darktransfert/view/comptable/area_comptable.dart';
import 'package:darktransfert/view/firstopen/db_helper.dart';
import 'package:darktransfert/view/firstopen/firs_open.dart';
import 'package:darktransfert/view/firstopen/open.dart';
import 'package:darktransfert/view/login.dart';
import 'package:darktransfert/view/partner/partner_home_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/caissier': (context) => const CaissierArea(),
        '/dg': (context) => const  HomeMain(),
        "/listOfTransaction": (context) => const ListOfTransaction(),
        "/create_customer" : (context) => const CreateCustomer(),
        "/comptable" : (context) => const ComptableArea(),
        "/login" : (context) => const LoginPage(),
        "/partner": (context) => const PartnerPage()
      },
      debugShowCheckedModeBanner: false,
      title: 'Dark Transfert',
      theme: ThemeData(
        fontFamily: "Montserrat",
        appBarTheme:  AppBarTheme(backgroundColor: Colors.orange.withOpacity(0.5))),
      home: FutureBuilder(
          future: DbHelper().countSettings(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Opening(title: "Ouverture ...",);
            }else if(snapshot.hasError){
              return const Opening(
                title: "Une error s'est produite à l'overture ",
                color: Colors.red,
                error: true,
              );
            }else if(!snapshot.hasData){
              return const Opening(
                title: "La base de donné n'est pas initiliser ",
                color: Colors.red,
                error: true,
              );
            }else{
              return  (snapshot.data == 0)? const FirstOpen(): const LoginPage();
            }
          }
      ),
    );
  }
}
