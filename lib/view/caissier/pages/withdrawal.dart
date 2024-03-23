import 'package:darktransfert/view/components/field.dart';
import 'package:flutter/material.dart';

class WithDrawalAgencyCustome extends StatefulWidget {
  const WithDrawalAgencyCustome({super.key});

  @override
  State<WithDrawalAgencyCustome> createState() => _WithDrawalAgencyCustomeState();
}

class _WithDrawalAgencyCustomeState extends State<WithDrawalAgencyCustome> {
  final controllerFirstname = TextEditingController();
  final controllerLastname = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final controllerPhone = TextEditingController();
  final controllerAddresse = TextEditingController();
  final constrollerMail = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerConfirmation = TextEditingController();


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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Creation d'un client",style: TextStyle(color: Colors.black),),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.close, color: Colors.redAccent, size: 30,),),
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
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: const Text("Enregistrement d'un client", style: TextStyle(fontSize: 20),),
                      ),

                      fieldFirstname(controllerFirstname),
                      fieldLastname(controllerLastname),
                      fieldTelephone(controllerPhone),
                      fieldEmail(constrollerMail),
                      fieldAddress(controllerAddresse),
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
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange
        ),
        child: const Text("Enregistrer", style:  TextStyle(color: Colors.white),),
      ),
    );
  }
}
