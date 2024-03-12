import 'package:darktransfert/view/components/animation_delay.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        elevation: 0,
        centerTitle: true,
        title: const Text("Authentification", style: TextStyle(color: Colors.orange, fontSize: 24),),
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
                DelayAnimation(
                    delay: 2000,
                    child: Container(
                        height: 110,
                        width: 110,
                        child: const Image(
                            image: AssetImage("assets/images/logo.png")))
                ),

                const SizedBox(
                  height: 30,
                ),
                const DelayAnimation(
                    delay: 2500,
                    child:  Text(
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
                      controller: controllerUsername,
                      decoration: const InputDecoration(
                          focusColor: Colors.orange,
                          fillColor: Colors.orange,
                          label: Text("Enter le nom d'utilisateur"),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange))),
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
                      controller: controllerPassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                          label: Text("Enter votre mot de pass*"),
                          border: OutlineInputBorder()),
                      validator: (value) => (value!.isEmpty)
                          ? "Veuillez entrer le mot de pass"
                          : null,
                    )
                ),
                const SizedBox(height: 20,),
                DelayAnimation(
                    delay: 4000,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (controllerUsername.text == "admin" &&
                                controllerPassword.text == "admin") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Authentification validé"),
                                backgroundColor: Colors.green,
                              ));
                              Navigator.popAndPushNamed(context, "/dg");
                            }else if(controllerUsername.text == "comptable" &&
                                controllerPassword.text == "comptable"){
                              Navigator.popAndPushNamed(context, "/comptable");
                            }else if(controllerUsername.text == "caissier" &&
                                controllerPassword.text == "caissier"){
                              Navigator.popAndPushNamed(context, "/caissier");

                            }
                            else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Nom d'utilisateur ou mot de pass incorrect"),
                                backgroundColor: Colors.red,
                              ));
                            }

                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            backgroundColor: Colors.orange),
                        child: const Text("Se conecter"),
                      ),
                    )
                ),
                DelayAnimation(
                    delay: 5000,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: (){}, child: Text("Mot de pass oublié ?"))
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
