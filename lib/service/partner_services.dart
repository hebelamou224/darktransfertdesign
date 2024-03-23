
import 'package:darktransfert/model/partner.dart';
import 'package:darktransfert/repository/partner_repository.dart';

class PartnerService{

  PartnerRepository partnerRepository = PartnerRepository();

  Future<String> addPartner(Partner partner) async{
    String response = await partnerRepository.addPartner(partner);
    return response;
  }

  Future<List<Partner>> findAllPartner() async{
    List<Partner> list = await partnerRepository.findAllPartner();
    return list;
  }


}