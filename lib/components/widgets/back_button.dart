import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Card(
        elevation: 0,
        color: const Color.fromARGB(1, 1, 1, 1),
        child: IconButton(
          onPressed: () => _pressbackbutton(context),
          icon: const Icon(Icons.chevron_left),
          iconSize: 40,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  void _pressbackbutton(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context);
  }
}
