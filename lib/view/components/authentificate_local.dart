
//import 'package:flutter/services.dart';
/*
class LocalAuthApi{

  static final _auth = LocalAuthentification();

  static Future<bool> hasBiometrics() async {
    try{
      return await _auth.canCheckBiometrics;
    } on PlatformException catch(e){
      return false;
    }
  }

  static Future<bool> authentificate() async{
    final isAvaible = await hasBiometrics();
    if(!isAvaible) return false;

    try{
      return await _auth.authentificateWithBiometrics(
          localizedReason: "Scan Fingerprint to Authentificate",
          useErrorDialogs: true,
          stickyAuth: true
      );
    } on PlatformException catch(e){
      return false;
    }

  }

}
*/