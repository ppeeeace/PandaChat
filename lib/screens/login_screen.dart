import 'package:chat/components/custom_button.dart';
import 'package:chat/components/custom_text_field.dart';
import 'package:chat/constants.dart';
import 'package:chat/screens/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'Login Screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isLoading = false;

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(elevation: 0, backgroundColor: kPrimaryColor),
        backgroundColor: kPrimaryColor,
        body: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 28),
                  Row(
                    children: const [
                      Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  CustomTextFormField(
                    hint: 'Email',
                    iconn: Icons.email,
                    textType: TextInputType.emailAddress,
                    controller: emailController,
                    validate: validateEmail,
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    hint: 'Password',
                    iconn: Icons.lock,
                    textType: TextInputType.visiblePassword,
                    hideText: true,
                    controller: passwordController,
                    validate: validatePassword,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Log in',
                    onTap: () async {
                      if (_key.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          // ignore: unused_local_variable
                          UserCredential user = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          users.add({
                            'email': emailController.text,
                            'time': DateTime.now(),
                          });

                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                              (route) => false,
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            showSnackBar(
                                context, 'No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            showSnackBar(context,
                                'Wrong password provided for that user.');
                          } else {
                            showSnackBar(context, e.message.toString());
                          }
                        }
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!Navigator.canPop(context)) {
                            Navigator.pushNamed(context, SignupScreen.id);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          '  Sign up',
                          style: TextStyle(
                            color: Color(0xffC9624B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.red,
          ),
        ),
        backgroundColor: kPrimaryColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(24),
      ),
    );
  }

  String? validateEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) {
      return 'Email Address is required.';
    }
    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) {
      return 'Invalid Email Address format.';
    }
    return null;
  }

  String? validatePassword(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty) {
      return 'Password is required.';
    }
    return null;
  }
}
