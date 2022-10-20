class User {
  String name;
  String lastName;
  DateTime? dateOfBirthday;
  String email;
  String phone;
  String userName;
  String password;
  User({
    this.name='',
    this.lastName='',
    this.dateOfBirthday,
    this.email='',
    this.userName='',
    this.password='',
    this.phone='',
  });

  Map<String, dynamic> toMap() {
    final map = {
      'firstName': name,
      'lastName': lastName,
      'birthDate': dateOfBirthday.toString(),
      'email': email,
      'phone':phone,
      'name': userName,
      'password': password,
    };
    return map;
  }


  factory User.fromMap(Map<String, dynamic> user) {
    return User(
      name: user['firstName'] as String,
      lastName: user['lastName'] as String,
      dateOfBirthday: DateTime.parse(user['birthDate']),
      email: user['email']as String,
      phone: user['phone'].toString(),
      userName: user['name'] as String,
      password: user['password'] as String,
    );
  }
}
