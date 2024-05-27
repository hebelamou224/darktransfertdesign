class ActionsConnected{
  int id;
  int idSource;
  int idAction;
  String description;
  String typeAction;
  String dateAction;
  String? identifyAgency;

  ActionsConnected({
    required this.id,
    required this.idSource,
    required this.idAction,
    required this.description,
    required this.typeAction,
    required this.dateAction,
    this.identifyAgency
  });

  factory ActionsConnected.fromJson(Map<String, dynamic> json){
    return ActionsConnected(
        id: json["id"] as int,
        idSource: json["idSource"] as int,
        idAction: json["idAction"] as int,
        description: json["description"] as String,
        typeAction: json["typeAction"] as String,
        dateAction: json["dateAction"] as String,
        identifyAgency: json["identifyAgency"] as String
    );
  }

  @override
  String toString() {
    return 'Action{id: $id, idSource: $idSource, idAction: $idAction, description: $description, typeAction: $typeAction, dateAction: $dateAction}';
  }
}