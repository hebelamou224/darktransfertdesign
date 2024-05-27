import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/model/employee.dart';
import 'package:darktransfert/service/employee_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kdialogs/kdialogs.dart';
import 'package:url_launcher/url_launcher_string.dart';


class DetailsEmployee extends StatefulWidget {
  final Employee employee;
  const DetailsEmployee({super.key, required this.employee });

  @override
  State<DetailsEmployee> createState() => _DetailsEmployeeState();
}

class _DetailsEmployeeState extends State<DetailsEmployee> {

  TextEditingController resetPasswordController = TextEditingController();
  FocusNode focusNodePassword = FocusNode();
  bool focusPassword = false;
  EmployeeService employeeService = EmployeeService();

  final style = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500
  );
  final style1 = const TextStyle(
    fontSize: 16,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.employee.fullname),
        leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 30,),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.orange,
                  ),
                  child: Center(
                    child: Text(widget.employee.fullname.substring(0,1),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 120,
                          fontWeight: FontWeight.bold
                      ) ,
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.employee.username,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    prefixIcon: const Icon(Icons.person_pin),
                    border: const OutlineInputBorder(),
                    labelText: "Username",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.employee.fullname,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    prefixIcon: const Icon(Icons.perm_identity),
                    border: const OutlineInputBorder(),
                    labelText: "Nom complet",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.employee.address,
                keyboardType: TextInputType.multiline,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    prefixIcon: const Icon(Icons.location_on_outlined,),
                    border: const OutlineInputBorder(),
                    labelText: "Addresse",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.employee.telephone,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    prefixIcon: IconButton(
                      icon: const Icon(CupertinoIcons.phone,),
                      onPressed: (){
                        launchUrlString("tel:${widget.employee.telephone}");
                      },
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: (){
                        launchUrlString("sms:${widget.employee.telephone}");
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: "Telephone",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.employee.dateRegister,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    prefixIcon: const Icon(Icons.calendar_month_outlined),
                    border: const OutlineInputBorder(),
                    labelText: "Date d'enregistrement",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.employee.role,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    prefixIcon: const Icon(Icons.work_outline),
                    border: const OutlineInputBorder(),
                    labelText: "Role / Fonction",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: resetPasswordController,
                focusNode: focusNodePassword,
                decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.6))
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2)
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: (){
                        focusNodePassword.unfocus();
                        showBottomSheet();
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: "Reinitialisé le mot de pass",
                    hintText: "Entrer un nouveau mot de passe",
                    labelStyle: const TextStyle(color: Colors.orange, fontSize: 20)
                ),
                onChanged: (value){
                  setState(() {
                    focusPassword = true;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: focusPassword ? null : FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, "/dg", (route) => false);
        },
        tooltip: "Acceuil",
        backgroundColor: Colors.orange,
        child: const Icon(Icons.home_outlined, color: Colors.white,),
      ),
    );
  }

  showBottomSheet(){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Form(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: (){Navigator.pop(context);},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Annuler"),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                      onPressed: () async{
                        //Navigator.pop(context);
                        if(resetPasswordController.text != ""){
                          if(await confirm(
                            context,
                            title: const Row(
                              children: [
                                Icon(Icons.info, color: Colors.green,),
                                SizedBox(width: 8,),
                                Text("Confirmation"),
                              ],
                            ),
                            content: const Text("Confirmez-vous la reinitialisation du mot de passe pour cet employé ?"),
                            textOK: const Text("OUI"),
                            textCancel: const Text("NON"),
                          )){
                          }else{
                            return;
                          }
                          widget.employee.password = resetPasswordController.text;
                          final close = await showKDialogWithLoadingMessage(context, message: "Veuillez patienter" );
                          employeeService.updateInformation(widget.employee)
                          .then((employee) async{
                            close();
                            if(employee != null){
                              if(await confirm(
                                context,
                                title: const Row(
                                  children: [
                                    Icon(Icons.check_circle, size: 40, color: Colors.green,
                                    ),
                                    Text("Information"),
                                  ],
                                ),
                                content: const Text("Modification effectuée avec succès"),
                                textOK: const Text("OK"),
                                textCancel: const Text("Fermer"),
                              )){
                                setState(() {
                                  focusPassword = false;
                                });
                              }{
                                setState(() {
                                  focusPassword = false;
                                });
                              }
                              Navigator.pop(context);
                            }
                          }, onError: (error){
                            close();
                            showDialog(
                                context: context,
                                builder: (builder){
                                  return  AlertDialog(
                                    icon: const Icon(Icons.close, color: Colors.red, size: 50,),
                                    title: const Text("Error"),
                                    content: const Text("Une erreur s'est produite l'ors de la motification, veuillez reprendre le process"),
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
                        }else{
                          showDialog(
                              context: context,
                              builder: (builder){
                                return  AlertDialog(
                                  icon: const Icon(Icons.close, color: Colors.red, size: 50,),
                                  title: const Text("Error"),
                                  content: const Text("Veuillez entrer un mot de passe"),
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
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black54,
                        side: const BorderSide(color: Colors.orange, width: 2),
                      ),
                      child: const Text("Modifier")
                  ),
                )
              ],
            )
          );
        }
    );
  }

}
