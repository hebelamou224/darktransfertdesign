import 'package:darktransfert/model/user.dart';
import 'package:darktransfert/repository/user_repository.dart';
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
  late User userConnected ;
  late Future<List<User>> data;

  @override
  void initState() {
    super.initState();
    data = UserRepository.fetchUsers();
    print(data);
    userConnected = User(
        id: 0,
        username: "",
        fullname: "",
        photo: "",
        password: "",
        role: "",
        telephone: "");
  }
  void initUserConnect(){
    userConnected.username = "";
    userConnected.fullname = "";
    userConnected.password = "";
    userConnected.role = "";
    userConnected.telephone = "";
  }
  void auth() async{
    User userFinding =  await UserRepository.findUser(controllerUsername.text, controllerPassword.text);
    setState(()  {
      initUserConnect();
      userConnected = userFinding;
    });
  }


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
                            auth();
                            
                            if(userConnected.username == controllerUsername.text &&
                            userConnected.password == controllerPassword.text){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${userConnected.username} vous êtes connnecté', style: TextStyle(color: Colors.white),),
                                  backgroundColor: Colors.orange,
                                ),
                              );

                              if (userConnected.role == "ADMIN") {
                                Navigator.popAndPushNamed(context, "/dg");
                              }else if(userConnected.role == "COMPTABLE"){
                                Navigator.popAndPushNamed(context, "/comptable");
                              }else if(userConnected.role == "COMPTABLE"){
                                Navigator.popAndPushNamed(context, "/CAISSIER");
                              }

                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Username ou Password incorrect", style: TextStyle(color: Colors.white),),
                                  backgroundColor: Colors.red,
                                ),
                              );
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
