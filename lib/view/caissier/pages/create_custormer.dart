
import 'package:darktransfert/view/components/field.dart';
import 'package:flutter/material.dart';

class CreateCustomer extends StatefulWidget {
  const CreateCustomer({super.key});

  @override
  State<CreateCustomer> createState() => _CreateCustomerState();
}

class _CreateCustomerState extends State<CreateCustomer> {
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
                      // Container(
                      //   width: 100,
                      //   height: 100,
                      //   child: Image.network("https://www.dak.com/wp-content/uploads/2020/12/DAK_Isotype2.png"),
                      // ),

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
