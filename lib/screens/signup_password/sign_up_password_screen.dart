import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/error_text_widget.dart';
import 'package:snapchat/components/widgets/screen_widget.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';

import 'bloc/sign_up_pass_word_bloc.dart';

class SignUpPassword extends StatefulWidget {
  const SignUpPassword(
      { required this.user, super.key});
  final User user;
  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
  final _passController = TextEditingController();
  bool _isValid = false;
  bool _hidePass = false;
  final SignUpPassWordBloc _bloc = SignUpPassWordBloc(validation: ValidationRepository());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<SignUpPassWordBloc, SignUpPassWordState>(
        listener: _signUpPasswordListner,
        builder: (context, state) {
          return ScreenSample(
            buttonText: 'nextbutton'.i18n(),
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
          'passtitle'.i18n(),
          style: TitleStyle,
        ),
      ),
    );
  }

  Widget _renderSecondTitle() {
    return Center(
      child: Text(
        'passsecondtitle'.i18n(),
        style: const TextStyle(
            color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Widget _renderFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'passfieldtitle'.i18n(),
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
            child: Text('hide'.i18n()),
            onPressed: () => setState(() {
              _hidePass = !_hidePass;
            }),
          );
  }

  Widget _renderErrorText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: ErrorText(isValid: _isValid, errorText: 'passfilederror'.i18n()),
    );
  }

  void _onPressPhoneNextButton() {
    final sqldb=SqlDatabaseRepository();
    widget.user.password = _passController.text;
    sqldb.insert(widget.user);
    Navigator.popUntil(context, (route) => !Navigator.canPop(context));
  }
}

extension _SignUpPasswordListner on _SignUpPasswordState {
  void _signUpPasswordListner(BuildContext context, SignUpPassWordState state) {
    if (state is UpdatePassValid) {
      _isValid = state.isPassValid;
    }
  }
}
