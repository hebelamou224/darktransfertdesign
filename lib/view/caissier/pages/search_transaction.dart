import 'dart:typed_data';
import 'dart:ui';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:darktransfert/model/customer.dart';
import 'package:darktransfert/service/customer_service.dart';
import 'package:darktransfert/view/caissier/pages/withdrawal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../components/print.dart';

class SearchTransaction extends StatefulWidget {
  final String? initialValue;
  const SearchTransaction({this.initialValue,super.key});

  @override
  State<SearchTransaction> createState() => _SearchTransactionState();
}

class _SearchTransactionState extends State<SearchTransaction> {

  final searchOperationController = TextEditingController();
  CustomerService customerService = CustomerService();
  late Future<List<Customer>?> allOperation ;

  @override
  void initState() {
    super.initState();
    if(widget.initialValue != null){
      searchOperationController.text = widget.initialValue!;
      allOperation = customerService.findAllByFullnameContainingOrFullnameReceverContainingOrderByOperationDateModifyDesc(searchOperationController.text);
    }else{
      allOperation = customerService.findAllByFullnameContainingOrFullnameReceverContainingOrderByOperationDateModifyDesc("");
    }
  }
  @override
  void dispose() {
    super.dispose();
    searchOperationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recherche",
          style: TextStyle(color: Colors.orange),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,//const Color.fromARGB(255, 241, 241, 241),
        leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 30,),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            child: TextFormField(
              onEditingComplete: (){
                setState(() {
                  allOperation = customerService.findAllByFullnameContainingOrFullnameReceverContainingOrderByOperationDateModifyDesc(searchOperationController.text);
                });
              },
              onChanged: (value){
                setState(() {
                  allOperation = customerService.findAllByFullnameContainingOrFullnameReceverContainingOrderByOperationDateModifyDesc(value);
                });
              },
              autofocus: true,
              controller: searchOperationController,
              decoration: InputDecoration(
                  hintText: "Recherche par nom ou code transaction",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: (){
                      searchOperationController.text = "";
                    },
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.orange, width: 2.0)
                  ),
                  border: const OutlineInputBorder()
              ),
            ),
          ),
          FutureBuilder(
              future: allOperation,
              builder: (context,snapshot){
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
                  return Center(child: Text("Aucun resultat pour: ${searchOperationController.text}", style: const TextStyle(color: Colors.red),),);
                }else{
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index){
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              onLongPress: (){
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                    PageAnimationTransition(
                                        page: WithDrawalAgencyCustome(code: snapshot.data![index].identify),
                                        pageAnimationType: RightToLeftFadedTransition()
                                    )
                                );
                              },
                              onTap: (){
                                detailOperationForPrint(snapshot.data![index], context);
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data![index].status! ? snapshot.data![index].fullnameRecever : snapshot.data![index].fullname, style: const TextStyle(fontSize: 20),),
                                  Row(
                                    children: [
                                      Text('Code: ${snapshot.data![index].identify}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),),
                                      IconButton(
                                          onPressed: (){
                                            String code = snapshot.data![index].identify;
                                            Clipboard.setData(ClipboardData(text : code))
                                                .then((value){
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("Code : $code copié"),
                                                    backgroundColor: Colors.green,
                                                  )
                                              );
                                            });
                                          },
                                          icon: const Icon(Icons.copy_rounded, size: 17,)
                                      )
                                    ],
                                  )
                                ],
                              ),
                              subtitle: Text(snapshot.data![index].status! ? "Retrait effectué le ${snapshot.data![index].dateModify}" : "Depôt effectué le ${snapshot.data![index].dateModify}"),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("STATUS"),
                                  snapshot.data![index].status! ?
                                  const Icon(Icons.arrow_circle_up_outlined, color: Colors.green, size: 15) :
                                  const Icon(Icons.arrow_circle_down_outlined, color: Colors.orange, size: 15,),
                                  snapshot.data![index].status! ?
                                  const Text("Validé", style: TextStyle(color: Colors.green),):
                                  const Text("Encours", style: TextStyle(color: Colors.orange))
                                ],
                              ),
                              leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: (snapshot.data![index].status! ? Colors.orange : Colors.green
                                  ),
                                ),
                                child: Center(
                                  child: Text(snapshot.data![index].status! ? "R" : "D"),
                                ),
                              ),

                            ),
                          );
                        }
                    ),
                  );
                }
              }
          ),
        ],
      ),
    );
  }

  Future<void> detailOperationForPrint(Customer customer, BuildContext context) async{
    if(await confirm(
        context,
        title:  Text("Reçu de ${ customer.status! ? customer.fullnameRecever : customer.fullname}"),
        content: Column(
          children: [
            const Text("EXPEDITEUR:", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green)),
            Row(
              children: [
                const Text("NOM: ", style: TextStyle(fontWeight: FontWeight.w500),),
                Text(customer.fullname)
              ],
            ),
            Row(
              children: [
                const Text("TELEPHONE: ", style: TextStyle(fontWeight: FontWeight.w500),),
                Text(customer.telephone)
              ],
            ),
            Row(
              children: [
                const Text("ADDRESSE: ", style: TextStyle(fontWeight: FontWeight.w500),),
                Text(customer.address)
              ],
            ),
            Row(
              children: [
                const Text("EMAIL: ", style: TextStyle(fontWeight: FontWeight.w500),),
                Text(customer.mail)
              ],
            ),
            const Text("DESTINATEUR:", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.orange),),
            Row(
              children: [
                const Text("NOM: ", style: TextStyle(fontWeight: FontWeight.w500),),
                Text(customer.fullnameRecever)
              ],
            ),
            Row(
              children: [
                const Text("TELEPHONE: ", style: TextStyle(fontWeight: FontWeight.w500),),
                Text(customer.phoneRecever)
              ],
            ),
            Row(
              children: [
                const Text("ADDRESSE: ", style: TextStyle(fontWeight: FontWeight.w500),),
                Text(customer.addressRecever)
              ],
            ),
            Row(
              children: [
                const Text("EMAIL: ", style: TextStyle(fontWeight: FontWeight.w500),),
                Text(customer.mailRecever)
              ],
            )
          ],
        ),
        textOK: const Text("Imprimé"),
        textCancel: const Text("Fermé", style: TextStyle(color: Colors.red),)
    )){
      Navigator.pop(context);
      _displayPDF(customer);
      // _generatedPDF(PdfPageFormat.a4, "Impression de reçu");
    }
  }


  void _displayPDF(Customer customer) async {

    final doc = pw.Document();
    doc.addPage(
        pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context){
              return pw.Column(
                  children: [
                    pw.Row(
                        children: [
                          pw.BarcodeWidget(
                              data: customer.identify,
                              color: PdfColor.fromHex("#ED7F10"),
                              barcode: pw.Barcode.qrCode(),
                              width: 100,
                              height: 50
                          ),
                          customer.status! ?
                          pw.Text("RETRAIT D'ARGENT", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)):
                          pw.Text("DEPOT D'ARGENT", style:  pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                        ]
                    ),

                    pw.SizedBox(height: 10),
                    pw.Row(
                        children: [
                          pw.Text("Code : ${customer.identify}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ]
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                        children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Row(
                                    children: [
                                      pw.Text("DESTINATEUR", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                    ]
                                ),
                                pw.Row(
                                    children: [
                                      pw.Text("NOM: "),
                                      pw.Text(customer.fullname)
                                    ]
                                ),
                                pw.Row(
                                    children: [
                                      pw.Text("TELEPHONE: "),
                                      pw.Text(customer.telephone)
                                    ]
                                ),
                                pw.Row(
                                    children: [
                                      pw.Text("ADDRESSE: "),
                                      pw.Text(customer.address)
                                    ]
                                ),
                                pw.Row(
                                    children: [
                                      pw.Text("N° PIECE: "),
                                      pw.Text(customer.numberIdentify)
                                    ]
                                ),
                                pw.Row(
                                    children: [
                                      pw.Text("EMAIL: "),
                                      pw.Text(customer.mail)
                                    ]
                                )
                              ]
                          ),
                          pw.SizedBox(width: 50),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Row(
                                    children: [
                                      pw.Text("EXPEDITEUR", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                    ]
                                ),
                                pw.Row(
                                    children: [
                                      pw.Text("NOM: "),
                                      pw.Text(customer.fullnameRecever)
                                    ]
                                ),
                                pw.Row(
                                    children: [
                                      pw.Text("TELEPHONE: "),
                                      pw.Text(customer.phoneRecever)
                                    ]
                                ),
                                pw.Row(
                                    children: [
                                      pw.Text("ADDRESSE: "),
                                      pw.Text(customer.addressRecever)
                                    ]
                                ),
                                pw.Row(
                                    children: [
                                      pw.Text("EMAIL: "),
                                      pw.Text(customer.mailRecever)
                                    ]
                                )
                              ]
                          ),
                        ]
                    ),
                    pw.SizedBox(height: 20),
                    pw.Row(
                        children: [
                          pw.Text("MONTANT: ", style: pw.TextStyle(fontStyle: pw.FontStyle.italic, color: PdfColor.fromHex("B0A"))),
                          pw.Text("${customer.amount} GNF", style: pw.TextStyle(fontStyle: pw.FontStyle.italic, color: PdfColor.fromHex("B0A"))),
                          pw.Text(" effectué le ${customer.dateModify}" , style: pw.TextStyle(fontStyle: pw.FontStyle.italic, color: PdfColor.fromHex("B0A")))
                        ]
                    ),
                  ]
              );
            }
        )
    );

    Navigator.of(context).push(
        PageAnimationTransition(
            page: PreviewScreen(doc: doc, customer: customer,),
            pageAnimationType: RightToLeftFadedTransition()
        )
    );

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

