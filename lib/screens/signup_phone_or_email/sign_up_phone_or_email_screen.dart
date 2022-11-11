import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:snapchat/components/models/country_code.dart';
import 'package:snapchat/components/models/country_notifier.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/error_alert.dart';
import 'package:snapchat/components/widgets/error_text_widget.dart';
import 'package:snapchat/components/widgets/screen_widget.dart';
import 'package:snapchat/middle_wares/repositories/api_repository.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';

import '../country_code/country_code_screen.dart';
import '../sign_up_username/sign_up_username_screen.dart';
import 'bloc/signup_phone_or_email_bloc.dart';

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
  bool _visibility = true;
  bool _validEmail = false;
  bool _validNumber = false;
  bool _countriesLoaded = false;
  bool _phoneIsBusy = false;
  bool _emailIsBusy = false;
  final _phoneController = TextEditingController();
  final _emailContrroler = TextEditingController();
  var _countries = <Country>[];
  final SignupPhoneOrEmailBloc _bloc = SignupPhoneOrEmailBloc(
    validation: ValidationRepository(),
    apirepository: ApiRepository(),
    sqlrepository: SqlDatabaseRepository(),
  );

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
          return _visibility
              ? _renderSignUpEmailScreen()
              : _renderSignUpPhoneScreen();
        },
      ),
    );
  }

  Widget _renderSignUpPhoneScreen() {
    return ScreenSample(
      buttonText: 'nextbutton'.tr(),
      onPressNextButton: _onPressPhoneNextButton,
      isvalid: _validNumber && _countriesLoaded && !_phoneIsBusy,
      children: [
        _renderPhoneTitle(),
        _renderPhoneButton(),
        _renderPhoneFieldTitle(),
        _renderNumberField(),
        _renderErrorNumberText(),
        _renderPhoneText(),
      ],
    );
  }

  Widget _renderSignUpEmailScreen() {
    return ScreenSample(
      buttonText: 'nextbutton'.tr(),
      isvalid: _validEmail && !_emailIsBusy,
      onPressNextButton: _onPressEmailNextButton,
      children: [
        _renderEmailTitle(),
        _renderEmailButton(),
        _renderEmailFieldTitle(),
        _renderEmailField(),
        _renderEmailErrorText(),
      ],
    );
  }

  Widget _renderPhoneTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 160),
      child: Center(
        child: Text(
          'phonetitle'.tr(),
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
        child: Text('phonebutton'.tr()),
      ),
    );
  }

  Widget _renderPhoneFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'phonefieldtitle'.tr(),
        style: const TextStyle(
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _renderNumberField() {
    return TextField(
      controller: _phoneController,
      onChanged: (value) {
        setState(() {
          _phoneIsBusy = true;
        });
        _bloc.add(NumberFieldEvent(
            phoneNumber: value,
            countryCode: Provider.of<CountryNotifier>(context, listen: false)
                .country
                .CountryCode));
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      autofocus: true,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(prefixIcon: _renderFieldButton()),
    );
  }

  Widget _renderFieldButton() {
    return Consumer<CountryNotifier>(
        builder: (context, countryNotifier, child) {
      return TextButton(
          onPressed: _countriesLoaded
              ? () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                        value: countryNotifier,
                        child: CountryCode(
                          countries: _countries,
                        )),
                  ));
                }
              : null,
          child: _countriesLoaded
              ? Text(
                  countryNotifier.country.CountryCodeString.replaceAllMapped(
                        RegExp(r'[A-Z]'),
                        (match) => String.fromCharCode(
                            match.group(0)!.codeUnitAt(0) + 127397),
                      ) +
                      ' +' +
                      countryNotifier.country.CountryCode,
                  style: const TextStyle(fontSize: 20),
                )
              : Text('loading'.tr(), style: const TextStyle(fontSize: 20)));
    });
  }

  Widget _renderErrorNumberText() {
    return ErrorText(isValid: _validNumber, errorText: 'phonefielderror'.tr());
  }

  Widget _renderPhoneText() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 100),
      child: Text(
        'phoneinfotext'.tr(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _renderEmailTitle() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 120),
        child: Text(
          'emailtitle'.tr(),
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
        child: Text('emailbutton'.tr()),
      ),
    );
  }

  Widget _renderEmailFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'emailfieldtitle'.tr(),
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderEmailField() {
    return TextField(
      controller: _emailContrroler,
      onChanged: (value) {
        setState(() {
          _emailIsBusy=true;
        });
        _bloc.add(EmailFieldEvent(email: value));
       
      },
      autofocus: true,
    );
  }

  Widget _renderEmailErrorText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child:
          ErrorText(isValid: _validEmail, errorText: 'emailfieladerror'.tr()),
    );
  }

  void _onPressPhoneNextButton() {
    widget.user.phone = Provider.of<CountryNotifier>(context, listen: false)
            .country
            .CountryCode +
        _phoneController.text;
    widget.user.email = '';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpUserName(
          user: widget.user,
        ),
      ),
    );
  }

  void _onPressEmailNextButton() {
    widget.user.email = _emailContrroler.text;
    widget.user.phone = '';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpUserName(
          user: widget.user,
        ),
      ),
    );
  }
}

extension _BlocListener on _SignUpPhoneOrEmailState {
  void _signUpPhoneOrEmailListner(
      BuildContext context, SignupPhoneOrEmailState state) {
    if (state is PhoneIsFree) {
      _phoneIsBusy = false;
    }
    if(state is EmailIsFree){
      _emailIsBusy=false;
    }
    if (state is ShowErrorAlertState) {
      showDialog(
        context: context,
        builder: (context) => ErrorAlert(
          ErrorMsg: state.errorMsg,
        ),
      );
      if (state.errorMsg.startsWith('500') &&
          state.errorMsg.startsWith('phone', 9)) {
        _phoneIsBusy = true;
      }
      if (state.errorMsg.startsWith('500') &&
          state.errorMsg.startsWith('email', 9)) {
        _emailIsBusy = true;
      }
    }
    if (state is UpdateEmailValid) {
      _validEmail = state.emailISValid;
    }
    if (state is UpdatePhoneValid) {
      _validNumber = state.numberIsValid;
    }
    if (state is SetCountriesState) {
      _countries = state.countries;
      context.read<CountryNotifier>().changeCountry = state.selectedCountry;
      _countriesLoaded = true;
    }
  }
}
