import 'package:flutter/material.dart';


class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: NavigationDrawers(),
      appBar: AppBar(
        title: const Text("Favorite"),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }
}
