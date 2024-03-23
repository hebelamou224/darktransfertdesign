import 'package:darktransfert/model/partner.dart';
import 'package:darktransfert/service/partner_services.dart';
import 'package:darktransfert/view/components/field.dart';
import 'package:flutter/material.dart';

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
  bool showTextNotObscurePassword = true;
  bool isLoading = false;

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
                          validator: (value) =>
                          (value == null || value == "")
                              ? "Veuillez entrer le username"
                              : null,
                        ),
                      ),
                      fieldFirstname(firstnameController),
                      fieldLastname(lastnameController),
                      fieldTelephone(telephoneController),
                      fieldEmail(emailController),
                      fieldAddress(addressController),
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
                          validator: (value) =>
                          (value == null || value == "")
                              ? "Veuillez retapper le mot passe par defaut"
                              : null,
                        ),
                      ),
                      isLoading ?  CircularProgressIndicator() :
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
            if (passwordConfirmController.text != passwordController.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Mot de pass de confirmation incorrect"),
                    backgroundColor: Colors.red,));
            } else {
              setState(() {
                isLoading = true;
              });
              Partner partner = Partner(
                  id: -1,
                  username: usernameController.text,
                  address: addressController.text,
                  telephone: telephoneController.text,
                  fullname: firstnameController.text + " " + lastnameController.text);
              String response = await partnerService.addPartner(partner);
              if(response == "succes"){
                showDialog(context: context, builder: (builder) => AlertDialog(
                  icon: const Icon(Icons.check_circle, color: Colors.green, size: 50,),
                  scrollable: true,
                  title:  Container(
                    width: double.infinity,
                    child: const Text("Enregistrement partenaire"),
                  ),
                  content: Container(
                    height: 100,
                    padding: const EdgeInsets.all(10),
                    child:  Column(children: [
                      Row(
                        children: [
                          const Text("Partenaire "),
                          Text(" ${firstnameController.text.toUpperCase()} ${lastnameController.text.toUpperCase()} ", style: const TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),
                      const Text(" enregistré avec succès, vous pouvez creé une agences et des employés pour ce partenaire")
                    ],),
                  ),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                      usernameController.text = "";
                      firstnameController.text = "";
                      lastnameController.text = "";
                      emailController.text = "";
                      telephoneController.text = "";
                      addressController.text = "";
                      passwordConfirmController.text = "";
                      passwordController.text = "";
                    }, child: const Text("OK"))
                  ],
                ));

              }else if(response == "username_exist"){
                showDialog(context: context, builder: (builder) => AlertDialog(
                  icon: const Icon(Icons.cancel, color: Colors.red, size: 50,),
                  title:  Container(
                    child: const Text("Enregistrement partenaire"),
                  ),
                  content: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text("Cet username existe deja pour un autre partenaire veuillez changer le username"),
                  ),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: const Text("OK", style: TextStyle(fontSize: 20),))
                  ],
                ));
              }
              setState(() {
                isLoading = false;
              });
            }
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
