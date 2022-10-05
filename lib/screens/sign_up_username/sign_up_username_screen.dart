import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/snapchat_localization.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/error_text_widget.dart';
import 'package:snapchat/components/widgets/screen_widget.dart';

import '../signup_password/sign_up_password_screen.dart';
import 'bloc/sign_up_username_bloc.dart';

class SignUpUserName extends StatefulWidget {
  const SignUpUserName({/* required this.users, */ required this.user, super.key});
  final User user;
/*   final List<User> users; */

  @override
  State<SignUpUserName> createState() => _SignUpUserNameState();
}

class _SignUpUserNameState extends State<SignUpUserName> {
  bool _isValid = false;
  late final SignUpUsernameBloc _bloc = SignUpUsernameBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<SignUpUsernameBloc, SignUpUsernameState>(
        listener: (context, state) {
          if (state is UpdateUserState) {
            widget.user.userName = state.username;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SignUpPassword(
                  user: widget.user,
                 /*  users: widget.users, */
                ),
              ),
            );
          }
          if (state is UpdateUsernameValid) {
            _isValid = state.isUsernameValid;
          }
        },
        builder: (context, state) => ScreenSample(
          buttonText:  AppLocalizations.of(context)!.nextbutton,
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
            AppLocalizations.of(context)!.usarnmaetitle,
            style: TitleStyle,
          ),
        ));
  }

  Widget _renderSecondTitle() {
    return  Center(
      child: Text(
        AppLocalizations.of(context)!.usarnamesecondtitle,
        style:const TextStyle(
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
        AppLocalizations.of(context)!.usernamefieldtitle,
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderUsernameField() {
    return TextField(
      onChanged: (value) => _bloc.add(UsernameFieldEvent(username: value)),
      autofocus: true,
    );
  }

  Widget _renderErrorText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: ErorrText(
          isValid: _isValid,
          errorText: AppLocalizations.of(context)!.usernamefielderror),
    );
  }

  void _onPressNextButton() {
    _bloc.add(NextButtonEvent());
  }
}
