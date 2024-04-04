
import 'package:darktransfert/model/partner.dart';
import 'package:darktransfert/repository/partner_repository.dart';

import '../model/partners_get.dart';

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

  Future<List<PartnerModel>> findAllPartners() async{
    List<PartnerModel> list = await partnerRepository.findAllPartners();
    return list;
  }

  Future<List<PartnerModel>> findAllPartnersWithValue(String searchValue) async{
    List<PartnerModel> list = await partnerRepository.findAllPartnersWithValue(searchValue);
    return list;
  }


}