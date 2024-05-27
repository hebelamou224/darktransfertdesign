
import 'package:darktransfert/model/partners_get.dart';

class UserConnected{
  static int id = 0;
  static String username = "";
  static String fullname = "";
  static String firstname = "";
  static String lastname = "";
  static String dateConnected = "";
  static String password = "";
  static String telephone = "";
  static String dateRegister = "";
  static String identifyAgency = "";
  static String role = "";
  static String address = "";
  static bool mainAgency = false;

  static PartnerModel? partnerModel;

  static String  letterOfName(){
    String fullnameNotSpace = fullname.trim() ;
    List<String> letters = fullnameNotSpace.split(" ");
    String fname = letters.first.substring(0,1);
    String lname = letters.last;
    if(lname.isNotEmpty){
      lname = lname.substring(0,1);
    }else{
      lname = fname.substring(0,1);
    }
    String fullletter = "$fname$lname";

    return fullletter;
  }


}