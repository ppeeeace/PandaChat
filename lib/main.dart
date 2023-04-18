import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/home_screen.dart';
import 'package:chat/screens/login_screen.dart';
import 'package:chat/screens/signup_screen.dart';
import 'package:chat/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return MaterialApp(
        routes: {
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          SignupScreen.id: (context) => const SignupScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          ChatScreen.id: (context) => ChatScreen(),
        },
        debugShowCheckedModeBanner: false,
        home: const WelcomeScreen(),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
        routes: {
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          SignupScreen.id: (context) => const SignupScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          ChatScreen.id: (context) => ChatScreen(),
        },
      );
    }
  }
}
