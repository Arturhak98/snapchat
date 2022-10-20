import 'package:flutter/material.dart';
import 'package:snapchat/components/models/user.dart';


class UserScreen extends StatefulWidget {
  const UserScreen({required this.user, super.key});
  final User user;
  @override
  State<UserScreen> createState() => _UserScreenState(user: user);
}

class _UserScreenState extends State<UserScreen> {
  _UserScreenState({required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Name:${user.name}\nLastName:${user.lastName}' 
          '\nDateOfBirth:${user.dateOfBirthday}\nUserName:${user.userName}'
          '\nEmail:${user.email}\nPhone:${user.phone}\nPassword:${user.password}\n',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
