import 'package:darktransfert/view/caissier/pages/withdrawal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class ScannerQrCode extends StatefulWidget {
  final bool isScanProviderDrawerMenu ;
  const ScannerQrCode({required this.isScanProviderDrawerMenu, super.key});

  @override
  State<ScannerQrCode> createState() => _ScannerQrCodeState();
}

class _ScannerQrCodeState extends State<ScannerQrCode> {

  String qrResult = "Scanned Data will appear here";
  Future<void> scanQR() async{
    try{
      final qrCode = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Annuler', true, ScanMode.QR);
      if(!mounted){
        return;
      }
      setState(() {
        qrResult = qrCode.toString();
      });

      if(widget.isScanProviderDrawerMenu){
        Navigator.pop(context);
        Navigator.of(context).push(
          PageAnimationTransition(
              page: WithDrawalAgencyCustome(code: qrResult,),
              pageAnimationType: RightToLeftFadedTransition()
          )
        );
      }else{
        Navigator.pop(context, qrResult);
      }

    }on PlatformException{
      qrResult = "Fail to read QR Code";
    }
  }

  @override
  void initState() {
    super.initState();
    scanQR();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("QR Code Scanner"),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50, left: 10, right: 10,bottom: 10),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.all(15),
              ),
              onPressed: scanQR,
              child: const Text("Scanner le code", style: TextStyle(color: Colors.white),),
            ),
          ),
          Center(
            child: Text(qrResult),
          ),
        ],
      ),
    );
  }
}
