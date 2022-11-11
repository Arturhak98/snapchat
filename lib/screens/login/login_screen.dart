import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/error_alert.dart';
import 'package:snapchat/components/widgets/error_text_widget.dart';
import 'package:snapchat/components/widgets/main_screen.dart';
import 'package:snapchat/components/widgets/screen_widget.dart';
import 'package:snapchat/middle_wares/repositories/api_repository.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';

import 'bloc/login_bloc.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});
  @override
  State<LogInScreen> createState() => _LogInState();
}

class _LogInState extends State<LogInScreen> {
  final _visibilityNotifier = ValueNotifier<bool>(true);
  bool _isPassValid = true;
  bool _isUsernameValid = true;
  final _userNameController = TextEditingController(text: '1234');
  final _passController = TextEditingController(text: '12345678');
  final _bloc = LoginBloc(
      validation: ValidationRepository(),
      sqldb: SqlDatabaseRepository(),
      apirepo: ApiRepository());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: _loginBlocListener,
        child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) => _render()),
      ),
    );
  }

  Widget _render() {
    return ScreenSample(
      buttonText: 'loginbutton'.tr(),
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
  }

  Widget _renderTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Center(
        child: Text(
          'logintitle'.tr(),
          style: TitleStyle,
        ),
      ),
    );
  }

  Widget _renderUsernameTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Text('loginfieldtitle'.tr(), style: FieldTitleStyle),
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
    return ErrorText(
        isValid: _isUsernameValid, errorText: 'loginfielderror'.tr());
  }

  Widget _renderPassTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        'loginfieldpasstitle'.tr(),
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderLogInPassword() {
    return ValueListenableBuilder(
        valueListenable: _visibilityNotifier,
        builder: ((context, value, child) => TextField(
              controller: _passController,
              onChanged: (value) => _bloc.add(PassFieldEvent(pass: value)),
              obscureText: value,
              decoration: InputDecoration(
                suffixIcon: _renderObscureButton(),
              ),
            )));
  }

  Widget _renderObscureButton() {
    return IconButton(
      onPressed: () {
        _visibilityNotifier.value = !_visibilityNotifier.value;
      },
      icon: ValueListenableBuilder(
        valueListenable: _visibilityNotifier,
        builder: ((context, value, child) => Icon(
            value ? Icons.visibility_off_sharp : Icons.remove_red_eye_sharp)),
      ),
    );
  }

  Widget _renderPassErrorText() {
    return ErrorText(
        isValid: _isPassValid, errorText: 'loginfieldpasserror'.tr());
  }

  Widget _renderForgotPasswordButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Center(
        child: TextButton(
          onPressed: () {},
          child: Text('forgotpass'.tr()),
        ),
      ),
    );
  }

  void _onPressNextButton() {
    _bloc.add(NextButtonEvent(
        password: _passController.text, userName: _userNameController.text));
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
    if (state is AlertError) {
      showDialog(
        context: context,
        builder: (context) => ErrorAlert(
          ErrorMsg: state.error,
        ),
      );
    }
    if (state is UserNameAndPassValidState) {
      context.findAncestorStateOfType<FirstScreenState>()?.navigatorKey =
          GlobalKey<NavigatorState>();
      context.findAncestorStateOfType<FirstScreenState>()?.reloadApp();
    }
  }
}
