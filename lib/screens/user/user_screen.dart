import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/components/widgets/error_alert.dart';
import 'package:snapchat/components/widgets/main_screen.dart';
import 'package:snapchat/middle_wares/repositories/api_repository.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/screens/user/bloc/user_bloc.dart';
import 'package:snapchat/screens/user_change/user_change.dart';

class UserScreen extends StatefulWidget {
  const UserScreen();
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  _UserScreenState();
  User user = User();
  final _bloc = UserBloc(
      apiRepository: ApiRepository(),
      sqlDatabaseRepository: SqlDatabaseRepository());
  @override
  void initState() {
    _bloc.add(UserScreenLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) => _userStateListner(context, state),
          builder: (context, state) => _render()),
    );
  }

  Widget _render() {
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
              updateUser: updateUser,
            ),
          ),
        );
      },
      child: const Text('edit account'),
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
    if (state is SqlUserState) {
      user = state.user;
    }
    if (state is ShowErrorAler) {
      showDialog(
        context: context,
        builder: (context) => ErrorAlert(
          ErrorMsg: state.error,
        ),
      );
    }
    if (state is ScreenLoadedState) {
      updateUser(state.user);
    }
    if (state is DeleteState) {
      context.findAncestorStateOfType<FirstScreenState>()?.reloadApp();
    }
    if (state is LogOutState) {
      context.findAncestorStateOfType<FirstScreenState>()?.reloadApp();
    }
  }
}
