import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/error_text_widget.dart';
import 'package:snapchat/components/widgets/screen_widget.dart';
import 'package:snapchat/middle_wares/validation_repository.dart';

import '../country_code/country_code_screen.dart';
import '../sign_up_username/sign_up_username_screen.dart';
import 'bloc/signup_phone_or_email_bloc_bloc.dart';

class SignUpPhoneOrEmail extends StatefulWidget {
  const SignUpPhoneOrEmail({
    required this.user,
    super.key,
  });

  final User user;

  @override
  State<SignUpPhoneOrEmail> createState() => _SignUpPhoneOrEmailState();
}

class _SignUpPhoneOrEmailState extends State<SignUpPhoneOrEmail> {
  Country selectedCountry =
      Country(CountryCode: '', CountryName: '', CountryCodeString: '');
  bool _visibility = true;
  bool _validEmail = false;
  bool _validNumber = false;
  bool _countriesLoaded = false;
  final _phoneController = TextEditingController();
  final _emailContrroler = TextEditingController();
  var _countries = <Country>[];
  final SignupPhoneOrEmailBloc _bloc = SignupPhoneOrEmailBloc(validation: ValidationRepository());

  @override
  void initState() {
    _bloc.add(SignUpPhoneLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<SignupPhoneOrEmailBloc, SignupPhoneOrEmailState>(
        listener: _signUpPhoneOrEmailListner,
        builder: (context, state) {
          return _visibility ? _signUpEmailScreen() : _signUpPhoneScreen();
        },
      ),
    );
  }

  Widget _signUpPhoneScreen() {
    return ScreenSample(
      buttonText: 'nextbutton'.i18n(),
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
        buttonText: 'nextbutton'.i18n(),
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
          'phonetitle'.i18n(),
          style: TitleStyle,
        ),
      ),
    );
  }

  Widget _renderPhoneButton() {
    return Center(
      child: TextButton(
        onPressed: () => setState(() {
          _visibility = !_visibility;
        }),
        child: Text('phonebutton'.i18n()),
      ),
    );
  }

  Widget _renderPhoneFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'phonefieldtitle'.i18n(),
        style: const TextStyle(
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _renderNumberField() {
    return TextField(
      controller: _phoneController,
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
          : Text('loading'.i18n(), style: const TextStyle(fontSize: 20)),
    );
  }

  Widget _renderErrorNumberTextWidget() {
    return ErorrText(
        isValid: _validNumber, errorText: 'phonefielderror'.i18n());
  }

  Widget _renderPhoneText() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 100),
      child: Text(
        'phoneinfotext'.i18n(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _renderEmailTitle() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 120),
        child: Text(
          'emailtitle'.i18n(),
          style: TitleStyle,
        ),
      ),
    );
  }

  Widget _renderEmailButton() {
    return Center(
      child: TextButton(
        onPressed: () => setState(() {
          _visibility = !_visibility;
        }),
        child: Text('emailbutton'.i18n()),
      ),
    );
  }

  Widget _renderEmailFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'emailfieldtitle'.i18n(),
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderEmailField() {
    return TextField(
      controller: _emailContrroler,
      onChanged: (value) => {_bloc.add(EmailFieldEvent(email: value))},
      autofocus: true,
    );
  }

  Widget _renderEmailErrorText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child:
          ErorrText(isValid: _validEmail, errorText: 'emailfieladerror'.i18n()),
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
    widget.user.emailOrPhoneNumber =selectedCountry.CountryCode+_phoneController.text;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpUserName(
          user: widget.user,
        ),
      ),
    );
  }

  void _onPressEmailNextButton() {
    widget.user.emailOrPhoneNumber = _emailContrroler.text;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpUserName(
          user: widget.user,
        ),
      ),
    );
  }

  void ChangeCountry(Country country) {
    setState(() {
      selectedCountry = country;
    });
  }
}

extension _BlocListener on _SignUpPhoneOrEmailState {
  void _signUpPhoneOrEmailListner(
      BuildContext context, SignupPhoneOrEmailState state) {
    if (state is ShowErrorAlertState) {
      _showErroeMsg(state.erorrMsg);
    }
    if (state is UpdateEmailValid) {
      _validEmail = state.emailISValid;
    }
    if (state is UpdatePhoneValid) {
      _validNumber = state.numberIsValid;
    }
    if (state is SetCountriesState) {
      _countries = state.countries;
      selectedCountry = state.selectedCountry;
      _countriesLoaded = true;
    }
  }
}
