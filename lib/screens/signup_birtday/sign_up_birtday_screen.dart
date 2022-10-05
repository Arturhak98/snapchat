import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/snapchat_localization.dart';
import 'package:intl/intl.dart';
import 'package:snapchat/components/models/user.dart';
import 'package:snapchat/components/style/style.dart';
import 'package:snapchat/components/widgets/back_button.dart';
import 'package:snapchat/components/widgets/change_focus.dart';
import 'package:snapchat/components/widgets/error_text_widget.dart';
import 'package:snapchat/components/widgets/next_button_screen.dart';

import '../signup_phone_or_email/sign_up_phone_or_email.dart';
import 'bloc/sign_up_birtday_bloc.dart';

class SignUpBirtDay extends StatefulWidget {
  const SignUpBirtDay({required this.user,/*  required this.users, */ super.key});
  /* final List<User> users; */

  final User user;
  @override
  State<SignUpBirtDay> createState() => _SignUpBirtDayState();
}

class _SignUpBirtDayState extends State<SignUpBirtDay> {
  late final SignUpBirtdayBloc _bloc;
  bool _isValid = true;

  final now = DateTime.now();
  String _selectDateText = DateFormat.yMMMMd().format(DateTime.now());

  @override
  void initState() {
    _bloc = SignUpBirtdayBloc();
    _bloc.add(SignUpBirtdayLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<SignUpBirtdayBloc, SignUpBirtdayState>(
        listener: (context, state) {
          if (state is UpdateBirtdayValid) {
            _isValid = state.birtdayValid;
            _selectDateText = state.seleqtedDate;
          }
          if (state is UpdateUserState) {
            widget.user.dateOfBirthday = state.birtday;
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => SignUpPhoneOrEmail(
                      user: widget.user,/*  users: widget.users */)),
            );
          }
          if (state is SetDateState) {
            _selectDateText = state.birtdayText;
          }
        },
        builder: (context, state) {
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
        },
      ),
    );
  }

  Widget _renderTitle() {
    return Center(
        child: Text(
      AppLocalizations.of(context)!.birthdaytitle,
      style: TitleStyle,
    ));
  }

  Widget _renderFieldTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        AppLocalizations.of(context)!.birthdayfieldtitle,
        style: FieldTitleStyle,
      ),
    );
  }

  Widget _renderBirtdayField() {
    final fieldText = TextEditingController(text: _selectDateText);
    return TextField(
      readOnly: true,
      controller: fieldText,
    );
  }

  Widget _renderErrorTextWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 170),
      child: ErorrText(errorText: AppLocalizations.of(context)!.birthdayfielderror, isValid: _isValid),
    );
  }

  Widget _renderNextButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: NextButton(
        OnButtonTup: _onPressNextButton,
        buttonText:  AppLocalizations.of(context)!.nextbutton,
        isValid: _isValid,
      ),
    );
  }

  Widget _renderPicker() {
    return SizedBox(
      height: 250,
      child: CupertinoDatePicker(
        onDateTimeChanged: (value) =>
            _bloc.add(DatePickerEvent(SelectDate: value)),
        mode: CupertinoDatePickerMode.date,
        initialDateTime: DateTime(now.year - 16, now.month, now.day),
        maximumDate: DateTime.now(),
      ),
    );
  }

  void _onPressNextButton() {
    _bloc.add(NextButtonEvent());
  }
}
