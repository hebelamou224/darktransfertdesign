class AgencyModel {
  int id;
  String identify;
  String name;
  String description;
  String lieu;
  double account;
  String? owner;

  AgencyModel({
    required this.id,
    required this.identify,
    required this.name,
    required this.description,
    required this.lieu,
    required this.account,
    this.owner
  });

  factory AgencyModel.fromJson(Map<String, dynamic> json){
    return AgencyModel(
        id: json["id"] as int,
        identify: json["identify"] as String,
        name: json["name"] as String,
        description: json["description"] as String,
        lieu: json["lieu"] as String,
        account: json["account"] as double,
        owner: json["owner"] as String
    );
  }

  @override
  String toString() {
    return 'Agency{id: $id, identify: $identify, name: $name, description: $description, lieu: $lieu, account: $account}';
  }
}