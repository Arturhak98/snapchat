import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/snapchat_localization.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/error_text_widget.dart';
import 'package:snapchat/components/widgets/screen_widget.dart';

import 'bloc/sign_up_pass_word_bloc.dart';

class SignUpPassword extends StatefulWidget {
  const SignUpPassword({required this.users, required this.user, super.key});
  final User user;
  final List<User> users;
  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
  final _passController = TextEditingController();
  bool _isValid = false, _hidePass = false;

  final SignUpPassWordBloc _bloc = SignUpPassWordBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<SignUpPassWordBloc, SignUpPassWordState>(
        listener: (context, state) {
          if (state is UpdatePassValid) {
            _isValid = state.isPassValid;
          }
          if (state is UpdateUserState) {
            widget.user.password = state.password;
            widget.users.add(widget.user);
            Navigator.popUntil(context, (route) => !Navigator.canPop(context));
          }
          if (state is HidePassState) {
            _hidePass = state.passIsHide;
          }
        },
        builder: (context, state) {
          return ScreenSample(
            buttonText:  AppLocalizations.of(context)!.nextbutton,
            isvalid: _isValid,
            onPressNextButton: _onPressPhoneNextButton,
            children: [
              _renderTitle(),
              _renderSecondTitle(),
              _renderFieldTitle(),
              _renderPassField(),
              _renderErrorText(),
            ],
          );
        },
      ),
    );
  }

  Widget _renderTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 160),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.passtitle,
          style: TitleStyle,
        ),
      ),
    );
  }

  Widget _renderSecondTitle() {
    return  Center(
      child: Text(
       AppLocalizations.of(context)!.passsecondtitle,
        style:const TextStyle(
            color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Widget _renderFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        AppLocalizations.of(context)!.passfieldtitle,
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderPassField() {
    return TextField(
        autofocus: true,
        obscureText: _hidePass,
        controller: _passController,
        onChanged: (value) => _bloc.add(PassFieldEvent(pass: value)),
        style: const TextStyle(fontSize: 20),
        decoration: InputDecoration(suffixIcon: _renderFieldButton()));
  }

  Widget _renderFieldButton() {
    return _passController.text.isEmpty
        ? Container()
        : TextButton(
            child:  Text(AppLocalizations.of(context)!.hide),
            onPressed: () => _bloc.add(HidePassEvent(hidepass: _hidePass)),
          );
  }

  Widget _renderErrorText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: ErorrText(
          isValid: _isValid,
          errorText: AppLocalizations.of(context)!.passfilederror),
    );
  }

  void _onPressPhoneNextButton() {
    _bloc.add(NextButtonEvent());
  }
}
