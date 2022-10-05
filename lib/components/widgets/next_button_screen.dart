import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton(
      {required this.buttonText,
      required this.isValid,
      required this.OnButtonTup,
      super.key});

  final String buttonText;
  final Function() OnButtonTup;
  final bool isValid;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        onPressed: () => isValid ? OnButtonTup() : null,
        style: ButtonStyle(
          backgroundColor: isValid
              ? const MaterialStatePropertyAll(
                  Color.fromARGB(255, 33, 150, 243))
              : const MaterialStatePropertyAll(
                  Color.fromARGB(255, 185, 192, 199)),
          fixedSize: const MaterialStatePropertyAll(Size(300, 60)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
