import 'package:chat/widgets/custom_button.dart';
import 'package:chat/constants.dart';
import 'package:chat/screens/login_screen.dart';
import 'package:chat/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static const String id = 'Welcome Screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 110),
              const Text(
                'Welcome to PandaChat',
                style: TextStyle(
                  fontSize: 23,
                  fontFamily: 'Pacifico',
                  color: Colors.white,
                ),
              ),
              const Image(
                image: AssetImage('assets/images/panda.png'),
                height: 220,
                width: 200,
              ),
              const SizedBox(height: 22),
              CustomButton(
                splashColor: Colors.purple,
                borderRadius: BorderRadius.circular(24),
                backgroundColor: kSecondaryColor,
                height: 50,
                width: double.infinity,
                onTap: () =>
                    Navigator.pushReplacementNamed(context, LoginScreen.id),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CustomButton(
                splashColor: Colors.purple,
                borderRadius: BorderRadius.circular(24),
                backgroundColor: kSecondaryColor,
                height: 50,
                width: double.infinity,
                onTap: () =>
                    Navigator.pushReplacementNamed(context, SignupScreen.id),
                child: const Text(
                  'SIGNUP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
