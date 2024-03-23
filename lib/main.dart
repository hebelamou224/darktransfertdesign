import 'package:darktransfert/home.dart';
import 'package:darktransfert/repository/user_repository.dart';
import 'package:darktransfert/view/caissier/pages/create_custormer.dart';
import 'package:darktransfert/view/caissier/pages/liste_of_transactions.dart';
import 'package:darktransfert/view/caissier/caissier_area.dart';
import 'package:darktransfert/view/comptable/page/create_comptable.dart';
import 'package:darktransfert/view/login.dart';
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
        "/login" : (context) => const LoginPage()
      },
      debugShowCheckedModeBanner: false,
      title: 'Dark Transfert',
      theme: ThemeData(
        fontFamily: "Montserrat",
        appBarTheme: const AppBarTheme(backgroundColor: Colors.orange)),
      home: const LoginPage(),
    );
  }
}
