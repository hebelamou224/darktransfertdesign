import 'package:darktransfert/view/components/animation_delay.dart';
import 'package:darktransfert/view/firstopen/db_helper.dart';
import 'package:darktransfert/view/login.dart';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';


class FirstOpenApp extends StatefulWidget {
  const FirstOpenApp({super.key});

  @override
  State<FirstOpenApp> createState() => _FirstOpenAppState();
}

class _FirstOpenAppState extends State<FirstOpenApp> {
  @override
  Widget build(BuildContext context) {
    return const FirstOpen();
  }
}

class FirstOpen extends StatefulWidget {
  const FirstOpen({super.key});
  @override
  State<FirstOpen> createState() => _FirstOpenState();
}

class _FirstOpenState extends State<FirstOpen> {

  PageController pageController = PageController(initialPage: 0);
  DbHelper dbHelper = DbHelper();

   int activePage = 0;

  List<Widget> pages = [
      const PageOne(),
      const PageTwo(),
      const PageThree()
  ];

  @override
  void initState() {
    super.initState();
    dbHelper.savedSettings();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            onPageChanged: (value) {
              setState(() {
                activePage = value;
              });
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return pages[index % pages.length];
            }
          ),
          Positioned(
            bottom: 0,
              left: 0,
              right: 0,
              height: 100,
            child: Container(
              color: Colors.white,
            padding: const EdgeInsets.all(1),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: (){
                      setState(() {
                        if(activePage > 0){
                          activePage--;
                        }
                      });
                      pageController.animateToPage(activePage, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                    },
                    child: const Text("Précedent")
                ),
                (activePage == 2)?
                ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.of(context).push(
                          PageAnimationTransition(
                              page: const LoginPage(),
                              pageAnimationType: RightToLeftFadedTransition()
                          )
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white
                    ),
                    child: const Text("Connection"),
                ) :
                ElevatedButton(
                    onPressed: (){
                      setState(() {
                        if(activePage < 2){
                          activePage++;
                        }
                      });
                      pageController.animateToPage(activePage, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                    },
                    child: const Text("Suivant")
                ),
              ]
              /*List<Widget>.generate(pages.length,
                (index) =>  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                    },

                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: ( activePage == index) ? Colors.orange : Colors.black26,
                    ),
                  ),
                )
              ),*/
            ),
          ))
        ]
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 200, left: 70, right: 70),
        child:  const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DelayTopAnimation(
              delay: 1000,
                child: Image(image: AssetImage("assets/images/transfert_money.jpg"))
            ),
            SizedBox(height: 100,),
            DelayTopAnimation(
              delay: 1500,
              child: Text(
                "Dark Transfert une application de transfert d'argent main à main",
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 200, left: 70, right: 70),
          child: const Column(
           children: [
             DelayTopAnimation(
               delay: 1000,
                 child: Image(image: AssetImage("assets/images/all_position.jpg"))
             ),
             SizedBox(height: 100,),
             DelayTopAnimation(
               delay: 1500,
                 child: Text("Peut importe votre position vous receverez votre argent avec rapidité, fiabilité et sécurisé")
             )
           ],
          ),
        ),
      );
  }
}

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 150, left: 70, right: 70),
        child: const Column(
          children: [
            DelayTopAnimation(
              delay: 1000,
                child: Image(image: AssetImage("assets/images/why_chose_us.jpg"))
            ),
            SizedBox(height: 70,),
            DelayTopAnimation(
              delay: 1500,
              child: ListTile(
                title: Text("Nous somme fiable"),
                leading: Icon(Icons.check_circle, color: Colors.green,),
              ),
            ),
            DelayTopAnimation(
              delay: 2000,
              child: ListTile(
                title: Text("Nous somme rapide"),
                leading: Icon(Icons.check_circle, color: Colors.green,),
              ),
            ),
            DelayTopAnimation(
              delay: 2500,
              child: ListTile(
                title: Text("Toute nos transaction sont sécurisées"),
                leading: Icon(Icons.check_circle, color: Colors.green,),
              ),
            )
          ],
        ),
      ),
    );
  }
}