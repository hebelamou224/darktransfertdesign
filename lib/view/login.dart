import 'package:darktransfert/model/employee.dart';
import 'package:darktransfert/model/user.dart';
import 'package:darktransfert/repository/user_repository.dart';
import 'package:darktransfert/user_connect_info.dart';
import 'package:darktransfert/view/components/animation_delay.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late User userConnected;
  bool showVisibilityIcon = true;
  bool isLoading = false;

  late Future<List<User>> data;

  @override
  void initState() {
    super.initState();
    data = UserRepository.fetchUsers();
    print(data);
  }
  @override
  void dispose() {
    super.dispose();
    controllerUsername.dispose();
    controllerPassword.dispose();
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
                DelayAnimation(
                    delay: 2000,
                    child: Container(
                        height: 110,
                        width: 110,
                        child: const Image(
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
                    )),
                const SizedBox(
                  height: 20,
                ),
                DelayAnimation(
                    delay: 3500,
                    child: TextFormField(
                      controller: controllerPassword,
                      obscureText: showVisibilityIcon,
                      decoration:  InputDecoration(
                        suffixIcon: IconButton(onPressed: (){
                          setState(() {
                            showVisibilityIcon = !showVisibilityIcon;
                          });
                        }, icon: showVisibilityIcon ? const Icon(Icons.visibility_off): const Icon(Icons.visibility)),
                          label: const Text("Enter votre mot de pass*"),
                          border: const OutlineInputBorder()),
                     /* validator: (value) => (value!.isEmpty)
                          ? "Veuillez entrer le mot de pass"
                          : null,*/
                    )),
                const SizedBox(
                  height: 20,
                ),
                isLoading ? const CircularProgressIndicator(color: Colors.orange,) :
                DelayAnimation(
                    delay: 4000,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            Employee? userFinding;
                            userFinding = await UserRepository.findUser(
                                controllerUsername.text.trim(),
                                controllerPassword.text.trim());
                            if (userFinding != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${userFinding.username} vous êtes connnecté en tant que ${userFinding.role}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              //Save user connected information
                              UserConnected.identifyAgency = userFinding.identifyAgency;
                              UserConnected.fullname = userFinding.fullname;
                              UserConnected.password = userFinding.password;
                              UserConnected.role = userFinding.role;
                              UserConnected.telephone = userFinding.telephone;
                              UserConnected.dateRegister = userFinding.dateRegister;
                              UserConnected.dateConnected = DateTime.now().toString();

                              if (userFinding.role == "ADMIN") {
                                Navigator.popAndPushNamed(context, "/dg");
                              } else if (userFinding.role == "COMPTABLE") {
                                Navigator.popAndPushNamed(
                                    context, "/comptable");
                              } else if (userFinding.role == "CAISSIER") {
                                Navigator.popAndPushNamed(context, "/caissier");
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Vous n'avez de role pour être connecté ",
                                      style:
                                           TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Username ou Password incorrect",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            setState(() {
                              isLoading = false;
                            });
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
                            onPressed: () {},
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
}
