import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/error_text_widget.dart';
import 'package:snapchat/components/widgets/screen_widget.dart';
import 'package:snapchat/middle_wares/validation_repository.dart';
import '../signup_birtday/sign_up_birtday_screen.dart';
import 'bloc/sign_up_name_block.dart';

class SignUpName extends StatefulWidget {
  const SignUpName({super.key});
  @override
  State<SignUpName> createState() => _SignUpNameState();
}

class _SignUpNameState extends State<SignUpName> {
  final SignUpNameBloc _bloc = SignUpNameBloc(validation: ValidationRepository());
  bool _isNameValid = false;
  bool _isLastNameValid = false;
  final _lastNameController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<SignUpNameBloc, SignUpNameState>(
        listener: _signupNameListener,
        builder: (context, state) {
          return ScreenSample(
              buttonText: 'namebutton'.i18n(),
              isvalid: _isLastNameValid && _isNameValid,
              onPressNextButton: _onPressNextButton,
              children: [
                _renderTitle(),
                _renderNameTitle(),
                _renderNameField(),
                _renderErrorTextName(),
                _renderLastNameTitle(),
                _renderLastNameField(),
                _renderErrorTextLastName(),
                _renderInfoText(),
                _renderPrivacyPolicy(),
                _renderServiceTerms(),
              ]);
        },
      ),
    );
  }

  Widget _renderTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Center(
        child: Text(
          'nametitle'.i18n(),
          style: TitleStyle,
        ),
      ),
    );
  }

  Widget _renderNameTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'namefieldtitle'.i18n(),
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderNameField() {
    return TextField(
      controller: _nameController,
      autofocus: true,
      onChanged: (value) => {
        _bloc.add(NameFieldEvent(name: value)),
      },
    );
  }

  Widget _renderErrorTextName() {
    return ErorrText(isValid: _isNameValid, errorText: 'namefielderror'.i18n());
  }

  Widget _renderLastNameTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        'lastnamefieldtitle'.i18n(),
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderLastNameField() {
    return TextField(
      controller: _lastNameController,
      onChanged: (value) => {_bloc.add(LastNameFieldEvent(lastName: value))},
    );
  }

  Widget _renderErrorTextLastName() {
    return ErorrText(
        isValid: _isLastNameValid, errorText: 'lastnamefielderror'.i18n());
  }

  Widget _renderInfoText() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
      ),
      child: Text('infotext'.i18n()),
    );
  }

  Widget _renderPrivacyPolicy() {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Row(
        children: [
          Text('privacypolicytext'.i18n()),
          _renderPrivacyPolicyButton(),
          Text('afterprivacypolicytext'.i18n()),
        ],
      ),
    );
  }

  Widget _renderPrivacyPolicyButton() {
    return GestureDetector(
      onTap: () {},
      child: Text(
        'privacypolicybuttontext'.i18n(),
        style: const TextStyle(color: Colors.blueAccent),
      ),
    );
  }

  Widget _renderServiceTerms() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('servicetermstext'.i18n()),
        _renderServiceTermsButton(),
      ],
    );
  }

  Widget _renderServiceTermsButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: GestureDetector(
        onTap: () {},
        child: Text(
          'servicetermsbutton'.i18n(),
          style: const TextStyle(color: Colors.blueAccent),
        ),
      ),
    );
  }

  void _onPressNextButton() {
    final user =
        User(name: _nameController.text, lastName: _lastNameController.text);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpBirtDay(
          user: user,
        ),
      ),
    );
  }
}

extension _BlocListener on _SignUpNameState {
  void _signupNameListener(BuildContext context, SignUpNameState state) {
    if (state is UpdateLastNameValid) {
      _isLastNameValid = state.isLastNameValid;
    }
    if (state is UpdateNameValid) {
      _isNameValid = state.isNameValid;
    }
  }
}
