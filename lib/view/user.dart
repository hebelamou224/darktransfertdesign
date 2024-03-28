import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/model/employee.dart';
import 'package:darktransfert/service/employee_service.dart';
import 'package:darktransfert/user_connect_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  final _formKey = GlobalKey<FormState>();

  bool isEditFullname = false;
  bool istEditAddress = false;
  bool isEditPhone = false;
  bool isEditPassword = false;
  bool showEditPasswordNew = false;
  bool isUpdate = false;
  bool processModified = false;
  bool obscureText = true;

  TextEditingController fullnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordNewController = TextEditingController();

  FocusNode fullnameFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  EmployeeService employeeService = EmployeeService();

  void isUpdateInformation(){
    if(fullnameController.text != UserConnected.fullname ||
        addressController.text != UserConnected.address ||
        phoneController.text != UserConnected.telephone ||
        passwordNewController.text != UserConnected.password){
      setState(() {
        isUpdate = true;
      });
    }else{
      setState(() {
        isUpdate = false;
      });
    }
  }
  void isPasswordUpdate(){
    if(fullnameController.text == UserConnected.fullname ||
        addressController.text == UserConnected.address ||
        phoneController.text == UserConnected.telephone){
      setState(() {
        isUpdate = false;
      });
    }else{
      setState(() {
        isUpdate = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fullnameController.text = UserConnected.fullname;
    addressController.text = UserConnected.address;
    phoneController.text = UserConnected.telephone;
  }

  @override
  void dispose() {
    super.dispose();
    fullnameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordNewController.dispose();
    fullnameFocus.dispose();
    addressFocus.dispose();
    phoneFocus.dispose();
    passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text(
          UserConnected.fullname,
          style: const TextStyle(color: Colors.orange),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.orange,
                      //backgroundImage: const AssetImage("assets/images/logo.png"),
                      child: Center(
                        child: Text(UserConnected.letterOfName(), style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 10, top: 40),
                    child: TextFormField(
                      readOnly: true,
                      initialValue: UserConnected.username,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange)
                          ),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.orange),
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    )
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      focusNode: fullnameFocus,
                      readOnly: !isEditFullname,
                      controller: fullnameController,
                      onChanged: (value){
                        isUpdateInformation();
                      },
                      decoration: InputDecoration(
                          labelText: "Nom complet",
                          hintText: "Veuillez entre votre nom complet",
                          prefixIcon: const Icon(Icons.person_pin),
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                isEditFullname = !isEditFullname;
                                if(isEditFullname){
                                  fullnameFocus.requestFocus();
                                }else{
                                  fullnameFocus.unfocus();
                                  fullnameController.text = UserConnected.fullname;
                                  isUpdateInformation();
                                }
                              });
                            },
                            icon: !isEditFullname ? const Icon(Icons.edit, size: 15, color: Colors.orange,):
                              const Icon(Icons.close, size: 15, color: Colors.red,),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange)
                          ),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.orange),
                              borderRadius: BorderRadius.circular(10)
                          ),
                      ),
                      validator: (value){
                        if(isEditFullname){
                          if(value == "") {
                            return "Veuillez entrer un nom complet";
                          }
                          return null;
                        }
                        return null;
                      },
                    )
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      readOnly: !istEditAddress,
                      controller: addressController,
                      focusNode: addressFocus,
                      onChanged: (value){
                        isUpdateInformation();
                      },
                      decoration: InputDecoration(
                          labelText: "Addresse",
                          hintText: "Veuillez entre votre addresse",
                          prefixIcon: const Icon(Icons.location_on_outlined),
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                istEditAddress = !istEditAddress;
                                if(istEditAddress){
                                  addressFocus.requestFocus();
                                }else{
                                  addressFocus.unfocus();
                                  addressController.text = UserConnected.address;
                                  isUpdateInformation();
                                }
                              });
                            },
                            icon: !istEditAddress ? const Icon(Icons.edit, size: 15, color: Colors.orange,):
                            const Icon(Icons.close, size: 15, color: Colors.red,),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange)
                          ),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.orange),
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                      validator: (value){
                        if(istEditAddress){
                          if(value == ""){
                            return "Veuillez entre une addresse";
                          }
                          return null;
                        }
                        return null;
                      },
                    )
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      readOnly: !isEditPhone,
                      controller: phoneController,
                      focusNode: phoneFocus,
                      onChanged: (value){
                        isUpdateInformation();
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Telephone",
                          hintText: "Enter un numero de telephone",
                          prefixIcon: const Icon(Icons.phone),
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                isEditPhone = !isEditPhone;
                                if(isEditPhone){
                                  phoneFocus.requestFocus();
                                }else{
                                  phoneFocus.unfocus();
                                  phoneController.text = UserConnected.telephone;
                                  isUpdateInformation();
                                }
                              });
                            },
                            icon: !isEditPhone ? const Icon(Icons.edit, size: 15, color: Colors.orange,):
                            const Icon(Icons.close, size: 15, color: Colors.red,),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange)
                          ),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.orange),
                              borderRadius: BorderRadius.circular(10)
                          ),
                      ),
                      validator: (value){
                        if(isEditPhone){
                          if(value == ""){
                            return "Veuillez votre numero de telephone";
                          }
                          return null;
                        }
                       return null;
                      },
                    )
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      readOnly: !isEditPassword,
                      controller: passwordController,
                      focusNode: passwordFocus,
                      onChanged: (value){
                        isUpdateInformation();
                      },
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: "Ancien mot de pass",
                        hintText: "Enter l'ancien mot de passe",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              isEditPassword = !isEditPassword;
                              if(isEditPassword){
                                passwordFocus.requestFocus();
                                showEditPasswordNew = true;
                              }else{
                                passwordFocus.unfocus();
                                showEditPasswordNew = false;
                                passwordNewController.text = "";
                                !showEditPasswordNew ? passwordController.text = "" : null ;
                                isUpdateInformation();
                              }
                            });
                          },
                          icon: !isEditPassword ? const Icon(Icons.edit, size: 15, color: Colors.orange,):
                          const Icon(Icons.close, size: 15, color: Colors.red,),
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange)
                        ),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      validator: (value){
                        if(isEditPassword){
                          if(UserConnected.password != ""){
                            if(value == ""){
                              return "Veuillez votre ancien mot de passe";
                            }else if(value != UserConnected.password){
                              return "Votre ancien mot de passe est incorrect";
                            }
                            return null;
                          }else{
                            return null;
                          }
                        }else{
                          setState(() {
                            passwordController.text = "";
                          });
                          return null;
                        }
                      },
                    )
                ),
                showEditPasswordNew ?
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: passwordNewController,
                      onChanged: (value){
                        isUpdateInformation();
                      },
                      obscureText: obscureText,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "***************",
                        labelText: "Nouveau mot de passe",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                          onPressed: (){
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange)
                        ),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      validator: (value){
                        if(showEditPasswordNew){
                          if(value == ""){
                            return "Veuillez votre nouveau mot de passe";
                          }else if(value == UserConnected.password){
                            return "Veuillez entrer un mot de passe different de l'ancien";
                          }
                          return null;
                        }
                        return null;
                      },
                    )
                ):Container(),
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      readOnly: true,
                      initialValue: UserConnected.role,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.sensor_occupied),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange)
                          ),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.orange),
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    )
                ),
                processModified ? const Center(
                  child: CircularProgressIndicator(color: Colors.orange,),
                ) :
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: !isUpdate ? null : () async{
                        if(_formKey.currentState!.validate()){
                          if(await confirm(
                              context,
                              title: const Row(
                                children: [
                                  Icon(Icons.info, color: Colors.green,),
                                  Text("Confirmation")
                                ],
                              ) ,
                              content: const Text("Vous confirmer la modification des informations ?"),
                              textOK: const Text("OUI"),
                              textCancel: const Text("NON")
                          )){

                          }else{
                            return;
                          }
                          setState(() {
                            processModified = true;
                          });
                          Employee employeeUpdate = Employee(
                              id: UserConnected.id,
                              username: UserConnected.username,
                              fullname: fullnameController.text,
                              address: addressController.text,
                              telephone: phoneController.text,
                              dateRegister: UserConnected.dateRegister,
                              role: UserConnected.role,
                              identifyAgency: UserConnected.identifyAgency,
                              password: showEditPasswordNew ? passwordNewController.text : UserConnected.password
                          );
                          await employeeService.updateInformation(employeeUpdate).then((employee) async{
                            if(employee != null){
                              if(await confirm(
                                  context,
                                  title: const Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green,),
                                      Text("Modification")
                                    ],
                                  ) ,
                                  content: const Text("Modification effectué avec succès"),
                                  textOK: const Text("D'accord"),
                                  textCancel: const Text("Fermer")
                              )){
                                setState(() {
                                  isEditFullname = false;
                                  isEditPassword = false;
                                  isEditPhone = false;
                                  istEditAddress = false;
                                  showEditPasswordNew = false;

                                  UserConnected.fullname = employee.fullname;
                                  UserConnected.address = employee.address;
                                  UserConnected.telephone = employee.telephone;
                                  UserConnected.password = employee.password;

                                  passwordNewController.text = "";
                                  passwordController.text = "";
                                  fullnameController.text = employee.fullname;
                                  addressController.text = employee.address;
                                  phoneController.text = employee.telephone;

                                  //Redirect home page person
                                  //Navigator.pop(context);
                                });
                              }
                            }else{
                              if(await confirm(
                                  context,
                                  title: const Row(
                                    children: [
                                      Icon(Icons.close, color: Colors.red,),
                                      Text("Error modification")
                                    ],
                                  ) ,
                                  content: const Text("Error de modification des informations, veuillez verifier les informations ou la connection de votre telephone au serveur"),
                                  textOK: const Text("D'accord"),
                                  textCancel: const Text("Fermer")
                              )){

                              }
                            }
                            setState(() {
                              processModified = false;
                            });
                          }).catchError((onError) async{
                            if(await confirm(
                                context,
                                title: const Row(
                                  children: [
                                    Icon(Icons.close, color: Colors.red,),
                                    Text("Error modification")
                                  ],
                                ) ,
                                content: const Text("Error de modification des informations, veillez reprendre merci!"),
                                textOK: const Text("D'accord"),
                                textCancel: const Text("Fermer")
                            )){

                            }
                            setState(() {
                              processModified = false;
                            });
                          });
                        }
                      },

                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 18)
                      ),
                      child:  const Text("Savegarder la motification", style: TextStyle(color: Colors.white),),
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
