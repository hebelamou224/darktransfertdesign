import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import '../../../model/action.dart';
import '../../../service/action_service.dart';
import '../../../user_connect_info.dart';

class ActionEmployee extends StatefulWidget {
  final String date;
  final bool allAction;
  final String title;
  const ActionEmployee({super.key, required this.date, required this.allAction, required this.title});

  @override
  State<ActionEmployee> createState() => _ActionEmployeeState();
}

class _ActionEmployeeState extends State<ActionEmployee> {

  ActionService actionService = ActionService();
  late Future<List<ActionsConnected>?> actionsToDay ;
  late List<DateTime?> _dates ;

  Future<void> reloadData() async{
    setState(() {
      actionsToDay = actionService.findActionByEmployeeId(UserConnected.id, widget.date, widget.allAction);
    });
  }

  @override
  void initState() {
    super.initState();
    actionsToDay = actionService.findActionByEmployeeId(UserConnected.id, widget.date, widget.allAction);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title, style: const TextStyle(color: Colors.black),),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, color: Colors.redAccent, size: 30,),
        ),
        actions: [
          IconButton(
            onPressed: () async{
              DateTime? date =  await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2050),
                  cancelText: "Annuller",
                  confirmText: "Validé",
              );

              if(date != null){

                String dateSelected = "";
                date.month < 10 ?
                dateSelected = "${date.year}-0${date.month}-${date.day}" :
                dateSelected = "${date.year}-${date.month}-${date.day}";

                setState(() {
                  actionsToDay = actionService.findActionByEmployeeId(UserConnected.id, dateSelected, widget.allAction);
                });
              }
            },
            icon: const Icon(Icons.calendar_month, size: 30,),
          ),
          IconButton(
            onPressed: () {
            },
            icon: const Icon(Icons.print, color: Colors.orange, size: 30,),
          )
        ],
      ),
      body:  RefreshIndicator(
        color: Colors.orange,
        onRefresh: reloadData,
        child: FutureBuilder(
          future: actionsToDay,
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.orange,),
                    Text("Veuillez Patientez")
                  ],
                ),
              );
            }else if(snapshot.hasError){
              return const Center(child: Text("Error de chargements", style: TextStyle(color: Colors.red),),);
            }else if(!snapshot.hasData){
              return const Center(child: Text("Aucun element", style: TextStyle(color: Colors.red),),);
            }else{
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index){
                  return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 241, 241, 241),
                      ),
                      child: Card(
                        elevation: 2,
                        child: ListTile(
                          onTap: (){
                           // detailOperationForPrint(snapshot.data![index], context);
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data![index].typeAction, style: const TextStyle(fontSize: 20),),
                            ],
                          ),
                          subtitle: Text(snapshot.data![index].description),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("DATE"),
                              Text(snapshot.data![index].dateAction, style: const TextStyle(color: Colors.green),)
                            ],
                          ),
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.orange
                              ),
                            child: Center(
                              child: Text(snapshot.data![index].typeAction.substring(0,1)),
                            ),
                          ),

                        ),
                      )
                  );
                },
              );
            }
          },

        ),

      ),
    );
  }
}
