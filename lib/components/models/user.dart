class User {
  String? name;
  String? lastName;
  DateTime? dateOfBirthday;
  String? emailOrPhoneNumber;
  String? userName;
  String? password;
  User({
    this.name,
    this.lastName,
    this.dateOfBirthday,
    this.emailOrPhoneNumber,
    this.userName,
    this.password,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'lastname': lastName,
      'dateOfBirthday': dateOfBirthday.toString(),
      'emailOrPhoneNumber': emailOrPhoneNumber,
      'userName':userName,
      'password':password,
    };
    return map;
  }

  factory User.fromMap(Map<String, dynamic> user) {
    return User(
      name:user['name'] as String,
      lastName: user['lastName'] as String,
      dateOfBirthday: DateTime.parse(user['dateOfBirthday']) ,
      emailOrPhoneNumber: user['emailOrPhoneNumber'].toString(),
      userName:user['userName'] as String,
      password: user['password'] as String,
    );
  }
}
