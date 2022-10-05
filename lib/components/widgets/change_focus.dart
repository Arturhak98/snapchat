import 'package:flutter/material.dart';

class ChangeFocus extends StatelessWidget {
  const ChangeFocus({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
