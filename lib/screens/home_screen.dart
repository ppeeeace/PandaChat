import 'package:chat/components/custom_button.dart';
import 'package:chat/constants.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });
  static const String id = 'Home Screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        title: const Text('PandaChat'),
      ),
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              splashColor: Colors.purple,
              borderRadius: BorderRadius.circular(24),
              backgroundColor: kSecondaryColor,
              height: 50,
              width: double.infinity,
              onTap: () {
                Navigator.pushNamed(context, ChatScreen.id);
              },
              child: const Text(
                'Chat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const SizedBox(height: 36),
            CustomButton(
              splashColor: Colors.purple,
              borderRadius: BorderRadius.circular(24),
              backgroundColor: kSecondaryColor,
              height: 50,
              width: double.infinity,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: const Text(
                'Log Out',
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
    );
  }
}
