

class User{

  int? id;
  String? username;
  String? fullname;
  String? photo;
  String? password;
  String? role;
  String? telephone;

  User({
    this.id,
    this.username,
    this.fullname,
    this.photo,
    this.password,
    this.role,
    this.telephone
  });

  factory  User.fromJson(Map<String, dynamic> json){
    return User(
      id:json["id"] as int,
      username: json["username"] as String,
      fullname: json["fullname"] as String,
      photo: json["photo"] as String,
      password: json["password"] as String,
      role: json["role"] as String,
      telephone: json["telephone"] as String,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, fullname: $fullname, photo: $photo, password: $password, role: $role, telephone: $telephone}';
  }


}