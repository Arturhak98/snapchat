import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/snapchat_localization.dart';
import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/error_text_widget.dart';
import 'package:snapchat/components/widgets/screen_widget.dart';

import '../country_code/country_code_screen.dart';
import '../sign_up_username/sign_up_username_screen.dart';
import 'bloc/signup_phone_or_email_bloc_bloc.dart';

class SignUpPhoneOrEmail extends StatefulWidget {
  const SignUpPhoneOrEmail({
  /*   required this.users, */
    required this.user,
    super.key,
  });

/*   final List<User> users; */
  final User user;

  @override
  State<SignUpPhoneOrEmail> createState() => _SignUpPhoneOrEmailState();
}

class _SignUpPhoneOrEmailState extends State<SignUpPhoneOrEmail> {
  Country selectedCountry = Country(
    CountryCode: '',
    CountryName: '',
    CountryCodeString: '',
  );

  bool _visibility = true,
      _validEmail = false,
      _validNumber = false,
      _countriesLoaded = false;
  var _countries = <Country>[];
  late final SignupPhoneOrEmailBloc _bloc;

  @override
  void initState() {
    _bloc = SignupPhoneOrEmailBloc();
    _bloc.add(SignUpPhoneLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<SignupPhoneOrEmailBloc, SignupPhoneOrEmailState>(
        listener: (context, state) {
          if (state is ShowErrorAlertState) {
            _showErroeMsg(state.erorrMsg);
          }
          if (state is UpdateEmailValid) {
            _validEmail = state.emailISValid;
          }
          if (state is UpdateScreen) {
            _visibility = state.visibility;
          }
          if (state is UpdatePhoneValid) {
            _validNumber = state.numberIsValid;
          }
          if (state is SetCountriesState) {
            _countries = state.countries;
            selectedCountry = state.selectedCountry;
            _countriesLoaded = true;
          }
          if (state is SetSelectedCountryState) {
            selectedCountry = state.selectedCountry;
          }
          if (state is UpdateUserState) {
            widget.user.emailOrPhoneNumber = state.emailorphonenumber;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SignUpUserName(user: widget.user,/*  users: widget.users */)));
          }
        },
        builder: (context, state) {
          return _visibility ? _signUpEmailScreen() : _signUpPhoneScreen();
        },
      ),
    );
  }

  Widget _signUpPhoneScreen() {
    return ScreenSample(
      buttonText: AppLocalizations.of(context)!.nextbutton,
      onPressNextButton: _onPressPhoneNextButton,
      isvalid: _validNumber && _countriesLoaded,
      children: [
        _renderPhoneTitle(),
        _renderPhoneButton(),
        _renderPhoneFieldTitle(),
        _renderNumberField(),
        _renderErrorNumberTextWidget(),
        _renderPhoneText(),
      ],
    );
  }

  Widget _signUpEmailScreen() {
    return ScreenSample(
        buttonText: AppLocalizations.of(context)!.nextbutton,
        isvalid: _validEmail,
        onPressNextButton: _onPressEmailNextButton,
        children: [
          _renderEmailTitle(),
          _renderEmailButton(),
          _renderEmailFieldTitle(),
          _renderEmailField(),
          _renderEmailErrorText(),
        ]);
  }

  Widget _renderPhoneTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 160),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.phonetitle,
          style: TitleStyle,
        ),
      ),
    );
  }

  Widget _renderPhoneButton() {
    return Center(
      child: TextButton(
        onPressed: () =>
            _bloc.add(ChangeScreenButtonEvent(visibility: _visibility)),
        child: Text(AppLocalizations.of(context)!.phonebutton),
      ),
    );
  }

  Widget _renderPhoneFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        AppLocalizations.of(context)!.phonefieldtitle,
        style: const TextStyle(
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _renderNumberField() {
    return TextField(
      onChanged: (value) => _bloc.add(NumberFieldEvent(phoneNumber: value)),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      autofocus: true,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(prefixIcon: _renderFieldButton()),
    );
  }

  Widget _renderFieldButton() {
    return TextButton(
      onPressed: _countriesLoaded
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CountryCode(
                    OnCountryChanged: ChangeCountry,
                    countries: _countries,
                  ),
                ),
              );
            }
          : null,
      child: _countriesLoaded
          ? Text(
              selectedCountry.CountryCodeString.replaceAllMapped(
                    RegExp(r'[A-Z]'),
                    (match) => String.fromCharCode(
                        match.group(0)!.codeUnitAt(0) + 127397),
                  ) +
                  ' +' +
                  selectedCountry.CountryCode,
              style: const TextStyle(fontSize: 20),
            )
          : Text(AppLocalizations.of(context)!.loading,
              style: const TextStyle(fontSize: 20)),
    );
  }

  Widget _renderErrorNumberTextWidget() {
    return ErorrText(
        isValid: _validNumber,
        errorText: AppLocalizations.of(context)!.phonefielderror);
  }

  Widget _renderPhoneText() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 100),
      child: Text(
        AppLocalizations.of(context)!.phoneinfotext,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _renderEmailTitle() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 120),
        child: Text(
          AppLocalizations.of(context)!.emailtitle,
          style: TitleStyle,
        ),
      ),
    );
  }

  Widget _renderEmailButton() {
    return Center(
      child: TextButton(
        onPressed: () =>
            _bloc.add(ChangeScreenButtonEvent(visibility: _visibility)),
        child: Text(AppLocalizations.of(context)!.emailbutton),
      ),
    );
  }

  Widget _renderEmailFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        AppLocalizations.of(context)!.emailfieldtitle,
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderEmailField() {
    return TextField(
      onChanged: (value) => {_bloc.add(EmailFieldEvent(email: value))},
      autofocus: true,
    );
  }

  Widget _renderEmailErrorText() {
    return ErorrText(
        isValid: _validEmail,
        errorText: AppLocalizations.of(context)!.emailfieladerror);
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
                _bloc.add(SignUpPhoneLoadEvent());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onPressPhoneNextButton() {
    _bloc.add(PhoneNextButtonEvent());
  }

  void _onPressEmailNextButton() {
    _bloc.add(EmailNextButtonEvent());
  }

  void ChangeCountry(Country country) {
    _bloc.add(SelectCountryEvent(selectedCountry: country));
  }
}
