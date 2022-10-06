import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/snapchat_localization.dart';

import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/error_text_widget.dart';
import 'package:snapchat/components/widgets/screen_widget.dart';

import '../user/user_screen.dart';
import 'bloc/login_bloc.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});
  @override
  State<LogInScreen> createState() => _LogInState();
}

class _LogInState extends State<LogInScreen> {
  bool _visibility = true,
      _usernameAndPassIsValid = true,
      _isPassValid = false,
      _isUsernameValid = false;
  final _bloc = LoginBloc();

  @override
  void initState() {
    _bloc.add(LoginScrenLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is UpdateNameValid) {
            _isUsernameValid = state.isUserNameValid;
          }
          if (state is UpdatePassValid) {
            _usernameAndPassIsValid=true;
            _isPassValid = state.IsPassValid;
          }
          if (state is PassObscureState) {
            _visibility = state.passIsObscured;
          }
          if (state is UserNameOrPassIsNotValid) {
            _usernameAndPassIsValid = false;
          }
          if (state is UserNameAndPassValidState) {
            _usernameAndPassIsValid = true;
            if (_usernameAndPassIsValid) {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => UserScreen(user: state.loginUser)),
              );
            }
          }
        },
        builder: (context, state) {
          return ScreenSample(
            buttonText: AppLocalizations.of(context)!.loginbutton,
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
    );
  }

  Widget _renderTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.logintitle,
          style: TitleStyle,
        ),
      ),
    );
  }

  Widget _renderUsernameTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Text(AppLocalizations.of(context)!.loginfieldtitle,
          style: FieldTitleStyle),
    );
  }

  Widget _renderLogInUserneame() {
    return TextField(
      autofocus: true,
      onChanged: (value) => _bloc.add(NameFieldEvent(userName: value)),
    );
  }

  Widget _renderUsernameErrorText() {
    return ErorrText(
        isValid: _isUsernameValid,
        errorText: AppLocalizations.of(context)!.loginfielderror);
  }

  Widget _renderPassTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        AppLocalizations.of(context)!.loginfieldpasstitle,
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderLogInPassword() {
    return TextField(
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
        _bloc.add(ObscureButtonEvent(passIsObscured: _visibility));
      },
      icon: Icon(_visibility
          ? Icons.visibility_off_sharp
          : Icons.remove_red_eye_sharp),
    );
  }

  Widget _renderPassErrorText() {
    return ErorrText(
        isValid: _isPassValid && _usernameAndPassIsValid,
        errorText: _usernameAndPassIsValid
            ? AppLocalizations.of(context)!.loginfieldpasserror
            : AppLocalizations.of(context)!.loginerror);
  }


  Widget _renderForgotPasswordButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Center(
        child: TextButton(
          onPressed: () {},
          child: Text(AppLocalizations.of(context)!.forgotpass),
        ),
      ),
    );
  }

  void _onPressNextButton() {
    _bloc.add(NextButtonEvent());
  }
}
