import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ListOfTransaction extends StatefulWidget {
  const ListOfTransaction({super.key});

  @override
  State<ListOfTransaction> createState() => _ListOfTransactionState();
}

class _ListOfTransactionState extends State<ListOfTransaction> {

  final controllerSearchTransaction = TextEditingController();
  final data = [
    {
      "nom":"Moriba",
      "prenom":"Hebelamou",
      "description": "Un depot dans la caisse",
      "type": "DP"
    },
    {
      "nom":"Moriba",
      "prenom":"Hebelamou",
      "description": "Un depot dans la caisse",
      "type": "RT"
    },
    {
      "nom":"Moriba",
      "prenom":"Hebelamou",
      "description": "Un depot dans la caisse",
      "type": "DP"
    },
    {
      "nom":"Moriba",
      "prenom":"Hebelamou",
      "description": "Un depot dans la caisse",
      "type": "DP"
    },
    {
      "nom":"Moriba",
      "prenom":"Hebelamou",
      "description": "Un depot dans la caisse",
      "type": "RT"
    },
    {
      "nom":"Moriba",
      "prenom":"Hebelamou",
      "description": "Un depot dans la caisse",
      "type": "DP"
    },
    {
      "nom":"Moriba",
      "prenom":"Hebelamou",
      "description": "Un depot dans la caisse",
      "type": "DP"
    },
    {
      "nom":"Moriba",
      "prenom":"Hebelamou",
      "description": "Un depot dans la caisse",
      "type": "RT"
    },
    {
      "nom":"Moriba",
      "prenom":"Hebelamou",
      "description": "Un depot dans la caisse",
      "type": "DP"
    }
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Liste des transaction",
          style: TextStyle(color: Colors.orange),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 241, 241, 241),
        leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 30,),
            onPressed: () {
              Navigator.pop(context);
              
            }),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index){
          return Container(
           // margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 241, 241, 241),
            ),
            child: Card(
              elevation: 5,
              child: ListTile(
                onTap: (){
                  detailsOfTransaction();
                },
                title: Text("Agence de ${data[index]["nom"]}"),
                subtitle: Text("${data[index]["description"]}"),
                trailing: IconButton(onPressed: (){
                  // swho the information
                  detailsOfTransaction();
                },
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: (data[index]["type"] == "DP")? Colors.green : Colors.orange
                  ),
                  child: Center(
                    child: Text("${data[index]["type"]}"),
                  ),
                ),
              ),
            ),
          );
        },

      ),
    );
  }

  Future<dynamic> detailsOfTransaction(){
    return showDialog(
        context: context,
        builder: (builder) =>
            AlertDialog(
              title: const Text("Details de la transaction",
                style: TextStyle(fontWeight: FontWeight.w700),),
              content: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Agence de matoto"),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("Nom de l'expediteur: ",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),),
                      Text("Moriba Hebelamou",
                        style: TextStyle(fontSize: 10),)
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Nom du destinateur: ",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),),
                      Text("Aly keita", style: TextStyle(fontSize: 10),)
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Montant: ",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),),
                      Text("2838.990 FGN",style: TextStyle(fontSize: 10),)
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Type: ",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),),
                      Text("Depôt", style: TextStyle(fontSize: 10),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Date: ", style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 12),),
                      Text("09-03-2024", style: TextStyle(fontSize: 10),),
                      Text("à 10h 33min")
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                      //generatePDF();
                    },
                    child: const Text("Fermer",
                      style: TextStyle(color: Colors.red),)
                ),
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                      _displayPDF();
                      //generatePDF();
                      //_createPDF();
                    },
                    child: const Text("Imprimer")
                )
              ],
            )
    );
  }

  void _displayPDF() {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context){
          return pw.Center(
            child: pw.Text(
              "Print the document"
            )
          );
        }
      )
    );

    Navigator.push(context, MaterialPageRoute(builder:

        (context)=> PreviewScreen(doc: doc),

    ));

  }

}

void generatePDF() async{
  const title = "Generated pdf";
  await Printing.layoutPdf(onLayout: (format)=> _generatedPDF(format, title));
}

Future<Uint8List> _generatedPDF(PdfPageFormat format, String title) async{
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.nunitoExtraLight();

  pdf.addPage(
    pw.Page(
      pageFormat: format,
      build: (context){
        return pw.Column(
          children: [
            pw.SizedBox(
              width: double.infinity,
              child: pw.FittedBox(
                child: pw.Text(title, style: pw.TextStyle(font: font))
              )
            ),
            pw.SizedBox(height: 20),
            pw.Flexible(child: pw.FlutterLogo())
          ]
        );
      }
    )
  );
  return pdf.save();
}

void _createPDF() async{
  final doc = pw.Document();

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context){
        return pw.Center(
          child: pw.Text("Demo printing")
        );
      }
    )
  );
 // doc.save();
}


class PreviewScreen extends StatelessWidget {

  final pw.Document doc;

  const PreviewScreen({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Impression preview"),
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back_outlined),),
        centerTitle: true,
      ),
      body: PdfPreview(
        build: (format) => doc.save(),
        allowSharing: true,
        allowPrinting: true,
        enableScrollToPage: true,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: "recu_transaction.dpf",
      ),
    );
  }

}
