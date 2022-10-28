import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/middle_wares/repositories/api_repository.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/screens/home/home_screen.dart';
import 'package:snapchat/screens/user/bloc/user_bloc.dart';
//import 'package:snapchat/middle_wares/repositories/api_repository.dart';
//import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/screens/user_change/user_change.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({required this.user, super.key});
  final User user;
  @override
  State<UserScreen> createState() => _UserScreenState(user: user);
}

class _UserScreenState extends State<UserScreen> {
  _UserScreenState({required this.user});
  User user;
  final _bloc = UserBloc(
      apiRepository: ApiRepository(),
      sqlDatabaseRepository: SqlDatabaseRepository());
  @override
  void initState() {
    _bloc.add(UserScreenLoadEvent());
    // ApiRepository().upDateUser().then((value) => updateUser(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) => _userStateListner(context, state),
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              body: Center(
                child: Column(
                  children: [
                    _renderUserInfo(),
                    _renderLogOutButton(),
                    _renderDeleteButton(),
                    _renderEditButton(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _renderUserInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Text(
        'Name:${user.name}\nLastName:${user.lastName}'
        '\nDateOfBirth:${user.dateOfBirthday}\nUserName:${user.userName}'
        '\nEmail:${user.email}\nPhone:${user.phone}\nPassword:${user.password}\n',
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _renderLogOutButton() {
    return ElevatedButton(
      onPressed: () => _bloc.add(LogOutEvent()),
      /*  {
        SqlDatabaseRepository().Logout();
        Navigator.of(context).pop();
      }, */
      child: const Text('Log Out'),
    );
  }

  Widget _renderDeleteButton() {
    return ElevatedButton(
      onPressed: () => _bloc.add(DeleteEvent()),
      /*  {
        ApiRepository().deleteUser();
        Navigator.of(context).pop();
      }, */
      child: const Text('Delete'),
    );
  }

  Widget _renderEditButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserChange(
              user: user,
              updateUser: updateUser,
            ),
          ),
        );
      },
      child: const Text('edit account'),
    );
  }

  Future<void> _alertDialod(String alertTitle, String alertMsg) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alertTitle),
          content: Text(alertMsg),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updateUser(User? user) {
    if (user != null) {
      setState(() {
        this.user = user;
      });
    } else {
      Navigator.of(context).pop();
    }
  }
}

extension _BlocListener on _UserScreenState {
  void _userStateListner(BuildContext context, UserState state) {
    if (state is ShowErrorAler) {
      _alertDialod('ERROR', state.error);
    }
    if (state is ScreenLoadedState) {
      updateUser(state.user);
    }
    if (state is DeleteState) {
      // _alertDialod('Delete', 'Deleted');
      /*     Navigator.pushAndRemoveUntil<void>(
   
  ); */
      //  Navigator.of(context).pop();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    }
    if (state is LogOutState) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    }
  }
}
