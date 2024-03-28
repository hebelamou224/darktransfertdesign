
import 'package:darktransfert/repository/action_repository.dart';

import '../model/action.dart';

class ActionService{
  ActionRepository actionRepository = ActionRepository();

  Future<List<ActionsConnected>?> findActionByEmployeeId(int employeeId, String date, bool all) async{
    return await actionRepository.findActionByEmployeeId(employeeId,date, all);
  }
}