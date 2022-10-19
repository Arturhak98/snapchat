import 'package:flutter/material.dart';
class ErrorText extends StatelessWidget {
  const ErrorText({required this.isValid, required this.errorText, super.key});
final bool isValid;
final String errorText;
  @override
  Widget build(BuildContext context) {
     if (isValid) {
      return const Text('');
    } else {
      return  Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          errorText,
          style:const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    }
  }
}