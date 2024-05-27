class Employee{
  int id;
  String username;
  String fullname;
  String address;
  String telephone;
  String dateRegister;
  String role;
  String identifyAgency;
  String password;

  Employee({
    required this.id,
    required this.username,
    required this.fullname,
    required this.address,
    required this.telephone,
    required this.dateRegister,
    required this.role,
    required this.identifyAgency,
    required this.password
  });

  factory Employee.fromJson(Map<String, dynamic> json){
    return Employee(
        id: json["id"] as int,
        username: json["username"] as String,
        fullname: json["fullname"] as String,
        address: json["address"] as String,
        telephone: json["telephone"] as String,
        dateRegister: json["dateRegister"] as String,
        role: json["role"] as String,
        identifyAgency: json["identifyAgency"] as String,
        password: json["password"] as String
    );
  }

  @override
  String toString() {
    return 'Employee{id: $id, username: $username, fullname: $fullname, address: $address, telephone: $telephone, dateRegister: $dateRegister, role: $role, identifyAgency: $identifyAgency, password: $password}';
  }
}