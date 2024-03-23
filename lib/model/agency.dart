class Agency {
  int id;
  String identify;
  String name;
  String description;
  String lieu;
  double account;

  Agency({
    required this.id,
    required this.identify,
    required this.name,
    required this.description,
    required this.lieu,
    required this.account
  });

  factory Agency.fromJson(Map<String, dynamic> json){
    return Agency(
        id: json["id"] as int,
        identify: json["identify"] as String,
        name: json["name"] as String,
        description: json["description"] as String,
        lieu: json["lieu"] as String,
        account: json["account"] as double
    );
  }

  @override
  String toString() {
    return 'Agency{id: $id, identify: $identify, name: $name, description: $description, lieu: $lieu, account: $account}';
  }
}