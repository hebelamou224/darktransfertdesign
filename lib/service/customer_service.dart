import 'package:darktransfert/repository/customer_repository.dart';

import '../model/customer.dart';

class CustomerService{
  CustomerRepository customerRepository = CustomerRepository();

  Future<Customer?> findByIdentify(String identifyCustomer) async{
    return await customerRepository.findByIdentify(identifyCustomer);
  }

  Future<Customer?> findFirstByOrderByOperationDateModifyDesc() async{
    return await customerRepository.findFirstByOrderByOperationDateModifyDesc();
  }

  Future<List<Customer>?> findAllByOrderByOperationDateModifyDesc() async{
    return await customerRepository.findAllByOrderByOperationDateModifyDesc();
  }

  Future<List<Customer>?> findAllByFullnameContainingOrFullnameReceverContainingOrderByOperationDateModifyDesc(String fullname) async{
    return await customerRepository.findAllByFullnameContainingOrFullnameReceverContainingOrderByOperationDateModifyDesc(fullname);
  }
}