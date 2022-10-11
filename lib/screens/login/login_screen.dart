import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/error_text_widget.dart';
import 'package:snapchat/components/widgets/screen_widget.dart';
import 'package:snapchat/middle_wares/validation_repository.dart';

import '../user/user_screen.dart';
import 'bloc/login_bloc.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});
  @override
  State<LogInScreen> createState() => _LogInState();
}

class _LogInState extends State<LogInScreen> {
  bool _visibility = true;
  bool _isPassValid = false;
  bool _isUsernameValid = false;
  final _userNameController = TextEditingController();
  final _passController = TextEditingController();
  final _bloc = LoginBloc(validation: ValidationRepository());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: _loginBlocListener,
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return ScreenSample(
              buttonText: 'loginbutton'.i18n(),
              isvalid: _isPassValid && _isUsernameValid,
              onPressNextButton: _onPressNextButton,
              children: [
                _renderTitle(),
                _renderUsernameTitle(),
                _renderLogInUserneame(),
                _renderUsernameErrorText(),
                _renderPassTitle(),
                _renderLogInPassword(),
                _renderPassErrorText(),
                _renderForgotPasswordButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _renderTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Center(
        child: Text(
          'logintitle'.i18n(),
          style: TitleStyle,
        ),
      ),
    );
  }

  Widget _renderUsernameTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Text('loginfieldtitle'.i18n(), style: FieldTitleStyle),
    );
  }

  Widget _renderLogInUserneame() {
    return TextField(
      controller: _userNameController,
      autofocus: true,
      onChanged: (value) => _bloc.add(NameFieldEvent(userName: value)),
    );
  }

  Widget _renderUsernameErrorText() {
    return ErorrText(
        isValid: _isUsernameValid, errorText: 'loginfielderror'.i18n());
  }

  Widget _renderPassTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        'loginfieldpasstitle'.i18n(),
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderLogInPassword() {
    return TextField(
      controller: _passController,
      onChanged: (value) => _bloc.add(PassFieldEvent(pass: value)),
      obscureText: _visibility,
      decoration: InputDecoration(
        suffixIcon: _renderObscureButton(),
      ),
    );
  }

  Widget _renderObscureButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          _visibility = !_visibility;
        });
      },
      icon: Icon(_visibility
          ? Icons.visibility_off_sharp
          : Icons.remove_red_eye_sharp),
    );
  }

  Widget _renderPassErrorText() {
    return ErorrText(
        isValid: _isPassValid, errorText: 'loginfieldpasserror'.i18n());
  }

  Widget _renderForgotPasswordButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Center(
        child: TextButton(
          onPressed: () {},
          child: Text('forgotpass'.i18n()),
        ),
      ),
    );
  }

  Future<void> _showErroeMsg(String ErrorMsg) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(' $ErrorMsg'),
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

  void _onPressNextButton() {
    _bloc.add(NextButtonEvent(
        passController: _passController,
        userNameController: _userNameController));
  }
}

extension _BlocListener on _LogInState {
  void _loginBlocListener(BuildContext context, LoginState state) {
    if (state is UpdateNameValid) {
      _isUsernameValid = state.isUserNameValid;
    }
    if (state is UpdatePassValid) {
      _isPassValid = state.IsPassValid;
    }
    if (state is UserNameOrPassIsNotValid) {
      _showErroeMsg('loginerror'.i18n());
    }
    if (state is UserNameAndPassValidState) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserScreen(user: state.loginUser)));
    }
  }
}
