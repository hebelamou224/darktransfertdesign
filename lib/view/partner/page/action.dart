import 'package:flutter/material.dart';
import '../../../model/action.dart';
import '../../../service/action_service.dart';
import '../../../user_connect_info.dart';

class ActionEmployee extends StatefulWidget {
  final String title;
  final String identifyAgency;
  const ActionEmployee({
    super.key,
    required this.title,
    required this.identifyAgency
  });

  @override
  State<ActionEmployee> createState() => _ActionEmployeeState();
}

class _ActionEmployeeState extends State<ActionEmployee> {

  ActionService actionService = ActionService();
  late Future<List<ActionsConnected>?> actionsToDay ;

  Future<void> reloadData() async{
    setState(() {
      actionsToDay = actionService.findAllByIdentifyAgency(widget.identifyAgency);
    });
  }

  @override
  void initState() {
    super.initState();
    actionsToDay = actionService.findAllByIdentifyAgency(widget.identifyAgency);
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
            }else if(snapshot.data!.isEmpty){
              return const Center(child: Text("Aucune operation disponible", style: TextStyle(color: Colors.red),),);
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
