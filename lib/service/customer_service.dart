import 'package:darktransfert/repository/customer_repository.dart';

import '../model/customer.dart';

class CustomerService{
  CustomerRepository customerRepository = CustomerRepository();

  Future<Customer?> findByIdentify(String identifyCustomer) async{
    return await customerRepository.findByIdentify(identifyCustomer);
  }
}