import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/model/partner.dart';
import 'package:darktransfert/service/partner_services.dart';
import 'package:darktransfert/view/components/field.dart';
import 'package:flutter/material.dart';
import 'package:kdialogs/kdialogs.dart';

class CreatePartner extends StatefulWidget {
  const CreatePartner({super.key});

  @override
  State<CreatePartner> createState() => _CreatePartnerState();
}

class _CreatePartnerState extends State<CreatePartner> {
  final formKey = GlobalKey<FormState>();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final telephoneController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  FocusNode focusFirstnameController = FocusNode();
  FocusNode focusTelephoneController = FocusNode();
  FocusNode focusLastnameController = FocusNode();
  FocusNode focusAddressController = FocusNode();
  FocusNode focusEmailController = FocusNode();
  FocusNode focusPasswordController = FocusNode();
  FocusNode focusPasswordConfirmController = FocusNode();
  FocusNode focusUsernameController = FocusNode();


  bool showTextNotObscurePassword = true;

  PartnerService partnerService = PartnerService();


  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    addressController.dispose();
    passwordConfirmController.dispose();
    passwordController.dispose();

    focusAddressController.dispose();
    focusEmailController.dispose();
    focusFirstnameController.dispose();
    focusLastnameController.dispose();
    focusPasswordConfirmController.dispose();
    focusPasswordController.dispose();
    focusTelephoneController.dispose();
    focusUsernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Creation d'un partenaire", style: TextStyle(color: Colors.black),),
        leading: IconButton(onPressed: () {
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
                        child: const Text("Enregistrement d'un partenaire",
                          style: TextStyle(fontSize: 20),),
                      ),

                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              labelText: "username*",
                              hintText: "Entrer un nom d'utilisateur*"),
                          controller: usernameController,
                          focusNode: focusUsernameController,
                          onEditingComplete: (){
                            focusFirstnameController.nextFocus();
                          },
                          validator: (value) =>
                          (value == null || value == "")
                              ? "Veuillez entrer le username"
                              : null,
                        ),
                      ),
                      fieldFirstname(firstnameController, focusFirstnameController,focusLastnameController),
                      fieldLastname(lastnameController, focusLastnameController,focusTelephoneController),
                      fieldTelephone(telephoneController, focusTelephoneController, focusEmailController),
                      fieldEmail(emailController, focusEmailController, focusAddressController),
                      fieldAddress(addressController, focusAddressController, focusPasswordController),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: showTextNotObscurePassword,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.key),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showTextNotObscurePassword =
                                      !showTextNotObscurePassword;
                                    });
                                  },
                                  icon: showTextNotObscurePassword ? const Icon(
                                      Icons.visibility_off) : const Icon(
                                      Icons.visibility)),
                              border: const OutlineInputBorder(),
                              labelText: "Mot de passe par defaut*",
                              hintText: "Entrer le mot de passe par defaut"),
                          controller: passwordController,
                          focusNode: focusPasswordController,
                          onEditingComplete: (){
                            focusPasswordConfirmController.nextFocus();
                          },
                          validator: (value) =>
                          (value == null || value == "")
                              ? "Veuillez entrer le mot passe par defaut"
                              : null,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: showTextNotObscurePassword,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.key),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showTextNotObscurePassword =
                                      !showTextNotObscurePassword;
                                    });
                                  },
                                  icon: showTextNotObscurePassword ? const Icon(
                                      Icons.visibility_off) : const Icon(
                                      Icons.visibility)),
                              border: const OutlineInputBorder(),
                              labelText: "Confirmation*",
                              hintText: "Retapper le mot de pass par defaut"),
                          controller: passwordConfirmController,
                          focusNode: focusPasswordConfirmController,
                          validator: (value){
                            if(value == null || value == ""){
                              return "Veuillez retapper le mot passe par defaut";
                            }else if(passwordController.text != passwordConfirmController.text){
                              return "Le mot de passe de confirmation ne correspond pas";
                            }else{
                              return null;
                            }
                          }
                        ),
                      ),
                      submit(formKey),
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
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            focusAddressController.unfocus();
            focusEmailController.unfocus();
            focusFirstnameController.unfocus();
            focusLastnameController.unfocus();
            focusPasswordConfirmController.unfocus();
            focusPasswordController.unfocus();
            focusTelephoneController.unfocus();
            focusUsernameController.unfocus();

            if(await confirm(
                context,
              title: const Row(
                children: [
                  Icon(Icons.info, color: Colors.green,),
                  SizedBox(width: 8,),
                  Text("Confirmation"),
                ],
              ),
                content: const Text(
                    "Confirmez-vous l'enregistrement des informations saisies"
                ),
                textOK: const Text("Confirmer",
                  style: TextStyle(color: Colors.green),
                ),
                textCancel: const Text("Anuller",
                  style: TextStyle(color: Colors.red),
                )
            )){
            }else{
              return;
            }

            Partner partner = Partner(
                id: -1,
                username: usernameController.text,
                address: addressController.text,
                telephone: telephoneController.text,
                fullname: "${firstnameController.text} ${lastnameController.text}",
                password: passwordController.text
            );
            final close = await showKDialogWithLoadingMessage(context, message: "Veuillez patienter" );
            await partnerService.addPartner(partner)
            .then((value) async{
              close();
              if(value == "succes"){
                if(await confirm(
                    context,
                  title: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.green,),
                      SizedBox(width: 8,),
                      Text("Information"),
                    ],
                  ),
                  content: const Text("L'enregistrement du partenaire effectué avec succes"),
                  textOK: const Text("OK"),
                  textCancel: const Text("")
                )){

                }
                Navigator.pop(context);
              }else{
                showDialog(
                    context: context,
                    builder: (builder){
                      return  AlertDialog(
                        icon: const Icon(Icons.close, color: Colors.red, size: 50,),
                        title: const Text("Error"),
                        content: Text("Ce nom d'utilisateur(${usernameController.text}) existe déja pour un autre  partenaire, veuillez changer pour continuer l'enregistrement"),
                        actions: [
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const Text("OK")
                          )
                        ],
                      );
                    }
                );
              }
            }, onError: (error){
              close();
              showDialog(
                  context: context,
                  builder: (builder){
                    return  AlertDialog(
                      icon: const Icon(Icons.close, color: Colors.red, size: 50,),
                      title: const Text("Error"),
                      content: const Text("Une erreur s'est produite, veuillez reprendre"),
                      actions: [
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: const Text("OK")
                        )
                      ],
                    );
                  }
              );
            });

          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange
        ),
        child: const Text(
          "Enregistrer", style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
