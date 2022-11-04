class User {
  String name;
  String lastName;
  DateTime dateOfBirthday;
  String email;
  String phone;
  String userName;
  String password;
  User({
    this.name = '',
    this.lastName = '',
    DateTime? dateOfBirthday,
    this.email = '',
    this.userName = '',
    this.password = '',
    this.phone = '',
  }):dateOfBirthday=dateOfBirthday ?? DateTime.now();

  Map<String, dynamic> toMap() {
    final map = {
      'firstName': name,
      'lastName': lastName,
      'birthDate': dateOfBirthday.toString(),
      'email': email,
      'phone': phone,
      'name': userName,
      'password': password,
    };
    return map;
  }

  factory User.fromMap(Map<String, dynamic> user) {
    return User(
      name: user['firstName'].toString(),
      lastName: user['lastName'].toString(),
      dateOfBirthday: DateTime.parse(user['birthDate']),
      email: user['email'].toString(),
      phone: user['phone'].toString(),
      userName: user['name'].toString(),
      password: user['password'].toString(),
    );
  }
}
