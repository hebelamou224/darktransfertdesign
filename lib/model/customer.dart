class Customer {
  int id;
  String identify;
  String fullname;
  String telephone;
  String address;
  String numberIdentify;
  String mail;
  String fullnameRecever;
  String phoneRecever;
  String addressRecever;
  String mailRecever;
  double? amount;
  String? dateDeposit;
  bool? status;
  String? type;
  String? dateWithdrawal;

  Customer({
    required this.id,
    required this.identify,
    required this.fullname,
    required this.telephone,
    required this.address,
    required this.numberIdentify,
    required this.mail,
    required this.fullnameRecever,
    required this.phoneRecever,
    required this.addressRecever,
    required this.mailRecever,
    this.amount,
    this.dateDeposit,
    this.dateWithdrawal,
    this.status,
    this.type
  });

  factory Customer.fromJson(Map<String, dynamic> json){
    return Customer(id: json["id"] as int,
        identify: json["identify"] as String,
        fullname: json["fullname"] as String,
        telephone: json["telephone"] as String,
        address: json["address"] as String,
        numberIdentify: json["numberIdentify"] as String,
        mail: json["mail"] as String,
        fullnameRecever: json["fullnameRecever"] as String,
        phoneRecever: json["phoneRecever"] as String,
        addressRecever: json["addressRecever"] as String,
        mailRecever: json["mailRecever"] as String);
  }

  @override
  String toString() {
    return 'Customer{id: $id, identify: $identify, fullname: $fullname, telephone: $telephone, address: $address, numberIdentify: $numberIdentify, mail: $mail, fullnameRecever: $fullnameRecever, phoneRecever: $phoneRecever, addressRecever: $addressRecever, mailRecever: $mailRecever}';
  }
}