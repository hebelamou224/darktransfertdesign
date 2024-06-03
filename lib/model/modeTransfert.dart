
class ModeTransfert{
  int? id;
  String name;
  String? description;

  ModeTransfert({
    this.id,
    required this.name,
    this.description
  });

  factory ModeTransfert.fromJson(Map<String, dynamic> json){
    return ModeTransfert(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String
    );
  }

  @override
  String toString() {
    return 'ModeTransfert{id: $id, name: $name, description: $description}';
  }
}