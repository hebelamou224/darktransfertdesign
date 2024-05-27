import 'agency_model.dart';
import 'employee.dart';

class PartnerModel{
  int id;
  String username;
  String fullname;
  String address;
  String telephone;
  String dateRegister;
  String? password;
  List<AgencyWithEmployees> agencies;

  PartnerModel({
    required this.id,
    required this.username,
    required this.fullname,
    required this.telephone,
    required this.address,
    required this.dateRegister,
    required this.agencies,
    this.password
  });

  numberAgencies(){
    return agencies.length;
  }

  @override
  String toString() {
    return 'PartnerModel{id: $id, username: $username, fullname: $fullname, address: $address, telephone: $telephone, dateRegister: $dateRegister, agencies: $agencies}';
  }
}