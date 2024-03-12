import 'package:flutter/material.dart';

Container fieldFirstname(TextEditingController controller) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(),
          labelText: "Prenom*",
          hintText: "Entrer votre prenom"),
      controller: controller,
      validator: (value) =>
          (value == null || value == "") ? "Veuillez entrer le prenom" : null,
    ),
  );
}

Container fieldLastname(TextEditingController controller) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(),
          labelText: "Nom*",
          hintText: "Entrer votre nom"),
      controller: controller,
      validator: (value) =>
          (value == null || value == "") ? "Veuillez entrer le nom" : null,
    ),
  );
}

Container fieldTelephone(TextEditingController controller) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.phone),
          border: OutlineInputBorder(),
          labelText: "Telephone*",
          hintText: "Entrer votre numero"),
      controller: controller,
      validator: (value) =>
          (value == null || value == "") ? "Veuillez entrer le numero" : null,
    ),
  );
}

Container fieldEmail(TextEditingController controller) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.alternate_email),
          border: OutlineInputBorder(),
          labelText: "Email",
          hintText: "Entrer votre mail"),
      controller: controller,
      //validator: (value) => (value == null || value == "")? "Veuillez entrer le nom" : null,
    ),
  );
}

Container fieldPassword(TextEditingController controller) {
  bool obs = true;
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: obs,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.key),
          suffixIcon: IconButton(
              onPressed: () {
                obs = false;
                print("Icon suffix");
              },
              icon: const Icon(Icons.remove_red_eye_sharp)),
          border: OutlineInputBorder(),
          labelText: "Mot de passe*",
          hintText: "Entrer le mot de passe par defaut"),
      controller: controller,
      validator: (value) => (value == null || value == "")
          ? "Veuillez entrer le mot passe par defaut"
          : null,
    ),
  );
}

Container fieldAddress(TextEditingController controller) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      keyboardType: TextInputType.text,

      decoration: const InputDecoration(
          prefixIcon:  Icon(Icons.person_pin_circle),
          border: OutlineInputBorder(),
          labelText: "Addresse*",
          hintText: "Entrer l'adresse"),
      controller: controller,
      validator: (value) => (value == null || value == "")
          ? "Veuillez entrer l'addresse'"
          : null,
    ),
  );
}


// ignore: must_be_immutable
class FieldPassord extends StatefulWidget {
  TextEditingController _controller = TextEditingController();
  String message;
  FieldPassord(this._controller, this.message, {super.key});

  @override
  State<FieldPassord> createState() =>
      _FieldPassordState(this._controller, this.message);
}

class _FieldPassordState extends State<FieldPassord> {
  TextEditingController _controller = TextEditingController();
  String message;
  bool obs = true;
  IconData icondata = Icons.visibility_off;

  _FieldPassordState(this._controller, this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
          keyboardType: TextInputType.visiblePassword,
          obscureText: obs,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.key),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obs = !obs;
                      if (!obs)
                        icondata = Icons.visibility;
                      else
                        icondata = Icons.visibility_off;
                    });
                  },
                  icon: Icon(icondata)),
              border: const OutlineInputBorder(),
              labelText: message,
              hintText: "Entrer le mot de passe par defaut"),
          controller: _controller,
          validator: (value) => (value == "" || value == null)
              ? "Veuillez entrer le mot de pass par defaut"
              : null),
    );
  }
}

// ignore: must_be_immutable
class FieldFonction extends StatefulWidget {
  String value;
  FieldFonction(this.value, {super.key});

  @override
  State<FieldFonction> createState() => _FieldFonctionState(value);
}

class _FieldFonctionState extends State<FieldFonction> {
  String value;
  _FieldFonctionState(this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField(
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.sensor_occupied),
              hintText: "Veuillez choisir la fonction",
              labelText: "Fonction*",
              border: OutlineInputBorder()),
          items: const [
            DropdownMenuItem(
              child: Text("Caissier"),
              value: "caissier",
            ),
            DropdownMenuItem(
              child: Text("Comptable"),
              value: "comptable",
            ),
          ],
          validator: (value) {
            if (value == null)
              return "Veuillez selectionner la fonction";
            else
              return null;
          },
          onChanged: (value) {
            setState(() {
              value = value;
            });
          }),
    );
  }
}
