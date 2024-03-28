import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../model/customer.dart';

class PreviewScreen extends StatelessWidget {
  final Customer? customer;
  final pw.Document doc;

  const PreviewScreen({
    super.key,
    required this.doc,
    required this.customer
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Impression reçu",
        ),
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
        pdfFileName: customer!.status! ? "recu_de_${customer!.fullnameRecever}.dpf": "recu_de_${customer!.fullname}.dpf",
      ),
    );
  }

}
