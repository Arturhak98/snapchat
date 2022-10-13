import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/error_text_widget.dart';
import 'package:snapchat/components/widgets/screen_widget.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';
import '../signup_password/sign_up_password_screen.dart';
import 'bloc/sign_up_username_bloc.dart';

class SignUpUserName extends StatefulWidget {
  const SignUpUserName({required this.user, super.key});
  final User user;

  @override
  State<SignUpUserName> createState() => _SignUpUserNameState();
}

class _SignUpUserNameState extends State<SignUpUserName> {
  bool _isValid = false;
  bool _usernameIsBusy = true;
  final _usernameController = TextEditingController();
  late final SignUpUsernameBloc _bloc = SignUpUsernameBloc(validation: ValidationRepository(),sqldb: SqlDatabaseRepository());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<SignUpUsernameBloc, SignUpUsernameState>(
        listener: _signUpUsernameListenr,
        builder: (context, state) => ScreenSample(
            buttonText: 'nextbutton'.i18n(),
            isvalid: _isValid,
            onPressNextButton: _onPressNextButton,
            children: [
              _renderTitle(),
              _renderSecondTitle(),
              _renderFieldTitle(),
              _renderUsernameField(),
              _renderErrorText(),
            ]),
      ),
    );
  }

  Widget _renderTitle() {
    return Padding(
        padding: const EdgeInsets.only(top: 160),
        child: Center(
          child: Text(
            'usarnmaetitle'.i18n(),
            style: TitleStyle,
          ),
        ));
  }

  Widget _renderSecondTitle() {
    return Center(
      child: Text(
        'usarnamesecondtitle'.i18n(),
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _renderFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'usernamefieldtitle'.i18n(),
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderUsernameField() {
    return TextField(
      controller: _usernameController,
      onChanged: (value) => _bloc.add(UsernameFieldEvent(username: value)),
      autofocus: true,
    );
  }

  Widget _renderErrorText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: ErorrText(
          isValid: _isValid && _usernameIsBusy,
          errorText: _usernameIsBusy
              ? 'usernamefielderror'.i18n()
              : 'usernamebusytext'.i18n()),
    );
  }

  Future<void> _onPressNextButton() async {
    _bloc.add(NextButtonEvent(userName: _usernameController.text));
  }
}

extension _SignUpUsernameListenr on _SignUpUserNameState {
  void _signUpUsernameListenr(BuildContext context, SignUpUsernameState state) {
    if (state is UpdateUserState) {
      widget.user.userName = _usernameController.text;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SignUpPassword(
            user: widget.user,
          ),
        ),
      );
    }
    if (state is UpdateUsernameValid) {
      _usernameIsBusy = true;
      _isValid = state.isUsernameValid;
    }
    if (state is UsernameIsBusy) {
      _usernameIsBusy = false;
    }
  }
}
