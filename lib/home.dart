
import 'package:darktransfert/view/agency/persone.dart';
import 'package:darktransfert/view/components/drawer_menu.dart';
import 'package:flutter/material.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeState();
}

class _HomeState extends State<HomeMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Agence principal",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(onPressed: (){

            showDialog(context: context, builder: (builder)=>
              AlertDialog(
                title: const Text("Deconnexion"),
                content: Text("Voullez vous deconnectez ?"),
                actions: [
                  TextButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child: const Text("NON",style: TextStyle(color: Colors.red),)),
                  TextButton(onPressed: (){
                    Navigator.popAndPushNamed(context, "/login");
                  }, child: const Text("OUI"))
                ],
              )
            );

            //Navigator.popAndPushNamed(context, "/login");
          }, icon: const Icon(Icons.logout))
        ],
      ),
      drawer: const NavigationDrawers(),
      body: mainHome(),
    );
  }

  Container mainHome() {
    return Container(
      height: double.infinity,
      color: const Color.fromARGB(255, 241, 241, 241),
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cardOfSolde(),
              const Text(
                "Mes services",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              separetedSize(),
              buttonRowOne(),
              separetedSize(),
              buttonRowTwo(),
              separetedSize(),
              rowOfPage(),
              separetedSize(),
              myPatner(),
              separetedSize(),
              rowOfPage(),
              separetedSize(),
              myPatner(),

            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView myPatner() {
    return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 70,
                          width: 70,
                          child: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRx0CIy3mIbpe2nuLRfK5xxPcwxmTvXjJsBNw&usqp=CAU")),
                        ),
                        const Text(
                          "Moriba",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    const SizedBox(width: 15,),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 70,
                          width: 70,
                          child: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGeg0a5wyDchHuY6tgbDkWKNLYiS7vHn4w4g&usqp=CAU")),
                        ),
                        const Text(
                          "Antoine",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    const SizedBox(width: 15,),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 70,
                          width: 70,
                          child: const  CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZd8IFhFAzVB_AdUsDwZMmRzafOAhzsQ_JlQ&usqp=CAU")),
                        ),
                        const Text(
                          "Foromo",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    const SizedBox(width: 15,),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 70,
                          width: 70,
                          child: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbIhi9l4npCGPNWMAc6szDbxp75kjB3c0R5w&usqp=CAU")),
                        ),
                        const Text(
                          "Fatoumata",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    const SizedBox(width: 15,),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 70,
                          width: 70,
                          child: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRA1af5Ah2OAIP2yd5c6dRKv86-oWMrz4Kd8A&usqp=CAU")),
                        ),
                        const  Text(
                          "Bernard",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                  ],
                ),
              );
  }

  SizedBox separetedSize() {
    return const SizedBox(
      height: 20,
    );
  }

  Row rowOfPage() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Nos Partnaires", style: TextStyle(fontWeight: FontWeight.w700)),
        Text(
          "VOIR PLUS",
          style: TextStyle(
              color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Container cardOfSolde() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text(
                    "500255.6655 FGN",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Dernier transaction"),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "VOIR PLUS",
                  style: TextStyle(color: Colors.orange, fontSize: 10),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.orange),
                        child: const Center(
                          child: Text(
                            "AG",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Agance Moriba",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Depot",
                        style: TextStyle(fontSize: 10),
                      )
                    ],
                  )
                ],
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "555555.558 FGN",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "18h 30m",
                    style: TextStyle(fontSize: 9),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Row buttonRowOne() {
    return Row(
      children: [
        Expanded(
            child: InkWell(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.storefront,
                  size: 40,
                  color: Colors.orange,
                ),
                Text("Agences", style: TextStyle(fontSize: 11))
              ],
            ),
          ),
          onTap: () {
            //Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> const Personnel()));
          },
        )),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: InkWell(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.personal_injury,
                  size: 40,
                  color: Colors.orange,
                ),
                Text("Partenaire", style: TextStyle(fontSize: 11))
              ],
            ),
          ),
        )),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: InkWell(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.groups,
                  size: 40,
                  color: Colors.orange,
                ),
                Text("Personnels", style: TextStyle(fontSize: 11))
              ],
            ),
          ),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> const Personnel()));
          },
        )),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: InkWell(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.paid,
                  size: 40,
                  color: Colors.orange,
                ),
                Text(
                  "Comptablité",
                  style: TextStyle(fontSize: 11),
                )
              ],
            ),
          ),
        )),
      ],
    );
  }


  Row buttonRowTwo() {
    return Row(
      children: [
        Expanded(
            child: InkWell(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.euro,
                  size: 40,
                  color: Colors.orange,
                ),
                Text("Caisiers", style: TextStyle(fontSize: 11))
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> const Personnel()));
          },
        )),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: InkWell(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.settings,
                  size: 40,
                  color: Colors.orange,
                ),
                Text("Parametre", style: TextStyle(fontSize: 11))
              ],
            ),
          ),
        )),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: InkWell(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.folder_delete,
                  size: 40,
                  color: Colors.orange,
                ),
                Text("Corbeilles", style: TextStyle(fontSize: 11))
              ],
            ),
          ),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> const Personnel()));
          },
        )),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: InkWell(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.manage_history,
                  size: 40,
                  color: Colors.orange,
                ),
                Text(
                  "Historique",
                  style: TextStyle(fontSize: 11),
                )
              ],
            ),
          ),
        )),
      ],
    );
  }
}
