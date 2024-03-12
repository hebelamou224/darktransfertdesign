import 'package:darktransfert/view/components/field.dart';
import 'package:flutter/material.dart';

class Personnel extends StatefulWidget {
  const Personnel({super.key});

  @override
  State<Personnel> createState() => _PersonnelState();
}

class _PersonnelState extends State<Personnel> {
  final controllerFirstname = TextEditingController();
  final controllerLastname = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final controllerPhone = TextEditingController();
  final constrollerMail = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerConfirmation = TextEditingController();
  String valueFonction = "";

  @override
  void dispose() {
    super.dispose();
    controllerFirstname.dispose();
    controllerLastname.dispose();
    controllerPhone.dispose();
    constrollerMail.dispose();
    controllerPassword.dispose();
    controllerConfirmation.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion du personnel",style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(50),
          child: Column(
            children: [
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // Container(
                      //   width: 100,
                      //   height: 100,
                      //   child: Image.network("https://www.dak.com/wp-content/uploads/2020/12/DAK_Isotype2.png"),
                      // ),

                     Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: const Text("Enregistrement d'un employé", style: TextStyle(fontSize: 20),),
                     ),
        
                      fieldFirstname(controllerFirstname),
                      fieldLastname(controllerLastname),
                      fieldTelephone(controllerPhone),
                      fieldEmail(constrollerMail),
                      FieldFonction(valueFonction),
                      FieldPassord(controllerPassword, "Mot de passe*"),
                      FieldPassord(controllerConfirmation, "Confirmation*"),
                      submit(formKey)
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  SizedBox submit(GlobalKey<FormState> formKey) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            if (controllerConfirmation.text != controllerPassword.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Mot de pass de confirmation incorrect"),backgroundColor: Colors.red,));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Employe encours d'enregistrement"), backgroundColor: Colors.green,));
            }
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 218, 57, 17))
        ),
        child: const Text("Enregistrer", style:  TextStyle(color: Colors.white),),
      ),
    );
  }
}
