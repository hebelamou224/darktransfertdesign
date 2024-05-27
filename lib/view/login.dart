import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/repository/user_repository.dart';
import 'package:darktransfert/service/agency_service.dart';
import 'package:darktransfert/service/partner_services.dart';
import 'package:darktransfert/user_connect_info.dart';
import 'package:darktransfert/view/components/animation_delay.dart';
import 'package:flutter/material.dart';
import 'package:kdialogs/kdialogs.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool showVisibilityIcon = true;
  bool isLoading = false;
  bool isPartener = false;
  FocusNode usernameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  UserRepository userRepository = UserRepository();
  PartnerService partnerService = PartnerService();
  AgencyService agencyService = AgencyService();


  @override
  void dispose() {
    super.dispose();
    controllerUsername.dispose();
    controllerPassword.dispose();
    usernameFocus.dispose();
    passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Authentification",
          style: TextStyle(color: Colors.orange, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 50),
        child: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const DelayAnimation(
                    delay: 2000,
                    child: SizedBox(
                        height: 110,
                        width: 110,
                        child: Image(
                            image: AssetImage("assets/images/logo.png")))),
                const SizedBox(
                  height: 30,
                ),
                const DelayAnimation(
                  delay: 2500,
                  child: Text(
                    "CONNEXION",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DelayAnimation(
                    delay: 3000,
                    child: TextFormField(
                      autofocus: true,
                      controller: controllerUsername,
                      focusNode: usernameFocus,
                      onEditingComplete: (){
                        passwordFocus.nextFocus();
                      },
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange, width: 2)
                          ),
                          focusColor: Colors.orange,
                          fillColor: Colors.orange,
                          hintText: "Enter le nom d'utilisateur*",
                          labelText: "Nom d'utilisateur",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange)
                          )
                      ),
                      validator: (value) => (value!.isEmpty)
                          ? "Veuillez entrer le nom d'utilisateur"
                          : null,
                    )
                ),
                const SizedBox(
                  height: 20,
                ),
                DelayAnimation(
                    delay: 3500,
                    child: TextFormField(
                      focusNode: passwordFocus,
                      onEditingComplete: () async {
                        if (formKey.currentState!.validate()) {
                            connect();
                        }
                      },
                      controller: controllerPassword,
                      obscureText: showVisibilityIcon,
                      decoration:  InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange, width: 2)
                        ),
                        suffixIcon: IconButton(onPressed: (){
                          setState(() {
                            showVisibilityIcon = !showVisibilityIcon;
                          });
                        }, icon: showVisibilityIcon ? const Icon(Icons.visibility_off): const Icon(Icons.visibility)),
                          hintText: "Enter votre mot de pass",
                          labelText: "Mot de passe",
                          border: const OutlineInputBorder()),
                    )),
                const SizedBox(
                  height: 5,
                ),
                DelayAnimation(
                    delay: 3500,
                    child: Row(
                      children: [
                        Checkbox(
                          value: isPartener,
                          activeColor: Colors.orange,
                          onChanged: (value){
                            setState(() {
                              isPartener = !isPartener;
                            });
                          },
                        ),
                        const Text("Je suis un partenaire")
                      ],
                    )
                ),
                const SizedBox(
                  height: 20,
                ),
                isLoading ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.orange,),
                      Text("Connection...")
                    ],
                  ),
                ):
                DelayAnimation(
                    delay: 4000,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            connect();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            backgroundColor: Colors.orange),
                        child: const Text("Se conecter", style: TextStyle(color: Colors.white),),
                      ),
                    )),
                DelayAnimation(
                    delay: 5000,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () async {
                             // await fetchData();
                            },
                            child: const Text("Mot de pass oublié ?"))
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Fonction to connect on application
  Future<void> connect() async{
    usernameFocus.unfocus();
    passwordFocus.unfocus();

    if(isPartener){
      final close = await showKDialogWithLoadingMessage(context, message: "Connection en cours..." );
      await partnerService.login(
          controllerUsername.text.trim(),
          controllerPassword.text.trim()
      ).then((partner) async{
        close();
        if(partner != null){
          setState(() {
            UserConnected.id =partner.id;
            UserConnected.username = partner.username;
            UserConnected.fullname = partner.fullname;
            UserConnected.firstname = "";
            UserConnected.lastname = "";
            UserConnected.dateConnected = DateTime.now().toString();
            UserConnected.password = partner.password!;
            UserConnected.telephone = partner.telephone;
            UserConnected.dateRegister = partner.dateRegister;
            UserConnected.identifyAgency = (partner.agencies.isNotEmpty) ? partner.agencies[0].identify : "";
            //UserConnected.role = partner.role;
            UserConnected.address = partner.address;
            UserConnected.partnerModel = partner;
          });
          Navigator.popAndPushNamed(context, "/partner");
        }else{
          if( await confirm(
              context,
              title: const Row(
                children: [
                  Icon(Icons.error, color: Colors.red,),
                  Text("Authentification")
                ],
              ),
              content: const Text("Mot de passe ou nom d'utilisateur incorrect"),
              textOK: const Text("OK"),
              textCancel: const Text("Annuler")
          )){
          }
        }
      }, onError: (err) async{
        close();
        if( await confirm(
            context,
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red,),
                Text("Authentification")
              ],
            ),
            content: const Text("Mot de passe ou nom d'utilisateur incorrect, ou veuillez verifier la disponibilite du service et reesayer. Merci !!"),
            textOK: const Text("OK"),
            textCancel: const Text("Annuler")
        )){
        }
      });
      return;
    }

    final close = await showKDialogWithLoadingMessage(context, message: "Connection en cours..." );
    await userRepository.findUser(
        controllerUsername.text.trim(),
        controllerPassword.text.trim()
    ).then((employee) async{
      if(employee != null){
        close();
        setState(() {
          UserConnected.id = employee.id;
          UserConnected.username = employee.username;
          UserConnected.fullname = employee.fullname;
          UserConnected.firstname = "";
          UserConnected.lastname = "";
          UserConnected.dateConnected = DateTime.now().toString();
          UserConnected.password = employee.password;
          UserConnected.telephone = employee.telephone;
          UserConnected.dateRegister = employee.dateRegister;
          UserConnected.identifyAgency = employee.identifyAgency;
          UserConnected.role = employee.role;
          UserConnected.address = employee.address;
        });
        await agencyService.findByIdentifyAgency(employee.identifyAgency)
        .then((agency){
          if(agency?.owner == "MAIN"){
            setState(() {
              UserConnected.mainAgency = true;
            });
          }else{
            setState(() {
              UserConnected.mainAgency = false;
            });
          }
        });
        if (employee.role == "ADMIN") {
          Navigator.popAndPushNamed(context, "/dg");
        } else if (employee.role == "COMPTABLE") {
          Navigator.popAndPushNamed(
              context, "/comptable");
        } else if (employee.role == "CAISSIER") {
          Navigator.popAndPushNamed(context, "/caissier");
        }
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((onError) async{
      close();
      if( await confirm(
          context,
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red,),
              Text("Authentification")
            ],
          ),
          content: const Text("Error d'authentification, nom d'utilisateur ou mot de passe incorrecte"),
          textOK: const Text("OK"),
          textCancel: const Text("Fermer")
      )){
        usernameFocus.requestFocus();
        controllerUsername.text = "";
        controllerPassword.text= "";
      }else{
        usernameFocus.requestFocus();
        controllerUsername.text = "";
        controllerPassword.text= "";
      }
    });
  }

}
