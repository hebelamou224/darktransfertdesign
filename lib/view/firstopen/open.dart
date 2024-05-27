
import 'package:flutter/material.dart';

class Opening extends StatelessWidget {
  final String title;
  final Color? color;
  final bool? error;
  const Opening({super.key, required this.title, this.color, this.error = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            error! ? Container() : const CircularProgressIndicator(color: Colors.orange,),
            Text(title)
          ],
        ),
      ),
    );
  }
}
