class Model {
  int id;
  String username;
  String password;
  Model({required this.id, required this.username, required this.password});

  Map<String, dynamic> toMap() {
    final map = {'username': username, 'password': password, 'id': id};
    return map;
  }

  factory Model.fromMap(Map<String, dynamic> user) {
    return Model(
        id: user['id'] as int,
        username: user['username'] as String,
        password: user['password'] as String);
  }
}
