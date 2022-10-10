import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:snapchat/middle_wares/database.dart';
import 'package:snapchat/screens/signup_name/sign_up_name_screen.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatefulWidget {
 const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
@override
  void initState() {
    DataBase.init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 253, 1, 1),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             
              _renderImage(),
              _renderButtonWidget(
                  const Color.fromRGBO(239, 62, 90, 1),
                  'login'.i18n(),
                  context,
                const  LogInScreen()),
              _renderButtonWidget(
                  const Color.fromRGBO(36, 175, 252, 1),
                  'signup'.i18n(),
                  context,
                const  SignUpName()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderImage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 170),
      child: Image.asset('images/snapchat.webp'),
    );
  }

  Widget _renderButtonWidget(Color buttonColor, String buttonText,
      BuildContext context, Widget nextScreen) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _pressOnButton(nextScreen, context),
            style: ButtonStyle(
              shape: const MaterialStatePropertyAll(RoundedRectangleBorder()),
              backgroundColor: MaterialStatePropertyAll(buttonColor),
              fixedSize: const MaterialStatePropertyAll(
                Size(20, 80),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _pressOnButton(Widget nextScreen, BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => nextScreen));
  }
}
