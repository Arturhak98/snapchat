import 'package:flutter/material.dart';

import 'back_button.dart';
import 'change_focus.dart';
import 'next_button_screen.dart';

class ScreenSample extends StatelessWidget {
  const ScreenSample(
      {required this.children,
      required this.isvalid,
      required this.onPressNextButton,
      this.buttonText = '',
      super.key});
  final List<Widget> children;
  final String buttonText;
  final bool isvalid;
  final Function() onPressNextButton;

  @override
  Widget build(BuildContext context) {
    return ChangeFocus(
      child: Scaffold(
        body: Stack(
          children: [
            const BackButtonWidget(),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: SingleChildScrollView(
                reverse: true,
                clipBehavior: Clip.none,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children),
              ),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(),
                NextButton(
                  buttonText: buttonText,
                  isValid: isvalid,
                  OnButtonTup: onPressNextButton,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
