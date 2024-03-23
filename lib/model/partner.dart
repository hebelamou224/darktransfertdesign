class Partner{
  int id;
  String username;
  String address;
  String telephone;
  String fullname;

  Partner({
    required this.id,
    required this.username,
    required this.address,
    required this.telephone,
    required this.fullname
  });

  factory Partner.fromJson(Map<String, dynamic> json){
    return Partner(
        id: json["id"] as int,
        username: json["username"] as String,
        address: json["address"] as String,
        telephone: json["telephone"] as String,
        fullname: json["fullname"] as String
    );
  }

}