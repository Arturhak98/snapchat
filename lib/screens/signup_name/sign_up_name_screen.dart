import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/snapchat_localization.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/error_text_widget.dart';
import 'package:snapchat/components/widgets/screen_widget.dart';

import '../signup_birtday/sign_up_birtday_screen.dart';
import 'bloc/sign_up_name_block.dart';

class SignUpName extends StatefulWidget {
  const SignUpName({/* required this.Users,  */super.key});
 /*  final List<User> Users; */
  @override
  State<SignUpName> createState() => _SignUpNameState();
}

class _SignUpNameState extends State<SignUpName> {
  final SignUpNameBloc _bloc = SignUpNameBloc();
  bool _isNameValid = false, _isLastNameValid = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<SignUpNameBloc, SignUpNameState>(
        listener: (context, state) {
          if (state is UpdateLastNameValid) {
            _isLastNameValid = state.isLastNameValid;
          }
          if (state is UpdateNameValid) {
            _isNameValid = state.isNameValid;
          }
          if (state is UpdateUserState) {
            final user = User(name: state.name, lastName: state.lastName);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    SignUpBirtDay(user: user, /* users: widget.Users */),
              ),
            );
          }
        },
        builder: (context, state) {
          return ScreenSample(
              buttonText: AppLocalizations.of(context)!.namebutton,
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
          AppLocalizations.of(context)!.nametitle,
          style: TitleStyle,
        ),
      ),
    );
  }

  Widget _renderNameTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        AppLocalizations.of(context)!.namefieldtitle,
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderNameField() {
    return TextField(
      autofocus: true,
      onChanged: (value) => {
        _bloc.add(NameFieldEvent(name: value)),
      },
    );
  }

  Widget _renderErrorTextName() {
    return ErorrText(
        isValid: _isNameValid,
        errorText: AppLocalizations.of(context)!.namefielderror);
  }

  Widget _renderLastNameTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        AppLocalizations.of(context)!.lastnamefieldtitle,
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderLastNameField() {
    return TextField(
      onChanged: (value) => {_bloc.add(LastNameFieldEvent(lastName: value))},
    );
  }

  Widget _renderErrorTextLastName() {
    return ErorrText(
        isValid: _isLastNameValid,
        errorText: AppLocalizations.of(context)!.lastnamefielderror);
  }

  Widget _renderInfoText() {
    return  Padding(
      padding:const EdgeInsets.only(
        top: 5,
      ),
      child: Text(AppLocalizations.of(context)!.infotext),
    );
  }

  Widget _renderPrivacyPolicy() {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Row(
        children: [
           Text(AppLocalizations.of(context)!.privacypolicytext),
          _renderPrivacyPolicyButton(),
           Text(AppLocalizations.of(context)!.afterprivacypolicytext),
        ],
      ),
    );
  }

  Widget _renderPrivacyPolicyButton() {
    return GestureDetector(
      onTap: () {},
      child:  Text(
        AppLocalizations.of(context)!.privacypolicybuttontext,
        style:const TextStyle(color: Colors.blueAccent),
      ),
    );
  }

  Widget _renderServiceTerms() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(AppLocalizations.of(context)!.servicetermstext),
        _renderServiceTermsButton(),
      ],
    );
  }

  Widget _renderServiceTermsButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: GestureDetector(
        onTap: () {},
        child:  Text(
           AppLocalizations.of(context)!.servicetermsbutton,
          style:const TextStyle(color: Colors.blueAccent),
        ),
      ),
    );
  }

  void _onPressNextButton() {
    _bloc.add(NextButtonEvent());
  }
}
