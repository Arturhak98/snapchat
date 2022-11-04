import 'package:flutter/material.dart';

class ErrorAlert extends StatefulWidget {
  const ErrorAlert(
      {required this.ErrorMsg, /* required this.buttonPressed */ super.key});
  final String ErrorMsg;
  @override
  State<ErrorAlert> createState() => _ErrorAlertState();
}

class _ErrorAlertState extends State<ErrorAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text(widget.ErrorMsg),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () =>  Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
