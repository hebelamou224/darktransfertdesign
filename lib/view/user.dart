import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Moriba Hebelamou",
          style: TextStyle(color: Colors.orange),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 200,
                width: 200,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://media.istockphoto.com/id/1476170969/fr/photo/portrait-dun-jeune-homme-pr%C3%AAt-%C3%A0-lemploi-business-concept.webp?b=1&s=170667a&w=0&k=20&c=y1iV8F--V8Q-L1YvZvAcA7Z0XeOkK4cmRUdeHz_gz_I="),
                ))
          ],
        ),
      ),
    );
  }
}
