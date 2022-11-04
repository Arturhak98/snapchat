import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/error_alert.dart';
import 'package:snapchat/components/widgets/error_text_widget.dart';
import 'package:snapchat/middle_wares/repositories/api_repository.dart';
import 'package:snapchat/middle_wares/repositories/sql_database_repository.dart';
import 'package:snapchat/middle_wares/repositories/validation_repository.dart';
import 'package:snapchat/screens/user_change/bloc/user_change_bloc.dart';

class UserChange extends StatefulWidget {
 // final User user;
  final Function(User user)? updateUser;
  const UserChange({required this.updateUser, super.key});
  @override
  State<UserChange> createState() => _UserChangeState();
}

class _UserChangeState extends State<UserChange> {
  User user=User();
  final  _firstNameController=TextEditingController();
  final _lastNameController=TextEditingController();
  final _birthDateController=TextEditingController();
  final _emailController=TextEditingController();
  final _phoneController=TextEditingController();
  final _userNameController=TextEditingController();
  final _passController=TextEditingController();
  bool _isFirstNameValid = true;
  bool _isLastNameValid = true;
  bool _isBirthDayValid = true;
  bool _isEmailValid = true;
  bool _isPhoneValid = true;
  bool _isUserNameValid = true;
  bool _isPassValid = true;
  final _bloc = UserChangeBloc(
      validationRepository: ValidationRepository(),
      apiRepository: ApiRepository(),
      sqlDatabaseRepository: SqlDatabaseRepository());

  @override
  void initState() {
    _bloc.add(LoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<UserChangeBloc, UserChangeState>(
        listener: (context, state) => _userChangeListner(context, state),
        builder: (context, state) => _render(),
      ),
    );
  }

  Widget _render() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _renderFirstNameFieldTitle(),
                _renderFirstNameField(),
                _renderFirstNameError(),
                _renderLastNameFieldTitle(),
                _renderLastNameField(),
                _renderLastNameError(),
                _renderBirthDateFieldTitle(),
                _renderBirthDateField(),
                _renderBirthDateError(),
                _renderEmailFieldTitle(),
                _renderEmailField(),
                _renderEmailError(),
                _renderPhoneFieldTitle(),
                _renderPhoneField(),
                _renderPhoneError(),
                _renderUserNameFieldTitle(),
                _renderUserNameField(),
                _renderUserNameError(),
                _renderPassFieldTitle(),
                _renderPassField(),
                _renderPassError(),
                _renderEditButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderFirstNameFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'namefieldtitle'.tr(),
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderFirstNameField() {
    return TextField(
      controller: _firstNameController,
      onChanged: (value) => _bloc.add(FirstNameFieldEvent(firstName: value)),
    );
  }

  Widget _renderFirstNameError() {
    return ErrorText(
        isValid: _isFirstNameValid, errorText: 'namefielderror'.tr());
  }

  Widget _renderLastNameFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'lastnamefieldtitle'.tr(),
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderLastNameField() {
    return TextField(
      controller: _lastNameController,
      onChanged: (value) => _bloc.add(LastNameFieldEvent(lastName: value)),
    );
  }

  Widget _renderLastNameError() {
    return ErrorText(
        isValid: _isLastNameValid, errorText: 'lastnamefielderror'.tr());
  }

