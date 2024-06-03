
import '../model/modeTransfert.dart';
import '../repository/modeTransfert.dart';

class ModeTransfertService{

  ModeTransfertRepository repo = ModeTransfertRepository();

  Future<List<ModeTransfert>?> findAll() async{
    return await repo.findAll();
  }

}