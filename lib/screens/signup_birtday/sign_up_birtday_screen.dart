import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/back_button.dart';
import 'package:snapchat/components/widgets/change_focus.dart';
import 'package:snapchat/components/widgets/error_text_widget.dart';
import 'package:snapchat/components/widgets/next_button_screen.dart';
import 'package:snapchat/middle_wares/validation_repository.dart';
import '../signup_phone_or_email/sign_up_phone_or_email.dart';
import 'bloc/sign_up_birtday_bloc.dart';

class SignUpBirtDay extends StatefulWidget {
  const SignUpBirtDay({required this.user, super.key});

  final User user;
  @override
  State<SignUpBirtDay> createState() => _SignUpBirtDayState();
}

class _SignUpBirtDayState extends State<SignUpBirtDay> {
  final SignUpBirtdayBloc _bloc = SignUpBirtdayBloc(validation: ValidationRepository());
  bool _isValid = true;
  final now = DateTime.now();
  final _fieldController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  
  @override
  void initState() {
    _selectedDate = DateTime(now.year - 16, now.month, now.day);
    _fieldController.text=DateFormat.yMMMMd().format(_selectedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<SignUpBirtdayBloc, SignUpBirtdayState>(
          listener: _signUpBirtDayListner,
          builder: (context, state) => _render()),
    );
  }

  Widget _render() {
    return ChangeFocus(
      child: Scaffold(
        body: Stack(
          children: [
            const BackButtonWidget(),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  reverse: true,
                  clipBehavior: Clip.none,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _renderTitle(),
                      _renderFieldTitle(),
                      _renderBirtdayField(),
                      _renderErrorTextWidget(),
                      _renderNextButton(),
                      _renderPicker(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _renderTitle() {
    return Center(
        child: Text(
      'birthdaytitle'.i18n(),
      style: TitleStyle,
    ));
  }

  Widget _renderFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'birthdayfieldtitle'.i18n(),
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderBirtdayField() {
    return TextField(
      readOnly: true,
      controller: _fieldController,
    );
  }

  Widget _renderErrorTextWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 170),
      child:
          ErorrText(errorText: 'birthdayfielderror'.i18n(), isValid: _isValid),
    );
  }

  Widget _renderNextButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: NextButton(
        OnButtonTup: _onPressNextButton,
        buttonText: 'nextbutton'.i18n(),
        isValid: _isValid,
      ),
    );
  }

  Widget _renderPicker() {
    return SizedBox(
      height: 250,
      child: CupertinoDatePicker(
        onDateTimeChanged: (value) {
          _bloc.add(DatePickerEvent(selectDate: value));
          _fieldController.text = DateFormat.yMMMMd().format(value);
          _selectedDate=value;
        },
        mode: CupertinoDatePickerMode.date,
        initialDateTime: DateTime(now.year - 16, now.month, now.day),
        maximumDate: DateTime.now(),
      ),
    );
  }

  void _onPressNextButton() {
    widget.user.dateOfBirthday = _selectedDate;
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => SignUpPhoneOrEmail(
                user: widget.user,
              )),
    );
  }
}

extension _BlocListener on _SignUpBirtDayState {
  void _signUpBirtDayListner(BuildContext context, SignUpBirtdayState state) {
    if (state is UpdateBirtdayValid) {
      _isValid = state.birtdayValid;
    
    }
  }
}