  Widget _renderBirthDateFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'birthdayfieldtitle'.tr(),
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderBirthDateField() {
    return TextField(
      readOnly: true,
      controller: _birthDateController,
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (_) => _renderDatePicker(),
        );
      },
    );
  }

  Widget _renderDatePicker() {
    FocusManager.instance.primaryFocus?.unfocus();
    return Container(
      height: 320,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 250,
            child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: user.dateOfBirthday,
                onDateTimeChanged: (value) {
                  _bloc.add(BirthDayChangeEvent(birthDay: value));
                  _birthDateController.text =
                      value.toString(); // DateFormat.yMMMMd().format(value);
                }),
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  Widget _renderBirthDateError() {
    return ErrorText(
        isValid: _isBirthDayValid, errorText: 'birthdayfielderror'.tr());
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
      controller: _emailController,
      onChanged: (value) => _bloc.add(EmailFieldEvent(email: value)),
    );
  }

  Widget _renderEmailError() {
    return ErrorText(
        isValid: _isEmailValid, errorText: 'emailfieladerror'.tr());
  }

  Widget _renderPhoneFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'phonefieldtitle'.tr(),
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderPhoneField() {
    return TextField(
      keyboardType: TextInputType.number,
      controller: _phoneController,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) => _bloc.add(PhoneFieldEvent(phone: value)),
    );
  }

  Widget _renderPhoneError() {
    return ErrorText(
        isValid: _isPhoneValid, errorText: 'phonefielderror'.tr());
  }

  Widget _renderUserNameFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'usernamefieldtitle'.tr(),
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderUserNameField() {
    return TextField(
      controller: _userNameController,
      onChanged: (value) => _bloc.add(UserNameFieldEvent(userName: value)),
    );
  }

  Widget _renderUserNameError() {
    return ErrorText(
        isValid: _isUserNameValid, errorText: 'usernamefielderror'.tr());
  }

  Widget _renderPassFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'passfieldtitle'.tr(),
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderPassField() {
    return TextField(
      controller: _passController,
      onChanged: (value) => _bloc.add(PassFieldEvent(pass: value)),
    );
  }

  Widget _renderPassError() {
    return ErrorText(isValid: _isPassValid, errorText: 'passfilederror'.tr());
  }

  Widget _renderEditButton() {
    /* user
      ..name = _firstNameController.text
      ..lastName = _lastNameController.text
      ..dateOfBirthday = DateTime.parse(_birthDateController.text)
      ..email = _emailController.text
      ..phone = _phoneController.text
      ..userName = _userNameController.text
      ..password = _passController.text; */
    return ElevatedButton(
      onPressed: _isFirstNameValid &&
              _isLastNameValid &&
              _isBirthDayValid &&
              _isEmailValid &&
              _isPhoneValid &&
              _isUserNameValid &&
              _isPassValid
          ?() {_bloc.add(EditButtonEvent(user: user));
          user
      ..name = _firstNameController.text
      ..lastName = _lastNameController.text
      ..dateOfBirthday = DateTime.parse(_birthDateController.text)
      ..email = _emailController.text
      ..phone = _phoneController.text
      ..userName = _userNameController.text
      ..password = _passController.text;
          }
          : null,
      child: const Text('EDIT'),
    );
  }

}

extension _BlocListener on _UserChangeState {
  void _userChangeListner(BuildContext context, UserChangeState state) {
    if(state is UserLoadedState){
   _firstNameController.text=state.user.name;
   _lastNameController.text=state.user.lastName;
   _birthDateController.text=state.user.dateOfBirthday.toString();
   _emailController.text=state.user.email;
   _phoneController.text=state.user.phone;
   _userNameController.text=state.user.userName;
   _passController.text=state.user.password;
      user=state.user;
    }
    if (state is FirstNameValidState) {
      _isFirstNameValid = state.firstNameIsValid;
    }
    if (state is LastNameValidState) {
      _isLastNameValid = state.lastNameIsValid;
    }
    if (state is BirthDayValidState) {
      _isBirthDayValid = state.birthdayIsValid;
    }
    if (state is EmailValidState) {
      _isEmailValid = state.emailIsValid;
    }
    if (state is PhoneValidState) {
      _isPhoneValid = state.phoneIsValid;
    }
    if (state is PhoneValidState) {
      _isPhoneValid = state.phoneIsValid;
    }
    if (state is UserNameValidState) {
      _isUserNameValid = state.userNameIsValid;
    }
    if (state is PassValidState) {
      _isPassValid = state.passIsValid;
    }
    if (state is UserUpdateState) {
      widget.updateUser?.call(user);
      Navigator.of(context).pop();
    }
    if (state is ErrorAlertState) {
         showDialog(
        context: context,
        builder: (context) => ErrorAlert(
          ErrorMsg: state.error,
        ),
      );
    }
  }
}
